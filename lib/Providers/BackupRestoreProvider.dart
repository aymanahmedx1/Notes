import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../data/Database.dart';


var data ='''
{"worker":[{"id":4,"name":"شسيشسيشسي","phone":"13545666","company":1,"drug":"شسيشسيشسي","total":100,"out":100,"note":"","date":"2025-02-05","expDate":"2025-02-18","finish":0,"price":300.0}],"company":[{"id":1,"name":"فغ","note":"","date":"2025-01-14"}],"movements":[{"id":1,"workerId":3,"qty":500,"date":"2025-02-05"},{"id":2,"workerId":2,"qty":33,"date":"2025-02-05"}],"expense":[],"section":[],"personal_expense":[],"personal":[],"user_password":[{"id":1,"user_pass":"123456"}]}
''';

class BackupRestoreProvider with ChangeNotifier {
  bool loading = false;

  makeBackup() async {
    loading = true ;
    notifyListeners();
    var dataToBackup = await DatabaseHelper().getDatabaseBackup();
    await Future.delayed(Duration(seconds: 5));

    log(dataToBackup);
    loading = false ;
    notifyListeners();

    // await DatabaseHelper().restoreDatabaseFromBackup(data);
    // var data =
  }


  restoreBackup()async{
    loading = true ;
    notifyListeners();
    await DatabaseHelper().restoreDatabaseFromBackup(data);
    await Future.delayed(Duration(seconds: 5));

    loading = false ;
    notifyListeners();


  }
}
