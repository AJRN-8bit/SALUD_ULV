

import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/exercise_samples.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/exercise_sample_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/activity_samples_dto.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/current_user_session.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/db_config.dart';
import 'package:sqflite/sqflite.dart';

class WalkSamplesRepo implements IActivitySampleRepo{
  Future<Database> get _db async => await AppDatabase.database;
  final _tableName = 'WalkActivitySample';
  // final CurrentUserSession currentUserSession = CurrentUserSession();

  // @override
  // Future<void> save(ActivitySample data) async {
  //   try {
  //     final db = await _db;
  //     debugPrint('saving samples to db');

  //     data = data as WalkActivitySample;
  //     final model = WalkActivitySampleDTO.fromDomain(data).toMap();
  //     // debugPrint(model.toString());

  //     await db.insert(_tableName, model);
      
  //   } catch (e) {
  //     throw Exception("Error in saving data");
  //   }
  // }


  @override
Future<void> save(ActivitySample data) async {
  try {
    final db = await _db;

    final sample = data as WalkActivitySample;
    final model = WalkActivitySampleDTO
        .fromDomain(sample)
        .toMap();

    debugPrint('========== INSERT SAMPLE ==========');

    debugPrint('DB: $db');
    debugPrint('SAVE DB: ${identityHashCode(db)}');
    debugPrint('ID: [${sample.activityID}]');
    debugPrint('MODEL: $model');

    final id = await db.insert(
      _tableName,
      model,
    );

    debugPrint('INSERTED ROW ID: $id');

    // Immediately query it using THE SAME db instance.
    final check = await db.query(
      _tableName,
      where: 'sampleID = ?',
      whereArgs: [id],
    );

    debugPrint('IMMEDIATE CHECK: $check');
  } catch (e, stackTrace) {
    debugPrint('ERROR INSERTING SAMPLE: $e');
    debugPrintStack(stackTrace: stackTrace);

    throw Exception("Error in saving data");
  }
}



  // @override
  // Future<List<IActivitySample>?>getSamples (String activityID) async {
  //   try {
  //     debugPrint('in db: $activityID');
  //     final db = await _db;

  //     final data = await db.query(
  //       _tableName, 
  //       where: 'activityID = ?',
  //       whereArgs: [activityID],
  //       orderBy: 'timestamp_ms DESC');

  //     debugPrint('data samples from db: $data');

  //     final result = data.map((row) => WalkActivitySampleDTO.fromMap(row).toDomain()).toList();
  //     // debugPrint(result.toString());

  //     return result;

  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw Exception("Error in getting data");
  //   }
  // }

@override
Future<List<IActivitySample>?> getSamples(String activityID) async {
  try {
    final db = await _db;

    // debugPrint('========== GET SAMPLES ==========');
    // debugPrint('GET DB: ${identityHashCode(db)}');

    // debugPrint('Searching activityID: [$activityID]');
    // debugPrint('Table: $_tableName');

    // First: see EVERYTHING in the table
    final allRows = await db.query(_tableName);

    debugPrint('TOTAL ROWS: ${allRows.length}');

    // for (final row in allRows) {
    //   // debugPrint(
    //   //   'DB sampleID=${row['sampleID']} '
    //   //   'activityID=[${row['activityID']}]',
    //   // );
    // }

    // Second: query specifically
    final data = await db.query(
      _tableName,
      where: 'activityID = ?',
      whereArgs: [activityID],
      orderBy: 'timestamp_ms ASC',
    );

    // debugPrint('MATCHING ROWS: ${data.length}');
    // debugPrint('MATCHING DATA: $data');

    final result = data
        .map(
          (row) => WalkActivitySampleDTO
              .fromMap(row)
              .toDomain(),
        )
        .toList();

    // debugPrint('RESULT: ${result.length}');

    return result;
  } catch (e, stackTrace) {
    // debugPrint('GET SAMPLES ERROR: $e');
    // debugPrintStack(stackTrace: stackTrace);

    throw Exception("Error in getting data");
  }
}



  @override
  Future<void> delete(String activityID) async{
    try {
      final db = await _db;

      await db.delete(
        _tableName,
        where: 'activityID == ?',
        whereArgs: [activityID]
      );
      
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error in deleting data");
    }
  }

}