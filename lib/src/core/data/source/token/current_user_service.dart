
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token_storage.dart';

class CurrentUserSession implements ICurrentUserSession{

  @override
  ITokenRepo get tokenRepo => TokenHandler();

  @override
  ITokenStorageRepo get tokenStorageRepo => TokenStorage();

  @override
  Future<String?> getCurrentUserUUID() async{
    final token = await tokenStorageRepo.getUserToken();
    if(token == null) return null;

    final data = tokenRepo.decode(token);

    final user = data['user'];
    final userUUID = user['userUUID'] as String;

    // final userCode = data['userCode'] as String;

    return userUUID;
  }
}