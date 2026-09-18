// Models for the raw data of the exercises

abstract class IActivitySample {
  final int? sampleID;
  final String activityID;
  final Duration? timestampMs;

  final int? heartRate;
  final double? distance;
  final double? calories;
  final int? steps;
  final double? pace;
  final double? speed;
  final double? cadence;
  final double? elevation;

  final double? latitude;
  final double? longitude;

  IActivitySample({
    this.sampleID,
    required this.activityID,
    required this.timestampMs,
    this.heartRate,
    this.distance,
    this.calories,
    this.steps,
    this.pace,
    this.speed,
    this.cadence,
    this.elevation,
    this.latitude,
    this.longitude,
  });
}




class ActivitySample implements IActivitySample{
  @override
  final int? sampleID;
  @override
  final String activityID;
  @override
  final Duration? timestampMs;

  @override
  final int? heartRate;
  @override
  final double? distance;
  @override
  final double? calories;
  @override
  final int? steps;
  @override
  final double? pace;
  @override
  final double? speed;
  @override
  final double? cadence;
  @override
  final double? elevation;

  @override
  final double? latitude;
  @override
  final double? longitude;

  ActivitySample({
    this.sampleID,
    required this.activityID,
    required this.timestampMs,
    this.heartRate,
    this.distance,
    this.calories,
    this.steps,
    this.pace,
    this.speed,
    this.cadence,
    this.elevation,
    this.latitude,
    this.longitude,
  });
}





class WalkActivitySample extends ActivitySample {
  // @override
  // final int? steps;

  WalkActivitySample({
    super.sampleID,
    required super.activityID,
    required super.timestampMs,
    super.heartRate,
    super.distance,
    super.calories,
    super.steps,  // steps added
    super.pace,
    super.speed,
    super.cadence,
    super.elevation,
    super.latitude,
    super.longitude,
  });
}

