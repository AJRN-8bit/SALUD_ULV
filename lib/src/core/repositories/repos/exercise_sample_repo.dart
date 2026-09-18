
import 'package:salud_ulv_app/src/core/models/exercise_samples.dart';

abstract class IActivitySampleRepo {
  Future<void> save(ActivitySample data);
  Future<List<IActivitySample>?> getSamples(String activityID);
  Future<void> delete(String activityID);
}

// abstract class IStrenghtCacheRepo {
//   Future<void> save(AerobicExerciseRawData data);
//   Future<List<AerobicExerciseRawData>?> getCache();
//   Future<void> clearCache();
// }