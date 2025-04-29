import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../CustomWidgets/Spacers.dart';
import '../Providers/BackupRestoreProvider.dart';

class BackupAndRestoreHome extends StatelessWidget {
  static const String rout = "BackupAndRestoreHome";

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("النسخ الاحتياطي والاستعادة"),
          ),
          body: Consumer<BackupRestoreProvider>(
            builder: (context, value, child) {
              return value.loading
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("يرجي الانتظار"),
                    SizedBox(height: 50),
                    CircularProgressIndicator()
                  ],
                ),
              )
                  : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Use column for small screens, row for larger screens
                    isSmallScreen
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildBackupButton(value, context, screenSize),
                        const SizedBox(height: 10),
                        _buildRestoreButton(value, context, screenSize),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildBackupButton(value, context, screenSize),
                        const SizedBox(width: 10),
                        _buildRestoreButton(value, context, screenSize),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  // Widget for backup button
  Widget _buildBackupButton(BackupRestoreProvider value, BuildContext context, Size screenSize) {
    // Calculate responsive size (smaller on small screens, max size on larger screens)
    final buttonSize = screenSize.width < 600
        ? screenSize.width * 0.4
        : screenSize.width * 0.3 > 200 ? 200.0 : screenSize.width * 0.3;

    return InkWell(
      onTap: () async {
        await value.makeBackup(context);
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.green,
        width: buttonSize,
        height: buttonSize,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "نسخ احتياطي",
              style: TextStyle(color: Colors.white),
            ),
            widthSpace,
            Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  // Widget for restore button
  Widget _buildRestoreButton(BackupRestoreProvider value, BuildContext context, Size screenSize) {
    // Calculate responsive size (smaller on small screens, max size on larger screens)
    final buttonSize = screenSize.width < 600
        ? screenSize.width * 0.4
        : screenSize.width * 0.3 > 200 ? 200.0 : screenSize.width * 0.3;

    return InkWell(
      onTap: () async {
        await value.restoreBackupFromFile(context);
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.deepOrange,
        width: buttonSize,
        height: buttonSize,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "استعادة",
              style: TextStyle(color: Colors.white),
            ),
            widthSpace,
            Icon(
              Icons.edit_calendar,
              size: 30,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}