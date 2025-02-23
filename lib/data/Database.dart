import 'dart:developer';

import 'package:notes/data/LoginDb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  Database? db;

  Future<Database> get database async {
    db ??= await initDatabase();
    return db!;
  }

  initDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'notes.db');
      return await openDatabase(path,
          onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE worker ADD COLUMN price FLOAT DEFAULT 0.0
    ''');
    }
  }

  _onCreate(Database db, int versoin) async {
    await db.execute('''
                          CREATE TABLE "expense" (
                            "id"	INTEGER,
                            "reason"	TEXT,
                            "amount"	REAL,
                            "note"	TEXT,
                            "section" INTEGER ,
                            "date" TEXT , 
                            "expense_type" INTEGER ,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
    await db.execute('''  CREATE TABLE "section" (
                            "id"	INTEGER,
                            "name"	TEXT,
                            "totalIn"	REAL,
                            "totalOut"	REAL,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
    await db.execute(''' CREATE TABLE "worker" (
                            "id"	INTEGER,
                            "name"	TEXT,
                            "phone"	TEXT,
                            "company"	INTEGER,
                            "drug"	TEXT,
                            "total" INTEGER,
                            "out" INTEGER,
                            "note" TEXT,
                            "date" TEXT , 
                            "expDate" TEXT , 
                            "finish" INTEGER , 
                            "price" FLOAT DEFAULT 0.0,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
    await db.execute('''CREATE TABLE "company" (
                        "id"	INTEGER,
                        "name"	TEXT,
                        "note"	TEXT,
                        "date"	TEXT,
                        PRIMARY KEY("id" AUTOINCREMENT)
                          );''');

    await db.execute('''CREATE TABLE "movements" (
                        "id"	INTEGER,
                        "workerId"	INTEGER,
                        "qty"	INTEGER,
                        "date"	TEXT,
                        PRIMARY KEY("id" AUTOINCREMENT)
                          );''');

    await db.execute('''
                          CREATE TABLE "personal_expense" (
                            "id"	INTEGER,
                            "reason"	TEXT,
                            "amount"	REAL,
                            "note"	TEXT,
                            "section" INTEGER ,
                            "date" TEXT , 
                            "expense_type" INTEGER ,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
    await db.execute('''  CREATE TABLE "personal" (
                            "id"	INTEGER,
                            "name"	TEXT,
                            "totalIn"	REAL,
                            "totalOut"	REAL,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
    await db.execute('''  CREATE TABLE "user_password" (
                            "id"	INTEGER,
                            "user_pass"	TEXT,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );''');
  }


  Future<String> getDatabaseBackup() async {


    // List of all tables in your database
    List<String> tables = [
      'worker',
      'company',
      'movements',
      'expense',
      'section',
      'personal_expense',
      'personal',
      'user_password'
    ];

    // Create a JSON structure
    Map<String, dynamic> backupData = {};

    // Fetch data from each table and store it in the JSON object
    for (String table in tables) {
      Database db = await database;
      List<Map<String, dynamic>> tableData = await db.query(table);
      backupData[table] = tableData;
    }

    // Convert the backup data to JSON string
    String jsonBackup = jsonEncode(backupData);

    return jsonBackup;
  }

  Future<void> restoreDatabaseFromBackup(String jsonBackup) async {
    final db = await initDatabase();
    Map<String, dynamic> backupData = jsonDecode(jsonBackup);

    await db.transaction((txn) async {
      for (String table in backupData.keys) {
        List<dynamic> records = backupData[table];

        for (var record in records) {
          // Convert dynamic Map<String, dynamic>
          Map<String, dynamic> row = Map<String, dynamic>.from(record);

          // Remove 'id' to let SQLite auto-generate it (optional)
          row.remove("id");

          // Insert into table
          var x = await txn.insert(table, row);
          log(x.toString());
        }
      }
    });
  }



  delete() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    await deleteDatabase(path);
  }

  readData(String Sql, List<dynamic> list) async {
    Database db = await database;
    return await db.rawQuery(Sql, list);
    //return list ;
  }

  insertData(String Sql, List<dynamic> list) async {
    Database db = await database;
    int result = await db.rawInsert(Sql, list);
    return result;
  }

  updateData(String Sql, List<dynamic> list) async {
    Database db = await database;
    int result = await db.rawUpdate(Sql, list);
    return result;
  }

  deleteData(String Sql, List<dynamic> list) async {
    Database db = await database;
    await db.execute(Sql, list);
    return 0;
  }
}
