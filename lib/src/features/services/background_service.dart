import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      // mismo comportamiento que android
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,       
      autoStartOnBoot: false, 
    ),
  );
}




@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  bool isTracking = false;

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('startTracking').listen((event) {
    isTracking = true;
  });

  service.on('pauseTracking').listen((event) {
    isTracking = false;
  });

  service.on('stopTracking').listen((event) {
    isTracking = false;
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Salud ULV",
          content: isTracking ? "Actividad en curso" : "Actividad en pausa",
        );
      }
    }

    debugPrint('Background service running');
    service.invoke('update');
  });
}





void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService(); 
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke('stopService');
}



void startExerciseTracking() {
  final service = FlutterBackgroundService();
  service.invoke('setAsForeground');
  service.invoke('startTracking');
}

void pauseExerciseTracking() {
  final service = FlutterBackgroundService();
  service.invoke('pauseTracking');
}

void stopExerciseTracking() {
  final service = FlutterBackgroundService();
  service.invoke('setAsBackground'); // demota una vez que termina el tracking
  service.invoke('stopTracking');
}




Future<bool> requestExercisePermissionsAndStartService() async {
  final activityStatus = await Permission.activityRecognition.request();
  final locationStatus = await Permission.location.request();

  PermissionStatus backgroundLocationStatus = PermissionStatus.denied;
  if (locationStatus.isGranted) {
    backgroundLocationStatus = await Permission.locationAlways.request();
  }

  await Permission.notification.request();

  debugPrint('activity: $activityStatus');
  debugPrint('location: $locationStatus');
  debugPrint('backgroundLocation: $backgroundLocationStatus');

  if (activityStatus.isGranted && locationStatus.isGranted) {
    startBackgroundService();
    startExerciseTracking();
    return true;
  } else {
    debugPrint('Service not started — missing required permissions');
    return false;
  }
}


void finishExercise() {
  stopExerciseTracking();
  stopBackgroundService();
}