

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';



// Step counter algorithm
double smoothMagnitude = 0.0;
DateTime lastTimeStamp = DateTime.now();


bool countStep({
  required List<double> accelerometerData,
}) 

{
  double alpha = 0.8;
  double dynamicThreshold = 3.5;
  final int stepCoolDownSeconds = 350;

  final x = accelerometerData[0];
  final y = accelerometerData[1];
  final z = accelerometerData[2];


  final magnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));

  smoothMagnitude = (alpha * smoothMagnitude) + ((1-alpha) * magnitude);

  // debugPrint('Last Magnitude: $smoothMagnitude');
  final double avg = accelerometerData.reduce((a,b) => a + b) / accelerometerData.length;

  final double stepDynamicThreshold = avg + dynamicThreshold;
  // debugPrint('Dynamic threshold: $stepDynamicThreshold');
  final now = DateTime.now();

  // debugPrint('Difference: ${now.difference(lastStepTime).inMilliseconds}');
  final bool stepCoolDown = now.difference(lastTimeStamp).inMilliseconds > stepCoolDownSeconds; 
  // debugPrint('Step cool down: $stepCoolDown');

  if((smoothMagnitude > stepDynamicThreshold ) && stepCoolDown) {

    // debugPrint(now.difference(lastTimePoint).inMilliseconds.toString());
    // debugPrint('Step cool down: $stepCoolDown');
        // debugPrint('Step detected');
        lastTimeStamp = now;
        return true; // step detected
    }

  return false; // no step
}





// Calculate calories
double calculateCalories({
  required Duration elapsed,
  required double weightKg,
  required double met,
}) {

  // Needs the divition
  final minutes = elapsed.inSeconds / 60.0; 
  return (minutes * met * weightKg) / 200;
}


double calculateSpeed(){
  return 0.0;
}


// Average calculator
double avgCalculator(List<num> values) {
  if(values.isEmpty) return 0;

  num sum = 0;

  for(num x in values) {
    sum += x;
  }

  return (sum / values.length);
}



double valueByTime(List<num> values, int timeInSeconds) {
  if(values.isEmpty) return 0.0;

  final total = values.fold<num>(0, (a, b) => a + b);
  final minutes = values.length / timeInSeconds;

  if(minutes == 0) return 0;

  return total / minutes;
}


double totalElevationGain(List<num> elevationDeltas) {
  if (elevationDeltas.isEmpty) return 0.0;

  return elevationDeltas
      .where((delta) => delta > 0)
      .fold<num>(0, (sum, d) => sum + d)
      .toDouble();
}



// Calculate cadence
double calculateCadence(int movementDelta, Duration duration) {

  if (duration.inSeconds <= 0 || movementDelta <= 0) {
    return 0;
  }

  return movementDelta / duration.inSeconds;
}



double calculatePace(Duration duration, double distanceMeters) {
  if (duration.inSeconds <= 0 || distanceMeters <= 0) return 0;

  final minutes = duration.inSeconds / 60;
  final km = distanceMeters / 1000;
  final pace = minutes / km;

  if (pace > 30 || pace < 2) return 0;

  return pace;
}



// Reductor of stream speed
Stream<T> streamSpeedReductor<T>(Stream<T> stream, int pMilliseconds) {
  return stream.throttleTime(Duration(milliseconds: pMilliseconds));
}







// General timer for exercises
class ExerciseTimer {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isPaused = true;

  final _controller = StreamController<Duration>.broadcast();
  Stream<Duration> get stream => _controller.stream;

  Duration get elapsed => _elapsed;
  bool get isPaused => _isPaused;

  void start() {
    _elapsed = Duration.zero;
    _isPaused = false;
    _run();
  }

  void pause() {
    _isPaused = true;
    _timer?.cancel();
  }

  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
    _run();
  }

  void stop() {
    _isPaused = true;
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    _isPaused = true;
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  void _run() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      _controller.add(_elapsed);
    });
  }
}
