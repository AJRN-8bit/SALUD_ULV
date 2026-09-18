abstract class PhysicalActivityDTO {
  final String? activityID;
  final String? userUUID;
  final int? category;
  // final String? activityType;
  final Duration? duration;
  final double? caloriesBurned;
  final DateTime? registeredAt;

  PhysicalActivityDTO({
    required this.activityID,
    required this.userUUID,
    required this.category,
    // required this.activityType,
    required this.duration,
    required this.caloriesBurned,
    required this.registeredAt,
  });


  Map<String, dynamic> toMap() {
  return {
    'activityID': activityID,
    'userUUID': userUUID,
    'categoryID': category,
    // 'activityType': activityType,
    'duration_ms': duration?.inMilliseconds,
    'caloriesBurned': caloriesBurned,
    'registeredAt': registeredAt!.toIso8601String(),
    };
  }

}

// ---------------------------------------------------------------------------
// Aerobics DTO
// ---------------------------------------------------------------------------

class AerobicsDTO extends PhysicalActivityDTO {
  final double? distance;
  final double? avgPace;
  final double? elevationGain;
  final double? avgCadence;
  final double? heartRate;

  AerobicsDTO({
    required super.activityID,
    required super.userUUID,
    required super.category,
    // required super.activityType,
    required super.duration,
    required super.caloriesBurned,
    required super.registeredAt,
    required this.distance,
    required this.avgPace,
    required this.elevationGain,
    required this.avgCadence,
    this.heartRate,
  }); // aerobic


  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'distance': distance,
      'avgPace': avgPace,
      'elevationGain': elevationGain,
      'avgCadence': avgCadence,
      'heartRate': heartRate,
    };
  }
}

