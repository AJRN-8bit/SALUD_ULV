
import 'package:salud_ulv_app/src/core/models/exercise_samples.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';

abstract class ExerciseState {}
// abstract class ExerciseLoaded extends ExerciseState {}

class ExerciseInitial extends ExerciseState {}
class ExerciseLoading extends ExerciseState {}
class ExerciseSent extends ExerciseState {}

class ExerciseRecentLoaded extends ExerciseState {
  final IPhysicalActivity? data;
  ExerciseRecentLoaded(this.data);
}

class ExerciseListLoaded extends ExerciseState {
  final List<IPhysicalActivity>? data;
  ExerciseListLoaded(this.data);
}

class ExerciseSamplesLoaded extends ExerciseState {
  final List<IActivitySample>? data;
  ExerciseSamplesLoaded(this.data);
}

class ExerciseError extends ExerciseState {
  final String message;
  ExerciseError(this.message);
}