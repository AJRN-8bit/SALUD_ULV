
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';

class CheckConnectionTester implements ICheckConnectionRepo{
  @override
  Future<bool> hasConnection() async{
    return true;
  }
}