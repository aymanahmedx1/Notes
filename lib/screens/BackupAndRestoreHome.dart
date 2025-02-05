import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomWidgets/Spacers.dart';
import '../Providers/BackupRestoreProvider.dart';

class BackupAndRestoreHome extends StatelessWidget {
  static const String rout = "BackupAndRestoreHome";

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(height: 50,),
                      CircularProgressIndicator()
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await value.makeBackup();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              width: 200,
                              height: 200,
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
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              await value.restoreBackup();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.deepOrange,
                              width: 200,
                              height: 200,
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
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
    ));
  }
}
