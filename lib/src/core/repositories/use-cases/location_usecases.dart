
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';

abstract class IGetUserCurrentLocation {
  Future<Coordinates?> execute();
}