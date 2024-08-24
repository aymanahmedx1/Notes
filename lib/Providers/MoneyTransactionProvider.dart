import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/SectionModel.dart';
import '../data/SectionDB.dart';

class MoneyTransactionProvider with ChangeNotifier {
  List<SectionModel> _accountingList = [];
  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> filteredExpenseList = [];

  fillList() async {
    filteredExpenseList = [] ;
    _accountingList = await SectionDB().getAllSections();
    expenseList = await SectionDB().getAllSectionDetails();
    for (var i in expenseList) {
      i.sectionModel = getSectionModel(i.section);
      filteredExpenseList.add(i);
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
          element.sectionModel!.name.contains(text);
    }).toList();
    log(text);
    log(dateTo);
    log(dateFrom);
    notifyListeners();
  }
}
