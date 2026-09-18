import 'dart:convert';

import 'package:salud_ulv_app/src/core/models/user.dart';

class UserDTO {
  final String? userUUID;
  final String? userCode;       
  final String? firstname;
  final String? surname;
  final String? lastname;
  final String? email;
  final String? currentRole;
  final List<String>? roles;
  final DateTime? createdAt;

  const UserDTO({
    this.userUUID,
    this.userCode,              
    this.firstname,
    this.surname,
    this.lastname,
    this.email,
    this.currentRole,
    this.roles,
    this.createdAt,
  });

  factory UserDTO.fromMap(Map<String, dynamic> map) => UserDTO(
    userUUID: map['userUUID'],
    userCode: map['userCode'],  
    firstname: map['firstname'] ?? '',
    surname: map['surname'] ?? '',
    lastname: map['lastname'] ?? '',
    email: map['email'] ?? '',
    currentRole: map['currentRole'],
    roles: List<String>.from(jsonDecode(map['roles'])), // to convert to string
    createdAt: map['createdAt'] != null
        ? DateTime.parse(map['createdAt'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'userUUID': userUUID,
    'userCode': userCode,       
    'firstname': firstname,
    'surname': surname,
    'lastname': lastname,
    'email': email,
    'currentRole': currentRole,
    'roles': jsonEncode(roles),  // to make it a single string
    'createdAt': createdAt?.toIso8601String(),
  };


  Map<String, dynamic> rolesToMap() => {
    'currentRole': currentRole,
    'roles': jsonEncode(roles),  // to make it a single string
  };


  factory UserDTO.fromJWT(Map<String, dynamic> data) => UserDTO(
    userUUID: data['uuid'],
    userCode: data['userCode'], 
    // firstname: data['firstname'] ?? '',
    // surname: data['surname'] ?? '',
    // lastname: data['lastname'] ?? '',
    email: data['email'] ?? '',
    // currentRole: data['currentRole'],
    roles: data['roles'],
  );


  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    userUUID: json['userUUID'],
    userCode: json['userCode'], 
    firstname: json['firstname'] ?? '',
    surname: json['surname'] ?? '',
    lastname: json['lastname'] ?? '',
    email: json['email'] ?? '',
    // currentRole: json['currentRole'],
    roles: List<String>.from(jsonDecode(json['roles'])),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
  );


  Map<String, dynamic> toJson() => {
    "userUUID": userUUID.toString(),
    "userCode": userCode.toString(),       
    "firstname": firstname.toString(),
    "surname": surname.toString(),
    "lastname": lastname.toString(),
    "email": email.toString(),
    // "password": password.toString(),
    // "currentRole": currentRole.toString(),
    // "roles": roles.toString(),
    "createdAt": createdAt?.toIso8601String(),
  };


  factory UserDTO.fromDomain(User user) => UserDTO(
    userUUID: user.userUUID,
    userCode: user.userCode,    
    firstname: user.firstname,
    surname: user.surname,
    lastname: user.lastname,
    email: user.email,
    currentRole: user.currentRole,
    roles: user.roles,
    createdAt: user.createdAt,
  );

  factory UserDTO.fromPartialDomain(User user) => UserDTO(
    // userUUID: user.userUUID,
    userCode: user.userCode,    
    firstname: user.firstname,
    surname: user.surname,
    lastname: user.lastname,
    // email: user.email,
    // currentRole: user.currentRole,
    // roles: user.roles,
    // createdAt: user.createdAt,
  );

  User toDomain() => User(
    userUUID: userUUID,
    userCode: userCode,         
    firstname: firstname,
    surname: surname,
    lastname: lastname,
    email: email,
    currentRole: currentRole,
    roles: roles,
    createdAt: createdAt,
  );


  factory UserDTO.toProfile(User user) => UserDTO(
    userCode: user.userCode,
    firstname: user.firstname, 
    surname: user.surname, 
    lastname: user.lastname, 
    email: user.email
    );


  factory UserDTO.toGroupMember(User user) => UserDTO(
    userCode: user.userCode,
    firstname: user.firstname, 
    surname: user.surname, 
    lastname: user.lastname, 
    );

  
  // ─── Group JSON → DTO ───────────────────────────
  // Groups only return basic member information.
  factory UserDTO.fromGroupJson(Map<String, dynamic> json) {
    return UserDTO(
      userCode: json['userCode'],
      firstname: json['firstname'],
      surname: json['surname'],
      lastname: json['lastname'],
    );
  }
}