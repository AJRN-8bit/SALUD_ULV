// Base abstract class for the users physical activities.

abstract class IPhysicalActivity{
  String? activityID;
  String? userUUID;
  int? category;
  // String? activityType;
  Duration? duration; 
  double? caloriesBurned;
  DateTime? registeredAt;

  IPhysicalActivity({
    required this.activityID,
    required this.userUUID,
    required this.category,
    // required this.activityType,
    required this.duration, 
    required this.caloriesBurned,
    required this.registeredAt,
  });
}


// Aerobics general class

class Aerobics extends IPhysicalActivity{
  final double? distance;
  final double? avgPace;
  final double? elevationGain;
  final double? avgCadence;
  double? heartRate;

  Aerobics({
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
  });
}


class Walk extends Aerobics{
  final int? steps;
  final double? avgSteps;

  Walk({
    super.activityID,
    super.userUUID,
    super.category,
    // required super.activityType,
    required super.duration, 
    required super.caloriesBurned,
    required super.registeredAt,

    required super.distance,
    required super.avgPace,
    required super.elevationGain,
    required super.avgCadence,
    
    required this.steps,
    required this.avgSteps
  });
}