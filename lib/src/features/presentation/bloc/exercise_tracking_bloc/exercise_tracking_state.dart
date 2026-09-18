import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';

abstract class ExerciseTrackingState {}

class ExerciseInitial extends ExerciseTrackingState {}

class ExercisePermissionsDenied extends ExerciseTrackingState {}

class ActiveExerciseState extends ExerciseTrackingState {
  final double? distance;
  final int? steps;
  final Duration timeElapsed;
  final Coordinates? startLocation;
  final Coordinates? currentLocation;

  ActiveExerciseState({
    required this.timeElapsed,
    this.steps,
    this.distance,
    this.startLocation,
    this.currentLocation,
  });
}

class TrackingExercise extends ActiveExerciseState {
  TrackingExercise({
    required super.timeElapsed,
    super.steps,
    super.distance,
    super.startLocation,
    super.currentLocation,
  });
}

class ExercisePaused extends ActiveExerciseState {
  ExercisePaused({
    required super.timeElapsed,
    super.steps,
    super.distance,
    super.startLocation,
    super.currentLocation,
  });
}

class ExerciseResumed extends ExerciseTrackingState {}

class ExerciseSaved extends ExerciseTrackingState {
  final Coordinates endLocation;

  ExerciseSaved(this.endLocation);
}

class ExerciseDiscarded extends ExerciseTrackingState {}
// class ResumeExercise extends ExerciseState{}

class ExerciseError extends ExerciseTrackingState {
  final String message;
  ExerciseError(this.message);
}
