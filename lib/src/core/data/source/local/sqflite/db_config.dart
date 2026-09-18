

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;
  AppDatabase._instance();
  static final AppDatabase instance = AppDatabase._instance();

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'SaludULV.db');


    return await openDatabase(
      path, 
      version: 1, 
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Users (
            userUUID TEXT PRIMARY KEY NOT NULL,
            userCode TEXT UNIQUE NOT NULL,
            firstname TEXT NOT NULL,
            surname TEXT NOT NULL,
            lastname TEXT NOT NULL,
            email TEXT NOT NULL,
            currentRole TEXT DEFAULT NULL,
            roles TEXT DEFAULT NULL,
            createdAt TEXT NOT NULL
          )
        '''); 

        await db.execute('''
          CREATE TABLE Members (
            userUUID TEXT PRIMARY KEY REFERENCES Users(userUUID),
            groupID INTEGER NULL,
            typeID INTERGET NULL,

            dateOfBirth TEXT DEFAULT NULL,
            age INTEGER DEFAULT NULL,
            level INTEGER NULL DEFAULT 0,
            gender TEXT DEFAULT NULL
            
          )
        '''); 


      await db.execute('''
        CREATE TABLE Anthropometrics (
          anthropometricID TEXT PRIMARY KEY NOT NULL,
          userUUID TEXT NOT NULL REFERENCES Users(userUUID),
          height REAL NOT NULL,
          weight REAL NOT NULL,
          smm REAL NOT NULL,
          fatMass REAL NOT NULL,
          bodyFatPercentage REAL NOT NULL,
          bmi REAL NOT NULL,
          whr REAL NOT NULL,
          registeredAt TEXT NOT NULL,
          
          isSynced INTEGER NOT NULL DEFAULT 0
        )
      ''');




      // Categories
       await db.execute('''
        CREATE TABLE ActivityCategory (
          categoryID INTEGER PRIMARY KEY,
          categoryName TEXT NOT NULL
        )
      ''');

      // Sets categories
      await db.insert('ActivityCategory', {'categoryID': 1, 'categoryName': 'aerobic'});
      await db.insert('ActivityCategory', {'categoryID': 2, 'categoryName': 'strength'});





      await db.execute('''
        CREATE TABLE WalkActivity (
          activityID TEXT PRIMARY KEY NOT NULL,
          userUUID TEXT NOT NULL REFERENCES Users(userUUID),
          categoryID INTEGER NOT NULL REFERENCES ActivityCategory(categoryID),

          duration_ms INTEGER DEFAULT NULL,
          caloriesBurned REAL DEFAULT NULL,
          registeredAt TEXT DEFAULT NULL,

          distance REAL DEFAULT NULL,
          avgPace REAL DEFAULT NULL,
          elevationGain REAL DEFAULT NULL,
          avgCadence REAL DEFAULT NULL,
          heartRate REAL DEFAULT NULL,

          steps INTEGER DEFAULT NULL,
          avgSteps REAL DEFAULT NULL,

          isSynced INTEGER NOT NULL DEFAULT 0
        )
      ''');  // Steps is null to allow devices with no accelerometer

      await db.execute('''
        CREATE INDEX idx_WalkActivity_activity_useruuid
        ON WalkActivity(activityID, userUUID)
      ''');


            // Exercise cache
      // Steps just for walking
      await db.execute('''
        CREATE TABLE WalkActivitySample (
          sampleID INTEGER PRIMARY KEY AUTOINCREMENT,
          activityID TEXT NOT NULL REFERENCES WalkActivity(activityID),

          timestamp_ms INTEGER NOT NULL,

          heartRate INTEGER DEFAULT NULL,
          distance REAL DEFAULT NULL,
          calories REAL DEFAULT NULL,
          steps INTEGER DEFAULT NULL,
          pace REAL DEFAULT NULL,
          speed REAL DEFAULT NULL,
          cadence REAL DEFAULT NULL,
          elevation REAL DEFAULT NULL,

          latitude REAL DEFAULT NULL,
          longitude REAL DEFAULT NULL
        )
      ''');


      await db.execute('''
        CREATE INDEX idx_WalkActivitySample_activity_timestamp
        ON WalkActivitySample(activityID, timestamp_ms)
      ''');



      }
    );
  }
}