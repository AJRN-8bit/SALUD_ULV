import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterBackgroundService backgroundService =
    FlutterBackgroundService();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      autoStartOnBoot: false,
      initialNotificationTitle: 'Actividad',
      initialNotificationContent: 'Iniciando...',
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  bool isTracking = false;

  try {
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
            content: isTracking
                ? "Actividad en curso"
                : "Actividad en pausa",
          );
        }
      }

      debugPrint('Background service running');

      service.invoke('update', {
        'isTracking': isTracking,
      });
    });
  } catch (e, st) {
    debugPrint('onStart error: $e\n$st');
  }
}


// ============================================================
// FUNCIONES PARA CONTROLAR EL SERVICIO DESDE LA APP
// ============================================================

Future<void> startBackgroundService() async {
  final service = FlutterBackgroundService();

  final isRunning = await service.isRunning();

  if (!isRunning) {
    await service.startService();
  }
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

  service.invoke(
    'setAsBackground',
  ); // demota una vez que termina el tracking

  service.invoke('stopTracking');
}


// ============================================================
// PERMISOS + INICIO COMPLETO
// ============================================================

Future<bool> requestExercisePermissionsAndStartService() async {
  final activityStatus =
      await Permission.activityRecognition.request();

  final locationStatus =
      await Permission.location.request();

  PermissionStatus backgroundLocationStatus =
      PermissionStatus.denied;

  if (locationStatus.isGranted) {
    backgroundLocationStatus =
        await Permission.locationAlways.request();
  }

  await Permission.notification.request();

  debugPrint('activity: $activityStatus');
  debugPrint('location: $locationStatus');
  debugPrint(
    'backgroundLocation: $backgroundLocationStatus',
  );

  if (activityStatus.isGranted && locationStatus.isGranted) {
    await startBackgroundService();

    // Esperamos un momento para asegurarnos de que
    // el servicio ya esté ejecutándose.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    startExerciseTracking();

    return true;
  } else {
    debugPrint(
      'Service not started — missing required permissions',
    );

    return false;
  }
}


// ============================================================
// FINALIZAR EJERCICIO
// ============================================================

void finishExercise() {
  stopExerciseTracking();
  stopBackgroundService();
}
