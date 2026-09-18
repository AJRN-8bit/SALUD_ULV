import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/user_dto.dart';

class MemberDTO extends UserDTO {
  final String? groupID;
  final DateTime? dateOfBirth;
  final String gender;
  final String? typeID;
  final int? age;

  const MemberDTO({
    super.userUUID,
    super.userCode,
    this.groupID,
    required super.firstname,
    required super.surname,
    required super.lastname,
    required super.email,
    super.currentRole,
    super.roles,
    super.createdAt,
    this.dateOfBirth,
    required this.gender,
    this.typeID,
    this.age,
  });

  // ── domain → DTO ─────────────────────────────
  factory MemberDTO.fromDomain(Member member) => MemberDTO(
    userUUID: member.userUUID,
    userCode: member.userCode,
    firstname: member.firstname,
    surname: member.surname,
    lastname: member.lastname,
    email: member.email,
    currentRole: member.currentRole,
    createdAt: member.createdAt,
    dateOfBirth: member.dateOfBirth,
    gender: member.gender,
    // occupation: member.occupation,
    age: member.age,
  );

  // ── DTO → domain ─────────────────────────────
  Member toMemberDomain() => Member(
    userUUID: userUUID,
    userCode: userCode,
    firstname: firstname,
    surname: surname,
    lastname: lastname,
    email: email,
    currentRole: currentRole,
    // roles: role,
    createdAt: createdAt,
    dateOfBirth: dateOfBirth,
    gender: gender,
    // occupation: occupation,
    age: age,
  );

  // ── sqlite → DTO ─────────────────────────────
  factory MemberDTO.fromMap(Map<String, dynamic> row) => MemberDTO(
    userUUID: row['userUUID'] as String?,
    userCode: row['userCode'] as String?,
    firstname: row['firstname'] ?? '',
    surname: row['surname'] ?? '',
    lastname: row['lastname'] ?? '',
    email: row['email'] ?? '',
    currentRole: row['currentRole'] ?? '',
    // role: row['role'] != null ? List<String>.from(row['role']) : null,
    createdAt: row['createdAt'] != null
        ? DateTime.parse(row['createdAt'] as String).toLocal()
        : null,
    dateOfBirth: DateTime.parse(row['dateOfBirth'] as String),
    gender: row['gender'] as String,
    typeID: row['occupation'] as String?,
    age: row['age'] as int?,
  );

  // ── DTO → sqlite ─────────────────────────────
  @override
  Map<String, dynamic> toMap() => {
    ...super.toMap(), // ← inherits base fields
    'dateOfBirth': dateOfBirth!.toIso8601String(),
    'gender': gender,
    'occupation': typeID,
    'age': age,
  };

  // ── JSON → DTO ───────────────────────────────
  factory MemberDTO.fromJson(Map<String, dynamic> json) => MemberDTO(
    userUUID: json['userUUID'] as String?,
    userCode: json['userCode'] as String?,
    firstname: json['firstname'] ?? '',
    surname: json['surname'] ?? '',
    lastname: json['lastname'] ?? '',
    email: json['email'] ?? '',
    currentRole: json['currentRole'] ?? '',
    // role: json['role'] != null ? List<String>.from(json['role']) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String).toLocal()
        : null,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    gender: json['gender'] as String,
    typeID: json['occupation'] as String?,
    age: json['age'] as int?,
  );

  // ── DTO → JSON ───────────────────────────────
  @override
  Map<String, dynamic> toJson() => {
    // ...super.toJson(password), // ← inherits base fields
    'dateOfBirth': dateOfBirth!.toIso8601String(),
    'gender': gender,
    // 'occupation': occupation,
    'age': age,
  };
}




class MemberInfoDTO {
  final String? userUUID;
  final int? groupID;
  final int? typeID;
  final DateTime? dateOfBirth;
  final int? age;
  final String? gender;

  MemberInfoDTO({
    this.userUUID,
    this.groupID,
    this.typeID,
    this.dateOfBirth,
    this.age,
    this.gender,
  });


  factory MemberInfoDTO.fromDomain(MemberInfo info) => MemberInfoDTO(
    userUUID: info.userUUID,
    groupID: info.groupID,
    typeID: info.typeID,
    dateOfBirth: info.dateOfBirth,
    age: info.age,
    gender: info.gender,
    // occupation: info.occupation,
  );

  MemberInfo toDomain() => MemberInfo(
    userUUID: userUUID, 
    groupID: groupID,
    typeID: typeID,
    dateOfBirth: dateOfBirth, 
    age: age, 
    gender: gender
  );


  factory MemberInfoDTO.fromMap(Map<String, dynamic> row) => MemberInfoDTO(
    userUUID: row['userUUID'],
    groupID: row['groupID'],
    typeID: row['typeID'],
    dateOfBirth: row['dateOfBirth'] != null 
       ? DateTime.parse(row['dateOfBirth']) 
       : null,
    age: row['age'], 
    gender: row['gender']
  );

  Map<String, dynamic> toMap() => {
    "userUUID": userUUID,
    "groupID": groupID,
    "typeID": typeID,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "age": age,
    "gender": gender,
  };

  Map<String, dynamic> toJson() => {
    'userUUID': userUUID,
    'dateOfBirth': dateOfBirth!.toIso8601String(),
    'age': age,
    'gender': gender,
  };


}