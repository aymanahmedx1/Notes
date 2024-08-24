import 'dart:developer';

import 'package:notes/Models/SectionModel.dart';

import 'Database.dart';

class SectionDB {
  DatabaseHelper db = new DatabaseHelper();

  addSection(SectionModel model) async {
    await db.insertData(''' insert into section (name,total) values (?,?) ''',
        [model.name, model.total]);
  }

  updateSection(SectionModel model) async {
    await db.updateData(''' update section set name = ?  where id = ?  ''',
        [model.name, model.id]);
  }

  updateAmount(SectionModel model, double amount, bool isPlus) async {
    String op = isPlus ? "+" : "-";
    await db.updateData(
        " update section set total = total $op ?  where id = ?  ",
        [amount, model.id]);
  }

  Future<List<SectionModel>> getAllSections() async {
    List<Map> res = await db.readData('''  select * from  section''', []);
    List<SectionModel> list = [];
    for (var record in res) {
      list.add(SectionModel(
          id: record['id'], name: record['name'], total: record['total']));
    }
    return list;
  }

  addExpense(ExpenseModel ex) async {
    await db.insertData(
        ''' insert into expense (reason,amount,note , section ,date,expense_type) values (?,?,?,?,?,?) ''',
        [ex.reason, ex.amount, ex.note, ex.section , ex.date,ex.expenseType.index]);
  }

  getSectionDetails(SectionModel model) async {
    try {
      List<Map> res = await db.readData(
          '''  select * from  expense where  section = ?''', [model.id]);
      List<ExpenseModel> list = [];
      for (var record in res) {
        list.add(ExpenseModel(
          id: record['id'],
          reason: record['reason'],
          section: model.id,
          amount: record['amount'],
          note: record['note'],
          date: record['date'],
          expenseType: record['expense_type']
        ));
      }
      return list;
    } catch (e) {
      log("$e");
    }
  }
}
