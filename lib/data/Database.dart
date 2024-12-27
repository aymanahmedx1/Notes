import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      return await openDatabase(path, onCreate: _onCreate, version: 1);
    } catch (e) {
      log(e.toString());
    }
  }

  delete() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    await deleteDatabase(path);
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
    int result = await db.rawDelete(Sql, list);
    return result;
  }
}
