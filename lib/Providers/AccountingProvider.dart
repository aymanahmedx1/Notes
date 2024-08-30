import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/SectionModel.dart';
import '../data/SectionDB.dart';
import '../screens/Accounting/Widgets/Dialogs.dart';

class AccountingProvider with ChangeNotifier {
  List<SectionModel> _accountingList = [];
  List<SectionModel> filteredAccountingList = [];
  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> filteredExpenseList = [];

  double totalOut = 0;
  double totalIn = 0;
  ExpenseType selectedSection = ExpenseType.all;

  AccountingProvider() {
    fillAccountingList();
  }

  fillAccountingList() async {
    _accountingList = await SectionDB().getAllSections();
    filteredAccountingList = List<SectionModel>.from(_accountingList);
    notifyListeners();
  }

  fillExpenseList(SectionModel section) async {
    expenseList = await SectionDB().getSectionDetails(section);
    filteredExpenseList = List<ExpenseModel>.from(expenseList);
    totalOut = 0.00;
    totalIn = 0.00;
    for (var i in filteredExpenseList) {
      if (i.expenseType == ExpenseType.moneyIn) {
        totalIn += i.amount;
      } else {
        totalOut += i.amount;
      }
    }
    notifyListeners();
  }

  void addSection(SectionModel section) async {
    await SectionDB().addSection(section);
    fillAccountingList();
  }

  void updateSection(SectionModel model) async {
    await SectionDB().updateSection(model);
    fillAccountingList();
  }

  void showAddExpenseDialog(BuildContext context, SectionModel section,
      ExpenseType type, ExpenseModel? expenseModel) async {
    await AccountingDialog()
        .addExpenseOnSection(context, section, type, expenseModel);
    fillAccountingList();
  }

  void filterExpenseList(
      String dateFrom, String dateTo, String? text, ExpenseType type) {
    filteredExpenseList = [];
    filteredExpenseList = expenseList.where((element) {
      var from = DateTime.parse(dateFrom);
      var to = DateTime.parse(dateTo);
      var elementDate = DateTime.parse(element.date);
      return (elementDate.compareTo(from) != -1 &&
              elementDate.compareTo(to) != 1) &&
          element.reason.contains(text ?? "") &&
          (type != ExpenseType.all
              ? element.expenseType == type
              : element.expenseType.index != 9);
    }).toList();
    totalOut = 0.00;
    totalIn = 0.00;
    for (var i in filteredExpenseList) {
      if (i.expenseType == ExpenseType.moneyIn) {
        totalIn += i.amount;
      } else {
        totalOut += i.amount;
      }
    }
    notifyListeners();
  }

  void addNewExpense(
      ExpenseModel ex, SectionModel section, double amount, bool isPlus) async {
    await SectionDB().addExpense(ex);
    await SectionDB()
        .updateAmount(section, ex.amount, ex.expenseType, SectionDB.additionOP);
    fillAccountingList();
  }

  void filterAccounts(String? value) {
    filteredAccountingList = [];
    filteredAccountingList = _accountingList
        .where((element) => element.name.contains(value ?? ""))
        .toList();
    notifyListeners();
  }

  void updateExpense(
      ExpenseModel ex, SectionModel section, double amount, bool bool) async {
    double oldValue = await SectionDB().getExpenseAmount(ex.id);
    await SectionDB()
        .updateAmount(section, oldValue, ex.expenseType, SectionDB.subOp);
    await SectionDB().updateExpense(ex);
    await SectionDB()
        .updateAmount(section, ex.amount, ex.expenseType, SectionDB.additionOP);
    fillExpenseList(section);
    fillAccountingList();
  }

  void changeCheckbox(ExpenseType selected) {
    selectedSection = selected;
    notifyListeners();
  }
}
