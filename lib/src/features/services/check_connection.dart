import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';

class CheckConnection implements ICheckConnectionRepo{
  
  @override
  Future<bool> hasConnection() async{
    final result = await Connectivity().checkConnectivity();
    if(result.contains(ConnectivityResult.none)) return false;

    return true;
  }
}