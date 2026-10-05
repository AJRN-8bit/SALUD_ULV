
import 'package:salud_ulv_app/src/core/models/exercise_summaries.dart';

abstract class ExerciseEvent {}

// class LoadExerciseEvent extends ExerciseEvent {}


class ExerciseGetRecentEvent extends ExerciseEvent {}

class ExerciseGetSamplesEvent extends ExerciseEvent{
  final String activityID;
  ExerciseGetSamplesEvent(this.activityID);
}

class ExerciseGetAllEvent extends ExerciseEvent {}

class ExerciseGetSummary extends ExerciseEvent {
  final SummaryPeriod period;
  ExerciseGetSummary(this.period);
}


class ExerciseSyncPending extends ExerciseEvent{}