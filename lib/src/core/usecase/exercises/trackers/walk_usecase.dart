import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/models/exercise_samples.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/exercise_sample_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/location_permission.dart';
import 'package:salud_ulv_app/src/core/services/error_handlers.dart';
import 'package:salud_ulv_app/src/core/services/exercise_services.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';
import 'package:salud_ulv_app/src/core/services/step_counter.dart';
import 'package:uuid/uuid.dart';

class WalkActivityUsecase
    implements IExerciseTrackUseCase, IStepTrackable, ILocationTrackable {
  final IExerciseLocalRepo exerciseLocalRepo;
  final IActivitySampleRepo aerobicSampleRepo;
  final ICurrentUserSession currentUserSession;

  final IAccelerometer accelerometerSensor;
  final IGeolocator geolocatorSensor;
  final ILocationPermissionService locationPermissionService;

  WalkActivityUsecase(
    this.exerciseLocalRepo,
    this.aerobicSampleRepo,
    this.currentUserSession,
    this.accelerometerSensor,
    this.geolocatorSensor,
    this.locationPermissionService,
  );

  // categoryID de Walk en ActivityCategory
  static const int _categoryID = 1;

  // MET aproximado para caminata a ritmo moderado (~3.5)
  static const double _walkingMet = 3.5;
  static const double _weightKg = 70;

  // Por encima de esta velocidad (m/s) no se cuentan pasos de caminata:
  // ya sería trote/carrera o ruido del GPS.
  static const double _maxStepSpeed = 2.5;

  final ExerciseTimer _timer = ExerciseTimer();

  static int _instanceCount = 0;
  final int _instanceId = ++_instanceCount;

  final StepDetector _stepCounter = StepDetector();

  String? _activityID;
  String? _userUUID;
  DateTime date = DateTime.now().toUtc();

  String get activityID {
    if (_activityID == null) {
      throw StateError('Activity has not started');
    }
    return _activityID!;
  }

  static const Duration _snapshotInterval = Duration(seconds: 5);

  Timer? _snapshotTimer;
  bool _snapshotBusy = false;
  bool _isPaused = false;
  int _steps = 0;

  int _lastSnapshotSteps = 0;
  double _lastSnapshotDistance = 0.0;
  double _lastSnapshotElevation = 0.0;
  double _lastSnapshotCaloriesBurned = 0.0;
  Duration _lastSnapshotElapsed = Duration.zero;

  StreamSubscription? _accelSub;

  @override
  Stream<Duration>? get elapsedStream => _timer.stream;

  @override
  Duration? get elapsed => _timer.elapsed;

  @override
  double? get distance => geolocatorSensor.distance;

  @override
  double? get caloriesBurned {
    final e = elapsed;
    if (e == null) return 0;
    return calculateCalories(elapsed: e, weightKg: _weightKg, met: _walkingMet);
  }

  @override
  int? get steps => _steps;

  bool get isPaused => _timer.isPaused;

  @override
  Coordinates? get startLocation {
    final lat = geolocatorSensor.startLatitude;
    final lng = geolocatorSensor.startLongitude;
    if (lat == null || lng == null) return null;
    return Coordinates(latitude: lat, longitude: lng);
  }

  @override
  Coordinates? get currentLocation {
    // latitude/longitude arrancan en 0.0 hasta la primera lectura;
    // usa startLatitude como señal de que ya hay un fix real.
    if (geolocatorSensor.startLatitude == null) return null;
    return Coordinates(
      latitude: geolocatorSensor.latitude,
      longitude: geolocatorSensor.longitude,
    );
  }

  @override
  Future<void> start() async {
    // 1. Validar todo ANTES de crear un ID.
    await locationPermissionService.request();
    final locationGranted = await locationPermissionService.isGranted();
    if (!locationGranted) return;

    final userUUID = await currentUserSession.getCurrentUserUUID();
    if (userUUID == null) return;

    // 2. Estado limpio
    _activityID = const Uuid().v4().toUpperCase();
    _userUUID = userUUID;
    debugPrint('WalkID: $activityID');

    _steps = 0;
    _isPaused = false;
    _lastSnapshotSteps = 0;
    _lastSnapshotDistance = 0.0;
    _lastSnapshotElevation = 0.0;
    _lastSnapshotCaloriesBurned = 0.0;
    _lastSnapshotElapsed = Duration.zero;

    // 3. Crear la fila en BD
    await exerciseLocalRepo.setIDs(activityID, userUUID, _categoryID, date);

    await geolocatorSensor.start(1, 4, 1);
    await accelerometerSensor.start();

    final accelStream = streamSpeedReductor(accelerometerSensor.magnitude, 50);

    _accelSub = accelStream.listen((raw) {
      final step = _stepCounter.update(raw!);

      if (step &&
          geolocatorSensor.hasMovement &&
          geolocatorSensor.speed < _maxStepSpeed) {
        _steps++;
      }
    });

    _timer.start();
    _startSnapshotTimer();
  }

  @override
  void pause() {
    _isPaused = true;
    geolocatorSensor.pause();
    accelerometerSensor.pause();
    _accelSub?.pause();
    _timer.pause();
    _snapshotTimer?.cancel();
  }

  @override
  void resume() {
    _isPaused = false;
    geolocatorSensor.resume();
    accelerometerSensor.resume();
    _accelSub?.resume();
    _timer.resume();
    _startSnapshotTimer();
  }

  @override
  void reset() {
    // Cancelar el timer primero para que un tick tardío no lea valores reseteados.
    _snapshotTimer?.cancel();
    _snapshotTimer = null;

    accelerometerSensor.reset();
    geolocatorSensor.reset();
    _timer.reset();
    _steps = 0;
    _isPaused = false;

    _lastSnapshotSteps = 0;
    _lastSnapshotDistance = 0.0;
    _lastSnapshotElevation = 0.0;
    _lastSnapshotCaloriesBurned = 0.0;
    _lastSnapshotElapsed = Duration.zero;
  }

  // ---------------------------------------------------------------------------
  // STOP / DISCARD
  // ---------------------------------------------------------------------------
  Future<void> _stopEverything() async {
    _snapshotTimer?.cancel();
    _snapshotTimer = null;
    _timer.stop();
    geolocatorSensor.stop();
    accelerometerSensor.stop();
    await _accelSub?.cancel();
    _accelSub = null;
  }

  @override
  Future<void> stopAndSave() async {
    await _stopEverything();
    reset();
  }

  @override
  Future<void> discard() async {
    await _stopEverything();

    // Nada que borrar si start() nunca llegó a crear la fila.
    final id = _activityID;
    if (id != null) {
      try {
        final userUUID =
            _userUUID ?? await currentUserSession.getCurrentUserUUID();
        if (userUUID != null) {
          await exerciseLocalRepo.delete(userUUID, id);
        }
        await aerobicSampleRepo.delete(id);
        debugPrint('cleanup successful ');
      } catch (e) {
        debugPrint('discard() cleanup failed: $e');
      }
    }

    reset();
  }

  @override
  Future<void> save() async {
    pause();

    final currentElapsed = elapsed;
    final currentSteps = steps;

    if (currentElapsed == null ||
        currentElapsed.inSeconds < 10 ||
        currentSteps == null ||
        currentSteps == 0) {
      await discard();
      throw ExerciseValidationException(
        'No es posible guardar actividades menores a 10 segundos o sin pasos realizados',
      );
    }

    final sampleData = await aerobicSampleRepo.getSamples(activityID);
    if (sampleData == null || sampleData.isEmpty) {
      await discard();
      throw ExerciseValidationException(
        'No hay datos suficientes para guardar esta actividad',
      );
    }

    final stepsList = sampleData
        .map((sample) => sample.steps)
        .whereType<int>()
        .toList();

    final paceList = sampleData
        .map((sample) => sample.pace)
        .whereType<double>()
        .where((value) => value.isFinite)
        .toList();

    final elevationList = sampleData
        .map((sample) => sample.elevation)
        .whereType<double>()
        .toList();

    debugPrint('Making walk class');

    final walkData = Walk(
      activityID: activityID,
      duration: currentElapsed,
      distance: distance ?? 0,
      caloriesBurned: calculateCaloriesBurned(
        currentElapsed,
        _walkingMet,
        _weightKg,
      ),
      elevationGain:
          elevationList.isEmpty ? 0 : totalElevationGain(elevationList),
      avgCadence: calculateStepsPerMinute(currentSteps, currentElapsed),
      avgPace: paceList.isEmpty ? 0 : avgCalculator(paceList),
      steps: currentSteps,
      avgSteps: stepsList.isEmpty ? 0 : valueByTime(stepsList, 60),
      registeredAt: date,
    );

    debugPrint('Saving walk: ${walkData.steps}');

    await exerciseLocalRepo.save(walkData);
    await stopAndSave();
  }

  void _startSnapshotTimer() {
    debugPrint('Starting snapshot timer for instance $_instanceId');
    _snapshotTimer?.cancel();
    _snapshotTimer = Timer.periodic(_snapshotInterval, (_) => _takeSnapshot());
  }

  Future<void> _takeSnapshot() async {
    if (_snapshotBusy || _activityID == null) return;

    final currentElapsed = elapsed;
    final currentSteps = steps;
    final currentDistance = distance;
    if (currentElapsed == null ||
        currentSteps == null ||
        currentDistance == null) {
      return;
    }

    final interval = currentElapsed - _lastSnapshotElapsed;
    if (interval.inMilliseconds <= 0) return;

    _snapshotBusy = true;
    try {
      final currentElevation = geolocatorSensor.elevation;

      final currentCalories = calculateCalories(
        elapsed: currentElapsed,
        weightKg: _weightKg,
        met: _walkingMet,
      );

      // Deltas respecto a los acumulados previos
      final stepsDelta = currentSteps - _lastSnapshotSteps;
      final distanceDelta = currentDistance - _lastSnapshotDistance;
      final elevationDelta = currentElevation - _lastSnapshotElevation;
      final caloriesDelta = currentCalories - _lastSnapshotCaloriesBurned;

      // Tasas del intervalo
      final cadence = calculateCadence(stepsDelta, interval);
      final pace = geolocatorSensor.hasMovement
          ? calculatePace(interval, distanceDelta)
          : 0.0;
      final currentSpeed = geolocatorSensor.speed;

      final snapshotData = WalkActivitySample(
        activityID: activityID,
        timestampMs: currentElapsed,
        steps: stepsDelta,
        distance: distanceDelta,
        calories: caloriesDelta,
        elevation: elevationDelta,
        cadence: cadence,
        pace: pace,
        speed: currentSpeed,
        heartRate: 0,
        latitude: geolocatorSensor.latitude,
        longitude: geolocatorSensor.longitude,
      );

      await aerobicSampleRepo.save(snapshotData);

      _lastSnapshotSteps = currentSteps;
      _lastSnapshotDistance = currentDistance;
      _lastSnapshotElevation = currentElevation;
      _lastSnapshotCaloriesBurned = currentCalories;
      _lastSnapshotElapsed = currentElapsed;

      debugPrint(
        'Snapshot saved: activityID=$activityID steps=$stepsDelta '
        'distance=$distanceDelta calories=$caloriesDelta '
        'cadence=$cadence pace=$pace speed=$currentSpeed '
        'elapsed=$currentElapsed',
      );
    } catch (e, st) {
      // Un snapshot fallido nunca debe tumbar la sesión de tracking.
      debugPrint('Snapshot failed: $e\n$st');
    }
    finally {
      _snapshotBusy = false;
    }
  }
}