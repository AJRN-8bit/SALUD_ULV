
import 'package:salud_ulv_app/src/core/models/exercises.dart';

// General repo structure for the activities, this because all will need these methods
abstract class IExerciseLocalRepo{
  Future<void> setIDs(String activityID, String userUUID, int categoryID);

  Future<void> save(IPhysicalActivity exercise);
  Future<IPhysicalActivity?> getRecent(String userUUID);
  Future<String?> getRecentID(String userUUID);
  Future<List<IPhysicalActivity>?> getAll(String userUUID);
  Future<List<IPhysicalActivity>?> getUnsynced(String userUUID);
  Future<void> markAsSynced(String activityID);
  Future<void> delete(String userUUID, String activityID);
}

abstract class IExerciseExtRepo {
  Future<void> send(IPhysicalActivity? exercise);
}