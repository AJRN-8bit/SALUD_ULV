import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/member_dto.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/db_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/user_dto.dart';

class MemberLocalRepo implements IUsersLocalRepo, IMemberLocalRepo {
  Future<Database> get _db async => await AppDatabase.database;
  final CurrentUserSession currentUserSession = CurrentUserSession();

  @override
  Future<void> saveInfo(MemberInfo memberInfo) async {
    try {
      final db = await _db;

      // debugPrint("${memberInfo.userUUID}, ${memberInfo.groupID}, ${memberInfo.typeID}, ${memberInfo.dateOfBirth}, ${memberInfo.age}, ${memberInfo.gender}");

      final model = MemberInfoDTO.fromDomain(memberInfo).toMap();
      debugPrint(model.toString());

      await db.insert(
        'Members', 
        model, 
        conflictAlgorithm: .replace
        );
        
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error saving member info');
    }
  }

  @override
  Future<User?> getUser(String userUUID) async {
    try {
      final db = await _db;

      final user = await db.query(
        'Users',
        where: 'userUUID = ?',
        whereArgs: [userUUID],
      );

      if (user.isEmpty) return null;

      final userResult = UserDTO.fromMap(user.first).toDomain();

      final member = await db.query(
        'Members',
        where: 'userUUID = ?',
        whereArgs: [userUUID],
      );

      if (member.isEmpty) return null;

      final memberResult = MemberInfoDTO.fromMap(member.first).toDomain();

      final result = MemberDTO(
        // Member construction
        userUUID: userResult.userUUID,
        userCode: userResult.userCode,
        firstname: userResult.firstname,
        surname: userResult.surname,
        lastname: userResult.lastname,
        email: userResult.email,
        currentRole: userResult.currentRole,
        // dateOfBirth: memberResult.dateOfBirth,
        // gender: memberResult.gender,
        // age: memberResult.age
        dateOfBirth: DateTime.now(),
        gender: 'female',
        age: 56,
      ).toDomain();

      debugPrint('In db getting member: ${result.toString()}');

      return result;
    } catch (e) {
      throw Exception("Couldn't get current user");
    }
  }

  @override
  Future<void> setGroupID(String userUUID, int groupID) async {
    try {
      final db = await _db;

      final groupIDModel = {'groupID': groupID};

      await db.update(
        'Members',
        groupIDModel,
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        conflictAlgorithm: .replace,
      );
    } catch (e) {
      throw Exception("Could not set group ID");
    }
  }

  @override
  Future<int?> getGroupID(String userUUID) async {
    try {
      final db = await _db;

      final result = await db.query(
        'Members',
        columns: ['groupID'],
        where: 'userUUID = ?',
        whereArgs: [userUUID],
      );

      if (result.isEmpty || result.first['groupID'] == null) return null;

      final data = result.first['groupID'] as int;

      return data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Couldn't get group ID");
    }
  }

  @override
  Future<int?> getMemberTypeID(String userUUID) async {
    try {
      final db = await _db;

      final result = await db.query(
        'Members',
        columns: ['typeID'],
        where: 'userUUID = ?',
        whereArgs: [userUUID],
      );

      debugPrint(result.toString());

      if (result.isEmpty || result.first['typeID'] == null) return null;

      final data = result.first['typeID'] as int;
      debugPrint('typeID: $data');

      return data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Couldn't get type ID");
    }
  }

  @override
  Future<void> delete(String uuid) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
