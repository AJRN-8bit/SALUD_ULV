import 'package:geolocator/geolocator.dart';
import 'package:salud_ulv_app/src/core/repositories/services/location_permission.dart';

class LocationPermissionService implements ILocationPermissionService {
  @override
  Future<bool> request() async {
    final permission = await Geolocator.requestPermission();
    return permission != LocationPermission.denied &&
           permission != LocationPermission.deniedForever;
  }

  @override
  Future<bool> isGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }
}
