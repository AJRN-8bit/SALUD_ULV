import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';
import 'package:salud_ulv_app/src/core/services/error_handlers.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_state.dart';
import 'package:salud_ulv_app/src/features/services/background_service.dart';

class ExerciseTrackingBloc
    extends Bloc<ExerciseTrackingEvent, ExerciseTrackingState> {
  final IExerciseTrackUseCase usecase;

  ExerciseTrackingBloc({required this.usecase}) : super(ExerciseInitial()) {
    on<StartExerciseEvent>(_onStart);
    on<PauseExerciseEvent>(_onPause);
    on<ResumeExerciseEvent>(_onResume);
    on<SaveExerciseEvent>(_onSave);
    on<DiscardExerciseEvent>(_onDiscard);
  }

  Future<void> _onStart(
    StartExerciseEvent event,
    Emitter<ExerciseTrackingState> emit,
  ) async {
    final serviceStarted = await requestExercisePermissionsAndStartService();

    if (!serviceStarted) {
      emit(
        ExerciseError(
          'Necesitamos permisos de ubicación y actividad física para registrar tu ejercicio',
        ),
      );
      return;
    }

    await usecase.start();
    await _startTracking(emit);
  }

  Future<void> _startTracking(Emitter<ExerciseTrackingState> emit) async {
    startExerciseTracking();

    await emit.forEach<Duration>(
      usecase.elapsedStream!,

      onData: (elapsed) => TrackingExercise(
        distance: usecase.distance,
        steps: usecase is IStepTrackable
            ? (usecase as IStepTrackable).steps
            : null,
        timeElapsed: usecase.elapsed!,
        startLocation: usecase is ILocationTrackable
            ? (usecase as ILocationTrackable).startLocation
            : null,
        currentLocation: usecase is ILocationTrackable
            ? (usecase as ILocationTrackable).currentLocation
            : null,
      ),
    );
  }

  void _onPause(
    PauseExerciseEvent event,
    Emitter<ExerciseTrackingState> emit,
  ) async {
    usecase.pause();
    pauseExerciseTracking();

    emit(
      ExercisePaused(
        distance: usecase.distance,
        steps: usecase is IStepTrackable
            ? (usecase as IStepTrackable).steps
            : null,
        timeElapsed: usecase.elapsed!,
      ),
    );
  }

  void _onResume(
    ResumeExerciseEvent event,
    Emitter<ExerciseTrackingState> emit,
  ) async {
    usecase.resume();
    startExerciseTracking();

    emit(
      TrackingExercise(
        distance: usecase.distance,
        steps: usecase is IStepTrackable
            ? (usecase as IStepTrackable).steps
            : null,
        timeElapsed: usecase.elapsed!,
      ),
    ); // restart the stream

    await _startTracking(emit);
  }

  Future<void> _onSave(
    SaveExerciseEvent event,
    Emitter<ExerciseTrackingState> emit,
  ) async {
    try {
      final endLocation = usecase is ILocationTrackable
          ? (usecase as ILocationTrackable).currentLocation
          : null;

      await usecase.save();
      finishExercise();

      emit(ExerciseSaved(endLocation!));
      emit(ExerciseInitial());

    } on ExerciseValidationException catch (e) {
      emit(ExerciseError(e.message));
      emit(ExerciseInitial());

    } catch (e) {
      emit(ExerciseError('No se pudo guardar la caminata'));
    }
  }

  void _onDiscard(
    DiscardExerciseEvent event,
    Emitter<ExerciseTrackingState> emit,
  ) {
    usecase.discard();
    finishExercise();

    emit(ExerciseInitial());
  }
}
