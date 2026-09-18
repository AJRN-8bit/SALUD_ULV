import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/anthro_dto.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/db_config.dart';
import 'package:sqflite/sqflite.dart';




class AnthroLocalStorage implements IAnthropometricLocalRepo{
  Future<Database> get _db async => await AppDatabase.database;
  // final CurrentUserSession currentUserSession = CurrentUserSession();

  @override
  Future<void> save(Anthropometrics data) async {
    try {

      final db = await _db;
      final model = AnthropometricsDTO.fromDomain(data);

      await db.insert('Anthropometrics', model.toMap());
      
    } catch (e) {
      throw Exception("Error in saving data");
    }
  }


  @override
  Future<List<Anthropometrics>?> getAll(String userUUID) async{
    try {
      final db = await _db;

      final data = await db.query(
        'Anthropometrics', 
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt ASC');

      if(data.isEmpty) return null;

      final result = data.map((row) => AnthropometricsDTO.fromMap(row).toDomain()).toList();
      return result;
      
    } catch (e) {
      throw Exception("Error while getting data");
    }
  }

  
  @override
  Future<Anthropometrics?> getRecent(String userUUID) async{
    try {
      final db = await _db;

      final data = await db.query('Anthropometrics', 
        where: 'userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt DESC',
        limit: 1);

      if(data.isEmpty) return null;
      

      final result = AnthropometricsDTO.fromMap(data.first).toDomain();
      return result;
      
    } catch (e) {
      throw Exception("Error while getting data");
    }
  }


  @override
  Future<List<Map<String,dynamic>>?> getByField(String userUUID, String field) async{
    try {
      final db = await _db;

      final data = await db.query('Anthropometrics', 
        columns: ['registeredAt', field,], 
        where: '$field IS NOT NULL AND userUUID = ?',
        whereArgs: [userUUID],
        orderBy: 'registeredAt DESC'
        ); 

      if(data.isEmpty) return null;

      final result = data.map((row) => {
        'value': (row[field] as num).toDouble(),
        'date': DateTime.parse(row['registeredAt'] as String).toLocal(),
      }).toList();
      
      return result;
      
    } catch (e) {
      throw Exception("Error while getting data");
    }
  }


  @override
  Future<void> markAsSynced(String anthropometricID) async {
    try {
      final db = await _db;

      await db.update(
        'Anthropometrics', 
        {'isSynced': 1},
        where: 'anthropometricID = ?',
        whereArgs: [anthropometricID]
      );
      
    } catch (e) {
      return;
    }
  }


  @override
  Future<List<Anthropometrics>?> getUnsynced(String userUUID) async {
    try {
      final db = await _db;

      final data = await db.query(
        'Anthropometrics',
        where: 'userUUID = ? AND isSynced = ?',
        whereArgs: [userUUID, 0],
        orderBy: 'registeredAt DESC'
      );

      final result = data.map((row) => AnthropometricsDTO.fromMap(row).toDomain()).toList();
      return result;

    } catch (e) {
      return [];
    }
  }
}
