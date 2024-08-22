import 'package:flutter/material.dart';
import 'package:notes/AppStart.dart';
import 'package:notes/data/Database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(){
  sqfliteFfiInit();
  sqfliteFfiInit();
  databaseFactoryOrNull = databaseFactoryFfi;
  DatabaseHelper().delete();
  runApp(Appstart());
}