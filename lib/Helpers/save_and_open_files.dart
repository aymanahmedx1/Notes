import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveAndOpenPdf(String title, Uint8List pdfBytes) async {
  try {
    // Get the application's document directory
    final directory = await getApplicationDocumentsDirectory();

    // Define the full file path
    final filePath = '${directory.path}/$title.pdf';

    // Write the file
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Open the file
    await OpenFilex.open(filePath);
  } catch (e) {
    print('Error saving or opening the file: $e');
  }
}



Future<bool> requestStoragePermission() async {
  final status = await Permission.storage.request();
  return status.isGranted;
}