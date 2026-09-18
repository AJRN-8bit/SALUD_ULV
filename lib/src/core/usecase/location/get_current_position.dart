
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/location_usecases.dart';

class GetUserCurrentPosition implements IGetUserCurrentLocation{
  final IGeolocator geolocator;

  const GetUserCurrentPosition(this.geolocator);

  @override
  Future<Coordinates?> execute() async {
    final coordinates = await geolocator.getCurrentLocation();

    if (coordinates == null) return null;

    return coordinates;
  }
}