
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';

class TokenStorage implements ITokenStorageRepo{

  static const _storage = FlutterSecureStorage();
  static const _apikey = 'api_token';
  static const _otpkey = 'otp_token';

  @override
  Future<void> saveUserToken(String token) async {
    await _storage.write(key: _apikey, value: token);
  }


  @override
  Future<String?> getUserToken() async {
    return await _storage.read(key: _apikey);
  }


  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _apikey);
  }

  @override
  Future<void> saveOTPToken(String token) async {
    await _storage.write(key: _otpkey, value: token);
  }

  @override
  Future<String?> getOTPToken() async {
    return await _storage.read(key: _otpkey);
  }

}