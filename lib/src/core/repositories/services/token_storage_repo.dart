
abstract class ITokenStorageRepo {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> deleteToken();

  Future<void> saveOTPToken(String token);
  Future<String?> getOTPToken();
}