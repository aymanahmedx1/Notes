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

  makeBackup(BuildContext context) async {
    loading = true;
    notifyListeners();
    var dataToBackup = await DatabaseHelper().getDatabaseBackup();
    await saveBackupToFile(dataToBackup, context);
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


  Future<void> saveBackupToFile(String jsonBackup, BuildContext context) async {
    try {
      // Request storage permission (For Android 9 and below)
      if (await requestStoragePermission()) {
        // Ask user to select a directory
        String? selectedPath = await FilePicker.platform.getDirectoryPath();

        if (selectedPath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لم يتم تحديد مسار.')),
          );
          return;
        }

        // 🔹 Use the correct method to write the file safely
        File file = File('$selectedPath/database_backup.json');
        await file.create(recursive: true);
        // Check if the path is accessible
        if (await file.exists()) {
          await file.writeAsString(jsonBackup);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم الحفظ في : $selectedPath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("لا يمكن الحفظ في هذا المكان.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('صلاحية الملفات غير مفعله.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا : ${e.toString()}')),
      );
      print("خطا في الحفظ: $e");
    }
  }


  Future<void> restoreBackupFromFile(BuildContext context) async {
    // Request storage permission
    if (await requestStoragePermission()) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error restoring backup: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ No file selected.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Storage permission denied.')),
      );
    }
  }

  Future<bool> requestStoragePermission() async {

    if (Platform.isAndroid) {
      var x = await Permission.manageExternalStorage.request() ;
      log(x.isGranted.toString());
      log(x.isDenied.toString());
      log(x.isLimited.toString());
      log(x.isPermanentlyDenied.toString());
      log(x.isProvisional.toString());
      log(x.isRestricted.toString());
      if (x.isGranted) {
        return true;
      } else if (await Permission.manageExternalStorage.request().isPermanentlyDenied) {
        openAppSettings();
        return false;
      } else {
        return false;

      }
    }
    return true; // No permission needed for iOS
  }
}
