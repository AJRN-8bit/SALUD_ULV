
abstract class ExerciseEvent {}

// class LoadExerciseEvent extends ExerciseEvent {}


class ExerciseGetRecentEvent extends ExerciseEvent {}

class ExerciseGetSamplesEvent extends ExerciseEvent{
  final String activityID;
  ExerciseGetSamplesEvent(this.activityID);
}

class ExerciseGetAllEvent extends ExerciseEvent {}



class ExerciseSyncPending extends ExerciseEvent{}