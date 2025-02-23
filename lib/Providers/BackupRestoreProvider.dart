import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:restart_app/restart_app.dart';
import '../data/Database.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class BackupRestoreProvider with ChangeNotifier {
  bool loading = false;

  makeBackup() async {
    loading = true;
    notifyListeners();
    var dataToBackup = await DatabaseHelper().getDatabaseBackup();
    await saveBackupToFile(dataToBackup);
    loading = false;
    notifyListeners();

    // await DatabaseHelper().restoreDatabaseFromBackup(data);
    // var data =
  }

  restoreBackup(data) async {
    loading = true;
    notifyListeners();
    await DatabaseHelper().restoreDatabaseFromBackup(data);
    loading = false;
    notifyListeners();

  }

  Future<void> saveBackupToFile(String jsonBackup) async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get directory to save file

      String downloadsPath = '/storage/emulated/0/Download';
      // Create the file path
      String filePath = '$downloadsPath/database_backup.json';
      // Save JSON string to file
      File file = File(filePath);
      await file.writeAsString(jsonBackup);
      print('Backup saved at: $filePath');
    } else {
      print('Storage permission denied.');
    }
  }





  Future<void> restoreBackupFromFile() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Let user pick the file (handles permission issues and SAF automatically)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        File backupFile = File(filePath);

        try {
          String jsonBackup = await backupFile.readAsString();
          await restoreBackup(jsonBackup);
          // 🚀 Restart the app after successful restore
          Restart.restartApp();
        } catch (e) {
          print('❌ Error restoring backup: $e');
        }
      } else {
        print('❌ No file selected.');
      }
    } else {
      print('❌ Storage permission denied.');
    }
  }

}
