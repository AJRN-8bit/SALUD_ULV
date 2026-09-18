
import 'package:salud_ulv_app/src/core/repositories/repos/otp_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

class SendOtpUsecase implements ISendOTPUseCase{
  final ICheckConnectionRepo checkConnectionRepo;
  final IOtpRepo otpRepo;
  final ITokenStorageRepo tokenStorageRepo;

  const SendOtpUsecase(this.checkConnectionRepo, this.otpRepo, this.tokenStorageRepo);

  @override
  Future<void> execute(String email) async {
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) return;

    final token = await otpRepo.loginOTP();
    if(token == null) return;

    await tokenStorageRepo.saveOTPToken(token);
    final otpToken = await tokenStorageRepo.getOTPToken();
    if(otpToken == null) return;

    // Sends otp code to email
    await otpRepo.launchOTP(email, otpToken);
  }
}