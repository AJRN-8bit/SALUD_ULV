
import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';

class AnthropometricsDTO {
  final String? anthropometricID;
  final String? userID; // Can be UUID or Code       
  final double height;      
  final double weight;
  final double smm;
  final double fatMass;
  final double bodyFatPercentage;
  final double bmi;
  final double whr;
  final DateTime? registeredAt;

  AnthropometricsDTO({
    this.anthropometricID,
    this.userID,            
    required this.height,
    required this.weight,
    required this.smm,
    required this.fatMass,
    required this.bodyFatPercentage,
    required this.bmi,
    required this.whr,
    this.registeredAt,
  });


  factory AnthropometricsDTO.fromDomain(Anthropometrics data) => AnthropometricsDTO(
      anthropometricID: data.anthropometricID,
      userID: data.userUUID,
      height: data.height,
      weight: data.weight,
      smm: data.smm,
      fatMass: data.fatMass,
      bodyFatPercentage: data.bodyFatPercentage,
      bmi: data.bmi,
      whr: data.whr,
      registeredAt: data.registeredAt!,
    );


  Anthropometrics toDomain() => Anthropometrics(
    anthropometricID: anthropometricID,   
    userUUID: userID,                   
    height: height,
    weight: weight,
    smm: smm,
    fatMass: fatMass,
    bodyFatPercentage: bodyFatPercentage,
    bmi: bmi,
    whr: whr,
    registeredAt: registeredAt, 
    );



  Map<String, dynamic> toJson() {
    return {
      "anthropometricID": anthropometricID.toString(),
      "userUUID": userID.toString(),
      "height": height,
      "weight": weight,
      "smm": smm,
      "fatMass": fatMass,
      "bodyFatPercentage": bodyFatPercentage,
      "bmi": bmi,
      "whr": whr,
      "registeredAt": registeredAt!.toUtc().toIso8601String(),
    };    
  }


  factory AnthropometricsDTO.fromJson(Map<String, dynamic> json) {
    return AnthropometricsDTO(
      userID: (json['userCode'] as String),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      smm: (json['smm'] as num).toDouble(),
      fatMass: (json['fatMass'] as num).toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      whr: (json['whr'] as num).toDouble(),
      
      registeredAt: json['registeredAt'] != null 
          ? DateTime.parse(json['registeredAt'] as String).toLocal() 
          : null,
    );
  }


  factory AnthropometricsDTO.fromMap(Map<String, dynamic> row) {
    return AnthropometricsDTO(
      anthropometricID: row['anthropometricID'] as String,
      userID: row['userUUID'] as String,
      height: (row['height'] as num).toDouble(),
      weight: (row['weight'] as num).toDouble(),
      smm: (row['smm'] as num).toDouble(),
      fatMass: (row['fatMass'] as num).toDouble(),
      bodyFatPercentage: (row['bodyFatPercentage'] as num).toDouble(),
      bmi: (row['bmi'] as num).toDouble(),
      whr: (row['whr'] as num).toDouble(),
      registeredAt: DateTime.parse(row['registeredAt'] as String).toLocal(),
    );
  }


  Map<String, dynamic> toMap() => {
      'anthropometricID': anthropometricID,
      'userUUID': userID,
      'height': height,
      'weight': weight,
      'smm': smm,
      'fatMass': fatMass,
      'bodyFatPercentage': bodyFatPercentage,
      'bmi': bmi,
      'whr': whr,
      'registeredAt': registeredAt!.toIso8601String(),
  };
}