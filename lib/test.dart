import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

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
  final pw.Document pdf = pw.Document();

  PdfExampleScreen() {
    // Generate a simple PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello, PDF!'),
        ),
      ),
    );
  }

  Future<void> saveAndOpenPdf(String title, Uint8List pdfBytes) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$title.pdf';

      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Open the file
      print('Opening file at: $filePath');
      await OpenFilex.open(filePath);
    } catch (e) {
      print('Error saving or opening the file: $e');
    }
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
            final pdfBytes = await pdf.save(); // Save the PDF as bytes
            await saveAndOpenPdf('example_pdf', pdfBytes); // Save and open
          },
          child: Text('Generate and Open PDF'),
        ),
      ),
    );
  }
}
