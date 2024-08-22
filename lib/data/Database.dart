import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? db;

  Future<Database> get database async {
    db ??= await initDatabase();
    return db!;
  }

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  delete() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    await deleteDatabase(path);
  }

  _onCreate(Database db, int versoin) async {
    await db.execute('''CREATE TABLE "company" (
                        "id"	INTEGER,
                        "name"	TEXT,
                        "note"	TEXT,
                        "date"	TEXT,
                        PRIMARY KEY("id" AUTOINCREMENT)
                          );
                          
                          CREATE TABLE "worker" (
                            "id"	INTEGER,
                            "name"	TEXT,
                            "phone"	TEXT,
                            "company"	INTEGER,
                            "drug"	TEXT,
                            "total" TEXT,
                            "out" TEXT,
                            "note" TEXT,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );
                          
                          CREATE TABLE "section" (
                            "id"	INTEGER,
                            "name"	TEXT,
                            "total"	REAL,
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );
                          CREATE TABLE "expense" (
                            "id"	INTEGER,
                            "reason"	TEXT,
                            "amount"	REAL,
                            "note"	TEXT,
                            "section" INTEGER ,
                            "date" TEXT , 
                            PRIMARY KEY("id" AUTOINCREMENT)
                          );
                          ''');
  }

  readData(String Sql ,List<dynamic> list ) async {
    Database db = await database;
    return await db.rawQuery(Sql,list);
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
}
