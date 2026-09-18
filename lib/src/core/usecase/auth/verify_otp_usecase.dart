

import 'package:flutter/rendering.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/otp_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

class VerifyOtpUsecase implements IVerifyOTPUseCase{
  final ICheckConnectionRepo checkConnectionRepo;
  final IOtpRepo otpRepo;
  final ITokenStorageRepo tokenStorageRepo;

  const VerifyOtpUsecase(this.checkConnectionRepo, this.otpRepo, this.tokenStorageRepo);

  @override
  Future<bool?> execute(String otp, String email) async {
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) return null;


    final isOTPCorrect = await otpRepo.verificationOTP(otp, email);
    if(isOTPCorrect == null) return null;

    if(!isOTPCorrect) throw Exception("Código ya usado. Genera uno nuevo");
    debugPrint(isOTPCorrect.toString());

    return isOTPCorrect;
  }
}