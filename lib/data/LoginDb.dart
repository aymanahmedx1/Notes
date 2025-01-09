import 'dart:developer';

import 'Database.dart';

class LoginDb {
  DatabaseHelper db = DatabaseHelper();

  updatePassword(String newPassword) async {
    await db.updateData(
        ''' update user_password set user_pass = ?    ''', [newPassword]);
  }

  addPassword(String newPassword) async {
    await db.insertData(
        ''' insert into user_password (user_pass) values (?) ''',
        [newPassword]);
  }

  getPassword() async {
    try {
      List<Map> res =
          await db.readData('''select user_pass from user_password ''', []);
      String pass = "123456";
      for (var record in res) {
        pass = record['user_pass'];
      }
      if (res.isEmpty) {
        await LoginDb().addPassword("123456");
        pass = "123456";
      }
      return pass;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
