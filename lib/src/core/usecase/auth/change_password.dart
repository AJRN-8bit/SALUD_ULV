

import 'package:salud_ulv_app/src/core/repositories/repos/auth_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

class ChangePwUseCase implements IChangePWUseCase{
  final IAuthExtRepo authRepo;

  const ChangePwUseCase(this.authRepo);

  @override
  Future<void> execute(String email, String newPassword) async {
    await authRepo.resetPasswordWithEmail(email, newPassword);
  }
}