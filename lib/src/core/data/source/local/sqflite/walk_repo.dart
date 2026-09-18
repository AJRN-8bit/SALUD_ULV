import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/walk_dto.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/current_user_session.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/db_config.dart';
import 'package:sqflite/sqflite.dart';

class WalkRepo implements IExerciseLocalRepo {
  Future<Database> get _db async => await AppDatabase.database;
  // final CurrentUserSession currentUserSession = CurrentUserSession();

  final _tableName = 'WalkActivity';

  @override
Future<void> setIDs(
  String activityID,
  String userUUID,
  int categoryID,
) async {
  try {
    final db = await _db;

    final model = {
      'activityID': activityID,
      'userUUID': userUUID,
      'categoryID': categoryID,
    };

    final id = await db.insert(
      _tableName,
      model,
    );

    debugPrint('Created activity: $activityID');
    debugPrint('Inserted activity row: $id');

    final check = await db.query(
      _tableName,
      where: 'activityID = ?',
      whereArgs: [activityID],
    );

    debugPrint('ACTIVITY AFTER CREATION: $check');
  } catch (e, stackTrace) {
    debugPrint('ERROR SETTING ACTIVITY IDS: $e');
    debugPrintStack(stackTrace: stackTrace);

    throw Exception("Error setting walk activity IDs");
  }
}


  @override
  Future<void> save(IPhysicalActivity exercise) async {
    try {
      final db = await _db;
      final model = WalkDTO.fromDomain(exercise as Walk).toMapFields();
      debugPrint('Saving walk data to db');
      debugPrint(model.toString());

      // await db.update(
      //   _tableName,
      //   model,
      //   where: 'activityID == ?',
      //   whereArgs: [exercise.activityID],
      // );

      final updatedRows = await db.update(
        _tableName,
        model,
        where: 'activityID = ?',
        whereArgs: [exercise.activityID],
      );

      debugPrint(
        'Updated $updatedRows rows for activity ${exercise.activityID}',
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving walk activity");
    }
  }

  @override
  Future<String?> getRecentID(String userUUID) async {
    try {
      final db = await _db;

      final data = await db.query(
        _tableName,
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt DESC',
        limit: 1,
      );

      if (data.isEmpty) return null;
      debugPrint(data.toString());

      final result = WalkDTO.fromMap(data.first).toDomain();
      // debugPrint(WalkDTO.fromMap(data.first).toString());
      // debugPrint('Date from db: ${result.registeredAt.toString()}');


      return result.activityID;
    } catch (e) {
      throw Exception("Error while getting recent data");
    }
  }

  @override
  Future<IPhysicalActivity?> getRecent(String userUUID) async {
    try {
      final db = await _db;

      final data = await db.query(
        _tableName,
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt DESC',
        limit: 1,
      );

      if (data.isEmpty) return null;
      // debugPrint('Recent data in db: $data');

      final result = WalkDTO.fromMap(data.first).toDomain();
      // debugPrint(WalkDTO.fromMap(data.first).toString());
      // debugPrint('Date from db: ${result.registeredAt.toString()}');

      return result;
    } catch (e) {
      throw Exception("Error while getting recent data");
    }
  }

  @override
  Future<List<IPhysicalActivity>> getAll(String userUUID) async {
    try {
      final db = await _db;


//       await db.delete(
//   _tableName,
//   where: 'activityID = ?',
//   whereArgs: ["1E2D6A45-07FF-4BBD-A5AA-86E5C45C2E95"],
// );



// final result1 = await db.query(
//   _tableName,
//   where: 'registeredAt IS NULL',
// );

// debugPrint(result1.toString());


      final data = await db.query(
        _tableName,
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt DESC',
      );



      final result = data
          .map((row) => WalkDTO.fromMap(row).toDomain())
          .toList();
      return result;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error while getting all data");
    }
  }

  // @override
  // Future<void> delete(String exerciseType, String activityID) async {
  //   try {
  //     final db = await _db;
  //     await db.delete(_tableName(exerciseType), where: 'activityID = ?', whereArgs: [activityID]);
  //   } catch (e) {
  //     throw Exception("Error deleting from $exerciseType");
  //   }
  // }
  @override
  Future<void> markAsSynced(String activityID) async {
    try {
      final db = await _db;

      await db.update(
        _tableName,
        {'isSynced': 1},
        where: 'activityID = ?',
        whereArgs: [activityID],
      );
    } catch (e) {
      return;
    }
  }

  @override
  Future<List<IPhysicalActivity>?> getUnsynced(String userUUID) async {
    try {
      final db = await _db;

      final data = await db.query(
        _tableName,
        where: 'userUUID = ? AND isSynced = ?',
        whereArgs: [userUUID, 0],
        orderBy: 'registeredAt DESC',
      );

      final result = data
          .map((row) => WalkDTO.fromMap(row).toDomain())
          .toList();
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> delete(String userUUID, String activityID) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}







//   static String _resolveTableName(String type) => switch (type) {
//       'walk' => 'WalkActivity',
//       // 'run' => 'RunActivity',
//       // 'swim' => 'SwimActivity',
//       _ => throw Exception('Unsupported activity type: $type'),
//     };

//   PhysicalActivity Function(Map<String, dynamic>) get _fromMap => switch (tableName) {
//       'WalkActivity' => (row) => WalkDTO.fromMap(row).toDomain(),
//       // 'RunActivity' => (row) => RunDTO.fromMap(row).toDomain(),
//       // 'SwimActivity' => (row) => SwimDTO.fromMap(row).toDomain(),
//       _ => throw Exception('Unsupported table: $tableName'),
//     };

//   Map<String, dynamic> Function(PhysicalActivity) get _toMap => switch (tableName) {
//         'WalkActivity' => (a) => WalkDTO.fromDomain(a as Walk).toMap(),
//         // 'RunActivity' => (a) => RunDTO.fromDomain(a as Run).toMap(),
//         // 'SwimActivity' => (a) => SwimDTO.fromDomain(a as Swim).toMap(),
//         _ => throw Exception('Unsupported table: $tableName'),
//       };



//   @override
//   Future<void> save(PhysicalActivity exercise) async {
//     try {
//       final db = await _db;
//       await db.insert(tableName, _toMap(exercise));
//     } catch (e) {
//       throw Exception("Error saving to $tableName");
//     }
//   }



//   @override
//   Future<PhysicalActivity?> getRecent(String exerciseType) async {
//     try {
//       final db = await _db;
//       final userUUID = await currentUserSession.getCurrentUserUUID();
//       if (userUUID == null) return null;

//       final data = await db.query(
//         tableName,
//         where: 'userUUID = ?',
//         whereArgs: [userUUID],
//         orderBy: 'registeredAt DESC',
//         limit: 1,
//       );
//       if (data.isEmpty) return null;

//       return _fromMap(data.first);
//     } catch (e) {
//       throw Exception("Error while getting recent data from $tableName");
//     }
//   }



//   @override
//   Future<List<PhysicalActivity>> getAll(String exerciseType) async {
//     try {
//       final db = await _db;
//       final userUUID = await currentUserSession.getCurrentUserUUID();
//       if (userUUID == null) return [];

//       final data = await db.query(tableName, where: 'userUUID = ?', whereArgs: [userUUID]);
//       return data.map(_fromMap).toList();
//     } catch (e) {
//       throw Exception("Error while getting all data from $tableName");
//     }
//   }



//   @override
//   Future<void> delete(String activityID) async {
//     try {
//       final db = await _db;
//       await db.delete(tableName, where: 'activityID = ?', whereArgs: [activityID]);
//     } catch (e) {
//       throw Exception("Error deleting from $tableName");
//     }
//   }
// }




// @override
//   Future<void> save(PhysicalActivity exercise) async {
//     try {
//       final db = await _db;
      
//       // Using a switch expression returning a Record (model, tableName)
//       final (model, targetTable) = switch (exercise) {
//         Walk walk => (WalkDTO.fromDomain(walk).toMap(), 'WalkActivity'),
//         _ => throw Exception("Unsupported activity type"),
//       };

//       debugPrint(model.toString());
//       await db.insert(targetTable, model);
      
//     } catch (e) {
//       debugPrint(e.toString());
//       throw Exception("Error in saving data");
//     }
//   }




//   @override
//   Future<PhysicalActivity?> getRecent() async {
//     try {
//       final db = await _db;

//       final userUUID = await currentUserSession.getCurrentUserUUID();
//       if(userUUID == null) return null;

//       final sources = <(String table, PhysicalActivity Function(Map<String, dynamic>) fromMap)>[
//         ('WalkActivity', (row) => WalkDTO.fromMap(row).toDomain()),
//       // ('RunActivity', (row) => RunDTO.fromMap(row).toDomain()),
//       // ('CycleActivity', (row) => CycleDTO.fromMap(row).toDomain()),
//       ];


//       PhysicalActivity? mostRecent;

//       for (final (table, fromMap) in sources) {
//         final rows = await db.query(
//           table,
//           where: 'userUUID = ?',
//           whereArgs: [userUUID],
//           orderBy: 'registryDate DESC',
//           limit: 1,
//         );

//         if (rows.isEmpty) continue;

//         final candidate = fromMap(rows.first);

//         if (mostRecent == null ||
//             candidate.registryDate!.isAfter(mostRecent.registryDate!)) {
//           mostRecent = candidate;
//         }
//       }

//       return mostRecent;

//     } catch (e) {
//       debugPrint(e.toString());
//       throw Exception("Error in saving data");
//     }
//   }




//   @override
//   Future<List<PhysicalActivity>?> getAll() async {
//     try {
//             final db = await _db;

//       final userUUID = await currentUserSession.getCurrentUserUUID();
//       if(userUUID == null) return null;

//       final sources = <(String table, PhysicalActivity Function(Map<String, dynamic>) fromMap)>[
//         ('WalkActivity', (row) => WalkDTO.fromMap(row).toDomain()),
//       // ('RunActivity', (row) => RunDTO.fromMap(row).toDomain()),
//       // ('CycleActivity', (row) => CycleDTO.fromMap(row).toDomain()),
//       ];


//       final result = <PhysicalActivity>[];

//       for (final (table, fromMap) in sources) {
//         final data = await db.query(
//           table,
//           where: 'userUUID = ?',
//           whereArgs: [userUUID],
//           orderBy: 'registeredAt DESC',
//         );

//         result.addAll(data.map(fromMap));
//       }

//       result.sort((a, b) => b.registryDate!.compareTo(a.registryDate!));
//       return result;

//       } catch (e) {
//         debugPrint(e.toString());
//         throw Exception("Error in saving data");
//       }
//     }


  // @override
  // Future<void> update(PhysicalActivity exercise) {
  //   // TODO: implement update
  //   throw UnimplementedError();
  // }



//   @override
//   Future<void> delete(String uuid) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }
// }