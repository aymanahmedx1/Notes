import 'dart:developer';

import 'package:notes/Models/SectionModel.dart';

import 'Database.dart';

class PersonalAccountingDB {
  DatabaseHelper db = new DatabaseHelper();
  static String additionOP = " + ";
  static String subOp = " - ";

  addSection(SectionModel model) async {
    await db.insertData(
        ''' insert into personal (name,totalIn,totalOut) values (?,?,?) ''',
        [model.name, model.totalIn, model.totalOut]);
  }

  updateSection(SectionModel model) async {
    await db.updateData(''' update personal set name = ?  where id = ?  ''',
        [model.name, model.id]);
  }

  updateAmount(
      SectionModel model, double amount, ExpenseType type, String op) async {
    String colName = type == ExpenseType.moneyIn ? "totalIn" : "totalOut";
    await db.updateData(
        " update personal set $colName = $colName $op ?  where id = ?  ",
        [amount, model.id]);
  }

  updateAmountWhenUpdateExpense() {}

  Future<List<SectionModel>> getAllSections() async {
    List<Map> res = await db.readData('''  select * from  personal''', []);
    List<SectionModel> list = [];
    for (var record in res) {
      list.add(SectionModel(
        id: record['id'],
        name: record['name'],
        totalIn: record['totalIn'],
        totalOut: record['totalOut'],
      ));
    }
    return list;
  }

  addExpense(ExpenseModel ex) async {
    await db.insertData(
        ''' insert into personal_expense (reason,amount,note , section ,date,expense_type) values (?,?,?,?,?,?) ''',
        [
          ex.reason,
          ex.amount,
          ex.note,
          ex.section,
          ex.date,
          ex.expenseType.index
        ]);
  }

  deleteExpense(ExpenseModel ex) async {
    SectionModel m =
        SectionModel(id: ex.section, name: "name", totalIn: 0, totalOut: 0);
    await updateAmount(m, ex.amount, ex.expenseType, "-");
    await db
        .insertData(''' DELETE FROM personal_expense WHERE id = ? ''', [ex.id]);
  }

  getSectionDetails(SectionModel model) async {
    try {
      List<Map> res = await db.readData(
          '''  select * from  personal_expense where  section = ?''',
          [model.id]);
      List<ExpenseModel> list = [];
      for (var record in res) {
        list.add(ExpenseModel(
          id: record['id'],
          reason: record['reason'],
          section: model.id,
          amount: record['amount'],
          note: record['note'],
          date: record['date'],
          expenseType: ExpenseType.values[record['expense_type']],
        ));
      }
      return list;
    } catch (e) {
      log("$e");
    }
  }

  getAllSectionDetails() async {
    try {
      List<Map> res =
          await db.readData('''  select * from  personal_expense ''', []);
      List<ExpenseModel> list = [];
      for (var record in res) {
        list.add(ExpenseModel(
          id: record['id'],
          reason: record['reason'],
          section: record['section'],
          amount: record['amount'],
          note: record['note'],
          date: record['date'],
          expenseType: ExpenseType.values[record['expense_type']],
        ));
      }
      return list;
    } catch (e) {
      log("$e");
    }
  }

  updateExpense(ExpenseModel ex) async {
    await db.updateData(
        ''' update personal_expense set reason=?,amount=?,note =? where id = ? ''',
        [ex.reason, ex.amount, ex.note, ex.id]);
  }

  Future<double> getExpenseAmount(int id) async {
    List<Map> res = await db.readData(
        '''  select amount from  personal_expense where id = ? ''', [id]);
    for (var record in res) {
      return record['amount'];
    }
    return 0;
  }

  Future<Set<String>> getExpenseReasonListForSuggest(
      ExpenseType expenseType) async {
    List<Map> res = await db.readData(
        '''  select reason from  personal_expense where  expense_type = ?''',
        [expenseType.index]);
    List<String> list = [];
    for (var record in res) {
      list.add(record['reason']);
    }
    return list.toSet();
  }

  deleteSectionWithExpenses(SectionModel model) async {
    var r = await db.deleteData(
        ''' DELETE FROM personal_expense WHERE section = ? ''', [model.id]);
    log(r.toString());
    var s = await db
        .deleteData(''' DELETE FROM personal WHERE id = ? ''', [model.id]);
  }
}
