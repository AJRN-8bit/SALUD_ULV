// Contais the base data of the persons who will use the app.
// Base to any type of user, such as employees, coaches and admins.


abstract class IUser{
  String? userUUID;
  String? userCode;
  String? firstname;
  String? surname;
  String? lastname;
  String? email;
  // String? currentRole;
  // List<String>? roles;
  DateTime? createdAt;

  IUser({
    this.userUUID,
    this.userCode,
    this.firstname,
    this.surname,
    this.lastname,
    this.email,
    // this.currentRole,
    // this.roles,
    this.createdAt
  });
}


class User implements IUser{
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

  User({
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