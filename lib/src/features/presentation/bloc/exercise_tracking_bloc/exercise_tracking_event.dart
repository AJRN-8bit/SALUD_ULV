
abstract class ExerciseTrackingEvent {}

class StartExerciseEvent extends ExerciseTrackingEvent{}

class PauseExerciseEvent extends ExerciseTrackingEvent{}
class ResumeExerciseEvent extends ExerciseTrackingEvent{}
class StopExerciseEvent extends ExerciseTrackingEvent{}

class SaveExerciseEvent extends ExerciseTrackingEvent{}

class DiscardExerciseEvent extends ExerciseTrackingEvent{}