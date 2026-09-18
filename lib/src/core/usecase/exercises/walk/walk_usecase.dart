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
import 'package:salud_ulv_app/src/core/data/source/local/sensors/accelerometer_sensor.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sensors/geolocator_sensor.dart';
import 'package:salud_ulv_app/src/features/services/location_permition.dart';
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

  final ExerciseTimer _timer = ExerciseTimer();

  static int _instanceCount = 0;
  final int _instanceId = ++_instanceCount;

  String? _activityID;

  String get activityID {
    if (_activityID == null) {
      throw StateError('Activity has not started');
    }

    return _activityID!;
  }

  Timer? _snapshotTimer;
  bool _isPaused = false;
  int _steps = 0;
  DateTime? _minuteStart;

  final double _caloriesBurned = 0.0;
  // int _lastSnapshotSteps = 0;
  // double _lastSnapshotDistance = 0.0;
  // double _lastSnapshotElevation = 0.0;
  // // double _lastSnapshotCadence = 0.0;
  // // double _lastSnapshotPace = 0.0;
  // // double _lastSnapshotSpeed = 0.0;
  // double _lastSnapshotCaloriesBurned = 0.0;
  // // Duration _lastSnapshotElapsed =

  int _lastSnapshotSteps = 0;
  double _lastSnapshotDistance = 0.0;
  double _lastSnapshotElevation = 0.0;
  double _lastSnapshotCaloriesBurned = 0.0;

  StreamSubscription? _accelSub;

  @override
  Stream<Duration>? get elapsedStream => _timer.stream;

  @override
  Duration? get elapsed => _timer.elapsed;

  @override
  double? get distance => geolocatorSensor.distance;

  @override
  double? get caloriesBurned => _caloriesBurned;

  @override
  int? get steps => _steps;
  // double get calories => _calories;
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

  // double get avgSpeed => geolocatorSensor.avgSpeed;
  // double get elevationGain => geolocatorSensor.elevationGain;

  @override
  Future<void> start() async {
    _activityID = Uuid().v4().toUpperCase();
    debugPrint('WalkID: $activityID');

    _steps = 0;
    _lastSnapshotSteps = 0;
    _lastSnapshotDistance = 0.0;
    _lastSnapshotElevation = 0.0;
    _lastSnapshotCaloriesBurned = 0.0;

    await locationPermissionService.request();
    final locationGranted = await locationPermissionService.isGranted();

    if ((!locationGranted)) return;

    final userUUID = await currentUserSession.getCurrentUserUUID();
    if (userUUID == null) return;

    await exerciseLocalRepo.setIDs(activityID, userUUID, 1); // setting IDs

    _minuteStart = DateTime.now();

    await geolocatorSensor.start(2, 4, 1); // geolocator initial
    await accelerometerSensor.start();

    final accelStream = streamSpeedReductor(accelerometerSensor.magnitude, 100);

    _accelSub = accelStream.listen((raw) {
      final step = countStep(accelerometerData: raw!);

      if (step &&
          geolocatorSensor.hasMovement &&
          geolocatorSensor.speed < 2.5) {
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
    accelerometerSensor.reset();
    geolocatorSensor.reset();
    _minuteStart = null;
    _timer.reset();
    _steps = 0;
    _isPaused = false;

    _lastSnapshotSteps = 0;
    _lastSnapshotDistance = 0.0;
    _lastSnapshotElevation = 0.0;
  }

  @override
  void stopAndSave() async {
    _timer.stop();
    _snapshotTimer?.cancel();
    geolocatorSensor.stop();
    accelerometerSensor.stop();
    _accelSub?.cancel();

    reset();
  }

  @override
  void discard() async {
    _timer.stop();
    _snapshotTimer?.cancel();
    geolocatorSensor.stop();
    accelerometerSensor.stop();
    _accelSub?.cancel();

    await aerobicSampleRepo.delete(activityID);

    reset();
  }

  @override
  Future<void> save() async {
    pause();

    if (elapsed!.inSeconds < 10 || steps == 0) {
      discard();
      throw ExerciseValidationException(
        'No es posible guardar actividades menores a 10 segundos o sin pasos realizados',
      );
    } // this prevents the user from saving short time activities

    final sampleData = await aerobicSampleRepo.getSamples(activityID);
    if (sampleData == null || sampleData.isEmpty) {
      discard();
      throw ExerciseValidationException(
        'No hay datos suficientes para guardar esta actividad',
      );
    }

    // final userUUID = await currentUserSession.getCurrentUserUUID();
    // if (userUUID == null) return;


    final stepsList = sampleData
        .map((sample) => sample.steps)
        .whereType<int>()
        .toList();

    final cadenceList = sampleData
        .map((sample) => sample.cadence)
        .whereType<double>()
        .where((value) => value.isFinite)
        .toList();

    final paceList = sampleData
        .map((sample) => sample.pace)
        .whereType<double>()
        .where((value) => value.isFinite)
        .toList();

    // final distanceList = sampleData
    //     .map((sample) => sample.distance)
    //     .whereType<double>()
    //     .toList();

    final elevationList = sampleData
        .map((sample) => sample.elevation)
        .whereType<double>()
        .toList();

    // debugPrint('Steps list: ${stepsList.toString()}');
    // debugPrint('Steps list: ${paceList.toString()}');

    final walkData = Walk(
      activityID: activityID,

      duration: elapsed ?? Duration(seconds: 1),

      distance: distance ?? 0,

      caloriesBurned: caloriesBurned ?? 0,

      elevationGain: elevationList.isEmpty ? 0 : totalElevationGain(elevationList) ,

      avgCadence: cadenceList.isEmpty ? 0 : avgCalculator(cadenceList),

      avgPace: paceList.isEmpty ? 0 : avgCalculator(paceList),

      steps: steps ?? 0,

      avgSteps: stepsList.isEmpty ? 0 : valueByTime(stepsList, 60),

      registeredAt: DateTime.now().toUtc(),
    );

    await exerciseLocalRepo.save(walkData);
    stopAndSave();
  }

  void _startSnapshotTimer() {
    const snapshotInterval = Duration(seconds: 5);

    debugPrint('Starting snapshot timer for instance $_instanceId');
    _snapshotTimer?.cancel(); // cancel any existing timer
    _snapshotTimer = Timer.periodic(snapshotInterval, (_) async {
      final currentSteps = steps;
      final currentDistance = distance;
      final currentElevation = geolocatorSensor.elevation;

      final currentCalories = calculateCalories(
        elapsed: elapsed!,
        weightKg: 70,
        met: 2,
      );

      // Calculate DELTAS from previous cumulative values
      final stepsDelta = currentSteps! - _lastSnapshotSteps;

      final distanceDelta = currentDistance! - _lastSnapshotDistance;

      final elevationDelta = currentElevation - _lastSnapshotElevation;

      final caloriesDelta = currentCalories - _lastSnapshotCaloriesBurned;

      // Rates for this interval
      final cadence = calculateCadence(stepsDelta, snapshotInterval);

      final pace = geolocatorSensor.hasMovement
          ? calculatePace(snapshotInterval, distanceDelta)
          : 0.0;

      // Speed is already a rate. Don't subtract previous speed.
      final speed = geolocatorSensor.speed;

      final latitude = geolocatorSensor.latitude;
      final longitude = geolocatorSensor.longitude;

      final snapshotData = WalkActivitySample(
        activityID: activityID,

        timestampMs: elapsed,

        // Interval values
        steps: stepsDelta,
        distance: distanceDelta,
        calories: caloriesDelta,
        elevation: elevationDelta,

        // Rates
        cadence: cadence,
        pace: pace,
        speed: speed,

        heartRate: null,

        latitude: latitude,
        longitude: longitude,
      );

      await aerobicSampleRepo.save(snapshotData);

      _lastSnapshotSteps = currentSteps;
      _lastSnapshotDistance = currentDistance;
      _lastSnapshotElevation = currentElevation;
      _lastSnapshotCaloriesBurned = currentCalories;

      debugPrint(
        'Snapshot saved: '
        'activityID=$activityID '
        'steps=$stepsDelta '
        'distance=$distanceDelta '
        'calories=$caloriesDelta '
        'cadence=$cadence '
        'pace=$pace '
        'speed=$speed '
        'elapsed=$elapsed',
      );
    });
  }
}
