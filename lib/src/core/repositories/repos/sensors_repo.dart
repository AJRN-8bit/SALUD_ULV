
// abstract class ISensorsRepo {
//   Future<void> start();
//   void pause();
//   void resume();
//   void stop();
//   void reset();
// }

class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates({
    required this.latitude,
    required this.longitude,
  });
}



abstract class IAccelerometer {
  Stream<List<double>?> get magnitude;

  Future<void> start();
  void pause();
  void resume();
  void stop();
  void reset();
}


abstract class IGeolocator {
  double get distance;
  double get latitude;
  double get longitude;
  double get speed;
  double get elevation;
  bool get hasMovement;

  double? get startLatitude;
  double? get startLongitude;

  Future<Coordinates?> getCurrentLocation();

  Future<void> start(double minMovementDistance, int accuracyLevel, int distanceFilter,);
  void pause();
  void resume();
  void stop();
  void reset();
}