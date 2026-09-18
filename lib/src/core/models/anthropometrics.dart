

class Anthropometrics{
  String? anthropometricID;
  String? userUUID;
  final double height;
  final double weight;
  final double smm;
  final double fatMass;
  final double bodyFatPercentage;
  final double bmi;
  final double whr;
  DateTime? registeredAt;

  Anthropometrics({
    this.anthropometricID,
    this.userUUID,
    required this.height,
    required this.weight,
    required this.smm,
    required this.fatMass,
    required this.bodyFatPercentage,
    required this.bmi,
    required this.whr,
    this.registeredAt
  });
}