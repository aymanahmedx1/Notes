import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/AppStart.dart';
import 'package:notes/data/Database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main()async{
  if(Platform.isWindows){
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  //DatabaseHelper().delete();
  runApp(Appstart());
}