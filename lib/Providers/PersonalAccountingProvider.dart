import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import '../Commons/Helpers.dart';
import '../Helpers/save_and_open_files.dart';
import '../Models/PersonalPrintDetailsModel.dart';
import '../Models/PrintDetailsModel.dart';
import '../Models/SectionModel.dart';
import '../data/PersonalAccountingDb.dart';
import '../data/SectionDB.dart';
import '../screens/Accounting/Widgets/Dialogs.dart';
import '../screens/PersonalAccounting/Widgets/Dialogs.dart';

class PersonalAccountingProvider with ChangeNotifier {
  List<SectionModel> _accountingList = [];
  List<SectionModel> filteredAccountingList = [];
  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> filteredExpenseList = [];

  double totalOut = 0;
  double totalIn = 0;
  ExpenseType selectedSection = ExpenseType.all;
  final fontSize = 12.00;

  final horizontalPadding = 5.00;

  PersonalAccountingProvider() {
    fillAccountingList();
  }

  fillAccountingList() async {
    _accountingList = await PersonalAccountingDB().getAllSections();
    filteredAccountingList = List<SectionModel>.from(_accountingList);
    notifyListeners();
  }

  fillExpenseList(SectionModel section) async {
    expenseList = await PersonalAccountingDB().getSectionDetails(section);
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
    await PersonalAccountingDB().addSection(section);
    fillAccountingList();
  }

  void updateSection(SectionModel model) async {
    await PersonalAccountingDB().updateSection(model);
    fillAccountingList();
  }

  void showAddExpenseDialog(BuildContext context, SectionModel section,
      ExpenseType type, ExpenseModel? expenseModel) async {  ////
    await PersonalAccountingDialog()
        .addExpenseOnPersonalSection(context, section, type, expenseModel);
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
    await PersonalAccountingDB().addExpense(ex);
    await PersonalAccountingDB()
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
    double oldValue = await PersonalAccountingDB().getExpenseAmount(ex.id);
    await PersonalAccountingDB()
        .updateAmount(section, oldValue, ex.expenseType, SectionDB.subOp);
    await PersonalAccountingDB().updateExpense(ex);
    await PersonalAccountingDB()
        .updateAmount(section, ex.amount, ex.expenseType, SectionDB.additionOP);
    fillExpenseList(section);
    fillAccountingList();
  }

  void changeCheckbox(ExpenseType selected) {
    selectedSection = selected;
    notifyListeners();
  }

  exportPersonalPdf(PersonalPrintDetailsModel model) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      pdf.addPage(
        pw.Page(build: (pw.Context context) {
          final pageWidth = context.page.pageFormat.availableWidth;
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.Row(children: [
                  pw.Text("التاريخ من  ${model.dateFrom}  الي  ${model.dateTo}",
                      style: pw.TextStyle(font: ttf, fontSize: 16))
                ]),
                pw.Row(children: [
                  pw.Text("السبب ${model.reasonFilter}",
                      style: pw.TextStyle(font: ttf, fontSize: 16))
                ]),
                pw.Row(children: [
                  pw.Text("المصروف ${model.totalOut}",
                      style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.SizedBox(width: 20),
                  pw.Text("المقبوض ${model.totalIn}",
                      style: pw.TextStyle(font: ttf, fontSize: 16)),
                ]),
                pw.Container(
                  color: const PdfColor.fromInt(0xFF878787),
                  child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.SizedBox(
                          width: pageWidth * .1,
                          child: pw.Text("م",
                              style:
                              pw.TextStyle(font: ttf, fontSize: fontSize)),
                        ),
                        pw.SizedBox(
                            child: pw.Text("السبب",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .3),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("المصروف",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .1),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("المستلم",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .1),
                        pw.SizedBox(
                            child: pw.Text("التاريخ",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .2),
                        pw.SizedBox(
                            child: pw.Text("ملاحظات",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .2),
                      ]),
                ),
                pw.ListView.separated(
                    separatorBuilder: (context, int index) {
                      return pw.Divider();
                    },
                    itemBuilder: (context, int index) {
                      return makePdfFileRow(
                          index, model.data.filter[index], ttf, pageWidth);
                    },
                    itemCount: model.data.filter.length)
              ],
            ),
          );
        }),
      );
      final pdfBytes = await pdf.save(); // Save the PDF as bytes
      await saveAndOpenPdf('example_pdf', pdfBytes); // Save and open

    } catch (e) {
      log(e.toString());
    }
  }
  exportPdf(PrintDetailsModel model) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');

      //var fontData = File('/assets/font/Cairo-Regular.ttf').readAsBytesSync();
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      pdf.addPage(
        pw.Page(build: (pw.Context context) {
          final pageWidth = context.page.pageFormat.availableWidth;
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.Row(children: [
                  pw.Text("التاريخ من  ${model.dateFrom}  الي  ${model.dateTo}",
                      style: pw.TextStyle(font: ttf, fontSize: 16))
                ]),
                pw.Row(children: [
                  pw.Text("السبب ${model.reasonFilter}",
                      style: pw.TextStyle(font: ttf, fontSize: 16))
                ]),
                pw.Row(children: [
                  pw.Text("المصروف ${model.totalOut}",
                      style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.SizedBox(width: 20),
                  pw.Text("المقبوض ${model.totalIn}",
                      style: pw.TextStyle(font: ttf, fontSize: 16)),
                ]),
                pw.Container(
                  color: const PdfColor.fromInt(0xFF878787),
                  child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.SizedBox(
                          width: pageWidth * .1,
                          child: pw.Text("م",
                              style:
                              pw.TextStyle(font: ttf, fontSize: fontSize)),
                        ),
                        pw.SizedBox(
                            child: pw.Text("السبب",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .3),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("المصروف",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .1),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("المستلم",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .1),
                        pw.SizedBox(
                            child: pw.Text("التاريخ",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .2),
                        pw.SizedBox(
                            child: pw.Text("ملاحظات",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .2),
                      ]),
                ),
                pw.ListView.separated(
                    separatorBuilder: (context, int index) {
                      return pw.Divider();
                    },
                    itemBuilder: (context, int index) {
                      return makePdfFileRow(
                          index, model.data.filter[index], ttf, pageWidth);
                    },
                    itemCount: model.data.filter.length)
              ],
            ),
          );
        }),
      );

      final file = File('ttoottoo.pdf');
      File f = await file.writeAsBytes(await pdf.save());
      OpenFilex.open(f.path);
    } catch (e) {
      log(e.toString());
    }
  }

  makePdfFileRow(int index, ExpenseModel model, pw.Font ttf, double pageWidth) {
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.SizedBox(
                width: pageWidth * .1,
                child: pw.Text("${index + 1}"),
              ),
              pw.SizedBox(
                  child: pw.Text(model.reason,
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .3),
              pw.Container(
                  margin:
                  pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: pw.Text(
                      model.expenseType == ExpenseType.moneyOut
                          ? "${formatNumber(model.amount)}"
                          : "0",
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .1),
              pw.Container(
                  margin:
                  pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: pw.Text(
                      model.expenseType == ExpenseType.moneyIn
                          ? "${formatNumber(model.amount)}"
                          : "0",
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .1),
              pw.SizedBox(
                  child: pw.Text(model.date,
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .2),
              pw.SizedBox(
                  child: pw.Text(model.note,
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .2),
            ]));
  }

  buildTableForPdf(PrintDetailsModel model) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return makeRow(
              index,
              model.data.filter[index],
              context,
              33,
              new SectionModel(
                  id: 0, name: "name", totalIn: totalIn, totalOut: totalOut));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: model.data.filter.length);
  }

  makeRow(int index, ExpenseModel expense, BuildContext context, double colSize,
      SectionModel section) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        makeChild("${index + 1}", colSize * .5),
        makeChild(expense.reason, colSize * 3),
        makeChild(
            expense.expenseType == ExpenseType.moneyOut
                ? "${formatNumber(expense.amount)}"
                : "0",
            colSize * 2),
        makeChild(
            expense.expenseType == ExpenseType.moneyIn
                ? "${formatNumber(expense.amount)}"
                : "0",
            colSize * 2),
        makeChild(expense.date, colSize * 2),
        makeChild(expense.note, colSize * 2),
      ],
    );
  }

  makeChild(String data, double width) {
    return SizedBox(
      width: width,
      child: Text(
        data,
        textAlign: TextAlign.center,
      ),
    );
  }


  deleteSection(SectionModel model) async {
    await PersonalAccountingDB().deleteSectionWithExpenses(model);
    await fillAccountingList();
  }
}
