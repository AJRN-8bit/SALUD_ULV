

abstract class ILocationPermissionService {
  Future<void> request();
  Future<bool> isGranted();
}