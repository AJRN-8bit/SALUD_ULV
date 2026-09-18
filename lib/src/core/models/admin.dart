
import 'package:salud_ulv_app/src/core/models/user.dart';

class Admin implements IUser{
  @override
  String? userUUID;
  @override
  String? userCode;
  @override
  String? firstname;
  @override
  String? surname;
  @override
  String? lastname;
  @override
  String? email;

  String? currentRole;
  List<String>? roles;
  
  @override
  DateTime? createdAt;

  Admin({
    this.userUUID,
    this.userCode,
    this.firstname,
    this.surname,
    this.lastname,
    this.email,
    this.currentRole,
    this.roles,
    this.createdAt
  });
}