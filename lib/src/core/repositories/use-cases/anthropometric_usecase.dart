import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';

// User use cases
abstract class ISaveAnthroUseCase {
  Future<void> execute(Anthropometrics data);
}

abstract class IGetRecentAnthroUseCase {
  Future<Anthropometrics?> execute();
}

abstract class IGetAllAnthroUseCase {  // Shared
  Future<List<Anthropometrics>?> execute();
}

abstract class IGetByFieldAnthroUseCase {
  Future<List<Map<String, dynamic>>?> execute(String field);
}

abstract class ISendAnthroUseCase {
  Future<bool> execute();
}



// Admin use cases
abstract class IGetByUserCodeAdminUseCase {
  Future<List<Anthropometrics>?> execute(String input);
}

abstract class IGetByCodeAndFieldAnthroAdminUseCase {
  Future<List<Map<String, dynamic>>?> execute(String input, String field);
}
