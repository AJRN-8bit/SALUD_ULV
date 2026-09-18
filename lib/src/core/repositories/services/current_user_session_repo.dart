
import 'package:salud_ulv_app/src/core/repositories/services/token_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';

abstract class ICurrentUserSession {
  final ITokenRepo tokenRepo;
  final ITokenStorageRepo tokenStorageRepo;

  const ICurrentUserSession(this.tokenRepo, this.tokenStorageRepo);

  Future<String?> getCurrentUserUUID();  // method
}