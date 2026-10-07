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

abstract class IAerobics extends IPhysicalActivity{
  final double? distance;
  final double? avgPace;
  final double? elevationGain;
  final double? avgCadence;
  double? heartRate;

  IAerobics({
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


class Walk extends IAerobics{
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



class Running extends IAerobics{
  // final int? steps;
  // final double? avgSteps;
  final double? speed;
  final double? avgSpeed;


  Running({
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

    this.speed,
    this.avgSpeed,
    
    // required this.steps,
    // required this.avgSteps
  });
}



class Cycling extends IAerobics{
  // final int? steps;
  // final double? avgSteps;
  final double? speed;
  final double? avgSpeed;
  final double? avgElevation;


  Cycling({
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

    this.avgElevation,
    this.speed,
    this.avgSpeed,
    
    // required this.steps,
    // required this.avgSteps
  });
}