import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/exercise_dto.dart';

class RunningDTO extends AerobicsDTO {
  final double? speed;
  final double? avgSpeed;

  RunningDTO({
    required super.activityID,
    required super.userUUID,
    required super.category,
    required super.duration,
    required super.caloriesBurned,
    required super.registeredAt,
    required super.distance,
    required super.avgPace,
    required super.elevationGain,
    required super.avgCadence,
    super.heartRate,
    required this.speed,
    required this.avgSpeed,
  });

  factory RunningDTO.fromDomain(Running activity) {
    return RunningDTO(
      activityID: activity.activityID,
      userUUID: activity.userUUID,
      category: activity.category,
      duration: activity.duration,
      caloriesBurned: activity.caloriesBurned,
      registeredAt: activity.registeredAt,
      distance: activity.distance,
      avgPace: activity.avgPace,
      elevationGain: activity.elevationGain,
      avgCadence: activity.avgCadence,
      heartRate: activity.heartRate,
      speed: activity.speed,
      avgSpeed: activity.avgSpeed,
    );
  }

  factory RunningDTO.fromMap(Map<String, dynamic> map) {
    return RunningDTO(
      activityID: map['activityID'] as String?,
      userUUID: map['userUUID'] as String?,
      category: map['categoryID'] as int?,
      duration: Duration(milliseconds: (map['duration_ms'] as int?) ?? 0),
      caloriesBurned: (map['caloriesBurned'] as num?)?.toDouble() ?? 0,
      registeredAt: map['registeredAt'] != null
          ? DateTime.parse(map['registeredAt'] as String).toLocal()
          : DateTime.now(),

      distance: (map['distance'] as num?)?.toDouble() ?? 0,
      avgPace: (map['avgPace'] as num?)?.toDouble() ?? 0,
      elevationGain: (map['elevationGain'] as num?)?.toDouble() ?? 0,
      avgCadence: (map['avgCadence'] as num?)?.toDouble() ?? 0,
      heartRate: (map['heartRate'] as num?)?.toDouble() ?? 0,

      speed: (map['speed'] as num?)?.toDouble() ?? 0,
      avgSpeed: (map['avgSpeed'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'speed': speed,
      'avgSpeed': avgSpeed,
    };
  }

  Map<String, dynamic> toMapFields() {
    return {
      'duration_ms': duration?.inMilliseconds,
      'caloriesBurned': caloriesBurned,
      'registeredAt': registeredAt?.toIso8601String(),

      'distance': distance,
      'avgPace': avgPace,
      'elevationGain': elevationGain,
      'avgCadence': avgCadence,
      'heartRate': heartRate,

      'speed': speed,
      'avgSpeed': avgSpeed,
    };
  }

  Running toDomain() {
    return Running(
      activityID: activityID,
      userUUID: userUUID,
      category: category,
      duration: duration,
      caloriesBurned: caloriesBurned,
      registeredAt: registeredAt,
      distance: distance,
      avgPace: avgPace,
      elevationGain: elevationGain,
      avgCadence: avgCadence,
      speed: speed,
      avgSpeed: avgSpeed,
    );
  }
}