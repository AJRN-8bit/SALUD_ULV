
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/exercise_dto.dart';


class WalkDTO extends AerobicsDTO {
  final int? steps;
  final double? avgSteps;

  WalkDTO({
    required super.activityID,
    required super.userUUID,
    required super.category,
    // required super.activityType,
    required super.duration,
    required super.caloriesBurned,
    required super.registeredAt,
    required super.distance,
    required super.avgPace,
    required super.elevationGain,
    required super.avgCadence,
    super.heartRate,
    required this.steps,
    required this.avgSteps,
  });

  factory WalkDTO.fromDomain(Walk activity) {
    return WalkDTO(
      activityID: activity.activityID,
      userUUID: activity.userUUID,
      category: activity.category,
      // activityType: activity.activityType,
      duration: activity.duration,
      caloriesBurned: activity.caloriesBurned,
      registeredAt: activity.registeredAt,
      distance: activity.distance,
      avgPace: activity.avgPace,
      elevationGain: activity.elevationGain,
      avgCadence: activity.avgCadence,
      heartRate: activity.heartRate,
      steps: activity.steps,
      avgSteps: activity.avgSteps,
    );
  }

  factory WalkDTO.fromMap(Map<String, dynamic> map) {
    return WalkDTO(
      activityID: map['activityID'] as String?,
      userUUID: map['userUUID'] as String?,
      category: map['categoryID'] as int?,
      // activityType: map['activityType'] as String?,
      duration: Duration(milliseconds: map['duration_ms'] as int),
      caloriesBurned: (map['caloriesBurned'] as num?)?.toDouble() ?? 0,
      registeredAt: map['registeredAt'] != null ? DateTime.parse(map['registeredAt'] as String).toLocal() : null,

      distance: (map['distance'] as num?)?.toDouble() ?? 0,
      avgPace: (map['avgPace'] as num?)?.toDouble() ?? 0,
      elevationGain: (map['elevationGain'] as num?)?.toDouble() ?? 0,
      avgCadence: (map['avgCadence'] as num?)?.toDouble() ?? 0,
      heartRate: (map['heartRate'] as num?)?.toDouble() ?? 0,
      
      steps: map['steps'] as int? ?? 0,
      avgSteps: (map['avgSteps'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'steps': steps,
      'avgSteps': avgSteps,
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

      'steps': steps,
      'avgSteps': avgSteps,
    };
  }


  Walk toDomain() {
    return Walk(
      activityID: activityID,
      userUUID: userUUID,
      category: category,
      // activityType: activityType,
      duration: duration,
      caloriesBurned: caloriesBurned,
      registeredAt: registeredAt,
      distance: distance,
      avgPace: avgPace,
      elevationGain: elevationGain,
      avgCadence: avgCadence,
      steps: steps,
      avgSteps: avgSteps,
    );
  }
}