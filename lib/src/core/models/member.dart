
import 'package:salud_ulv_app/src/core/models/user.dart';

class Member extends User{
  // final String? groupID;
  final DateTime? dateOfBirth;
  final int? age;
  //final int tier
  final String gender;
  // final String? occupation;

  Member({
    super.userUUID,
    super.userCode,
    required super.firstname,
    required super.surname,
    required super.lastname,
    required super.email,
    super.currentRole,
    super.roles,
    super.createdAt,

    this.dateOfBirth,
    required this.gender,
    this.age,

    // this.groupID,
    // this.occupation,
  });
  
}


class MemberInfo {
  String? userUUID;
  final int? groupID;
  final int? typeID;
  final DateTime? dateOfBirth;
  int? age;
  final String? gender;

  MemberInfo({
    this.userUUID,
    this.groupID,
    this.typeID,
    this.dateOfBirth,
    this.age,
    this.gender,
    // required this.occupation,
  });
}
