import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';

class AccelerometerSensor implements IAccelerometer{

  StreamSubscription? _sub; 
  StreamController<List<double>>? _magniudeController;


  @override
  Stream<List<double>> get magnitude => 
    (_magniudeController ??= StreamController<List<double>>.broadcast()).stream;


  @override
  Future<void> start() async{
    _magniudeController = StreamController<List<double>>.broadcast();

    _sub = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      final raw = [
        event.x.abs(), 
        event.y.abs(), 
        event.z.abs()
        ];

      _magniudeController?.add(raw); // Returns raw data
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
    _magniudeController?.close();
    _magniudeController = null;
  }

  @override
  void reset() => stop();

}