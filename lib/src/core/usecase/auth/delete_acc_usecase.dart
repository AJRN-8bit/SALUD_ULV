import 'package:salud_ulv_app/src/core/repositories/repos/auth_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

class DeleteAccUsecase implements IDeleteAccUseCase{
  final ITokenStorageRepo tokenStorageRepo;
  final IAuthExtRepo authRepo;

  const DeleteAccUsecase(this.authRepo, this.tokenStorageRepo);


  @override
  Future<void> execute(String email) async{
    final token = await tokenStorageRepo.getUserToken();
    if(token == null) return;

    await tokenStorageRepo.deleteToken();
    await authRepo.deleteAccount(email);
  }
}