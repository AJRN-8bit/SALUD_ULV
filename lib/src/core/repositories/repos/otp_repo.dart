

abstract class IOtpRepo {
  Future<String?> loginOTP();
  Future<void> launchOTP(String email, String token);
  Future<bool?> verificationOTP(String otp, String email);
  // Future<void> forgotOTP(String email, String token);
  // Future<bool> resetPassword(String email, String itp, String newPassword);
}