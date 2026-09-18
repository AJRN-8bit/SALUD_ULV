
class ExerciseValidationException implements Exception {
  final String message;
  const ExerciseValidationException(this.message);

  @override
  String toString() => message;
}