import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';

// import 'package:salud_ulv_app/src/features/data/source/local/services/location_permition.dart';

class GeolocatorSensor implements IGeolocator {
  StreamSubscription? _sub;
  Position? _lastPosition;

  double _distance = 0.0;
  double _speed = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  double _elevation = 0.0;
  bool _hasMovement = false;
  double? _startLatitude;
  double? _startLongitude;

  @override
  double get speed => _speed;
  @override
  double get distance => _distance;
  @override
  double get latitude => _latitude;
  @override
  double get longitude => _longitude;
  @override
  double get elevation => _elevation;
  @override
  bool get hasMovement => _hasMovement;

  @override
  double? get startLatitude => _startLatitude;
  @override
  double? get startLongitude => _startLongitude;



  LocationAccuracy setAccuracyLevel(int accuracyLevel) {
    switch (accuracyLevel) {
      case 1:
        return LocationAccuracy.lowest;
      case 2:
        return LocationAccuracy.low;
      case 3:
        return LocationAccuracy.medium;
      case 4:
        return LocationAccuracy.high;
      default:
        return LocationAccuracy.best;
    }
  }



  @override
  Future<Coordinates?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission was permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition();

    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }



  @override
  Future<void> start(
    double minMovementDistance,
    int accuracyLevel,
    int distanceFilter,
  ) async {
    _startStream(
      _getStream(accuracyLevel, distanceFilter),
      minMovementDistance,
    );
  }

  Stream<Position> _getStream(int accuracyLevel, int distanceFilter) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: setAccuracyLevel(accuracyLevel),
        distanceFilter: distanceFilter,
      ),
    );
  }



  void _startStream(
    Stream<Position> positionStream,
    double minMovementDistance,
  ) {
    _sub = positionStream.listen((Position position) {
      if (_lastPosition == null) {
        _startLatitude = position.latitude;
        _startLongitude = position.longitude;
      }

      if (_lastPosition != null) {
        final delta = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        // _distance += delta;

        _hasMovement = delta >= minMovementDistance;

        if (delta >= minMovementDistance) {
          _distance += delta;
          _speed = position.speed;
          _hasMovement = true;
        } else {
          _hasMovement = false;
        }

        // final noiseFloor = (position.accuracy + _lastPosition!.accuracy).clamp(
        //   minMovementDistance,
        //   15.0,
        // ); // nunca menos que tu mínimo, tope razonable de 15m

        // if (delta >= noiseFloor) {
        //   _distance += delta;
        //   _speed = position.speed;
        //   _hasMovement = true;
        // } else {
        //   _hasMovement = false;
        //   // OJO: no sumes delta a _distance aquí, es ruido.
        // }

              // Siempre acumula distancia real -> pace/distancia quedan
      // // suaves, cada snapshot refleja lo que realmente avanzaste
      // // en esos 5 segundos, sin ráfagas artificiales.
      // _distance += delta;
      // _speed = position.speed;

      // // El umbral de precisión SOLO decide si cuenta como
      // // "movimiento activo" para el gate de pasos del acelerómetro
      // // -- no afecta la distancia acumulada.
      // final noiseFloor = (position.accuracy + _lastPosition!.accuracy)
      //     .clamp(minMovementDistance, 15.0);
      // _hasMovement = delta >= noiseFloor;

        final altitudeDelta = position.altitude - _lastPosition!.altitude;
        if (altitudeDelta > 1.5) _elevation += altitudeDelta;
      }
      debugPrint(position.toString());
      _lastPosition = position;
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }


  @override
  void pause() => _sub?.pause();


  @override
  void resume() => _sub?.resume();



  @override
  void stop() {
    _sub?.cancel();
    _sub = null;
  }



  @override
  void reset() {
    _distance = 0.0;
    _speed = 0.0;
    _elevation = 0.0;
    _lastPosition = null;
    _hasMovement = false;

    _startLatitude = null;
    _startLongitude = null;
  }
}
