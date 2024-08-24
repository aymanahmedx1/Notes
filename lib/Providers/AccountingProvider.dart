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

  void showAddExpenseDialog(
      BuildContext context, SectionModel section, ExpenseType type) async {
    await AccountingDialog().addExpenseOnSection(context, section, type);
    fillAccountingList();
  }

  void filterExpenseList(String dateFrom, String dateTo, String? text) {
    filteredExpenseList = [];
    filteredExpenseList = expenseList.where((element) {
      var from = DateTime.parse(dateFrom);
      var to = DateTime.parse(dateTo);
      var elementDate = DateTime.parse(element.date);
      return (elementDate.compareTo(from) != -1 &&
              elementDate.compareTo(to) != 1) &&
          element.reason.contains(text ?? "");
    }).toList();
    //ff
    notifyListeners();
  }

  void addNewExpense(
      ExpenseModel ex, SectionModel section, double amount, bool isPlus) async {
    await SectionDB().addExpense(ex);
    await SectionDB().updateAmount(section, ex.amount, ex.expenseType);
    fillAccountingList();
  }

  void filterAccounts(String? value) {
    filteredAccountingList = [];
    filteredAccountingList = _accountingList
        .where((element) => element.name.contains(value ?? ""))
        .toList();
    notifyListeners();
  }
}
