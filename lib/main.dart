import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes/AppStart.dart';
import 'package:notes/Providers/AccountingProvider.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/data/Database.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().delete();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CompanyProvider>(
      create: (_) => CompanyProvider(),
      lazy: true,
    ),
    ChangeNotifierProvider<AccountingProvider>(
      create: (_) => AccountingProvider(),
      lazy: true,
    ),
  ], child: Appstart()));
}
