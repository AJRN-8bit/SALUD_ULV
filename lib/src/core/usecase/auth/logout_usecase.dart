import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

class LogoutUsecase implements ILogoutUseCase{
  final ITokenStorageRepo tokenStorageRepo;

  const LogoutUsecase(this.tokenStorageRepo);

  @override
  Future<void> execute() async {
    await tokenStorageRepo.deleteToken();
  }
}