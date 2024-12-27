import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/SectionModel.dart';
import '../data/SectionDB.dart';

class MoneyTransactionProvider with ChangeNotifier {
  List<SectionModel> _accountingList = [];
  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> filteredExpenseList = [];
  ExpenseType selectedSection = ExpenseType.all;
  double totalOut = 0;
  double totalIn = 0;


  void changeCheckbox(ExpenseType selected) {
    selectedSection = selected;
    notifyListeners();
  }

  fillList() async {
    selectedSection =   ExpenseType.all;
    filteredExpenseList = [];
    _accountingList = await SectionDB().getAllSections();
    expenseList = await SectionDB().getAllSectionDetails();
    totalOut = 0.00;
    totalIn = 0.00;
    for (var i in expenseList) {
      i.sectionModel = getSectionModel(i.section);
      filteredExpenseList.add(i);
      if (i.expenseType == ExpenseType.moneyIn) {
        totalIn += i.amount;
      } else {
        totalOut += i.amount;
      }
    }
    notifyListeners();
  }

  SectionModel? getSectionModel(int section) {
    return _accountingList.firstWhere(
      (element) => element.id == section,
    );
  }

  void filter(String dateFrom, String dateTo, String text) {
    filteredExpenseList = [];
    filteredExpenseList = expenseList.where((element) {
      var from = DateTime.parse(dateFrom);
      var to = DateTime.parse(dateTo);
      var elementDate = DateTime.parse(element.date);
      return (elementDate.compareTo(from) != -1 &&
              elementDate.compareTo(to) != 1) &&
          element.sectionModel!.name.contains(text) &&
          (selectedSection != ExpenseType.all
              ? element.expenseType == selectedSection
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
}
