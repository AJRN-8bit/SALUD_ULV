import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';

abstract class IAnthropometricLocalRepo {
  Future<void> save(Anthropometrics data);
  Future<Anthropometrics?> getRecent(String userUUID);
  Future<List<Anthropometrics>?> getAll(String userUUID);
  Future<List<Map<String, dynamic>>?> getByField(String userUUID, String field);
  Future<void> markAsSynced(String anthropometricID);
  Future<List<Anthropometrics>?> getUnsynced(String userUUID);
}


abstract class IAnthropometricExtRepo {
  Future<void> send(Anthropometrics data);
  Future<List<Anthropometrics>?> getByUserCode(String input);
  Future<List<Anthropometrics>?> getAll();
  Future<List<Map<String, dynamic>>?> getByCodeAndField(String input, String field);
}