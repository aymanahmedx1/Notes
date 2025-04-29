import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save and Open PDF Example',
      home: PdfExampleScreen(),
    );
  }
}

class PdfExampleScreen extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
              await requestStoragePermission();
          },
          child: Text('Generate and Open PDF'),
        ),
      ),
    );
  }







}





