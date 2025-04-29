import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Models/PrintDetailsModel.dart';
import 'package:pdf/pdf.dart';

import '../Commons/Helpers.dart';
import '../Helpers/save_and_open_files.dart';
import '../Models/SectionModel.dart';
import '../data/SectionDB.dart';
import 'package:pdf/widgets.dart' as pw;

class MoneyTransactionProvider extends ChangeNotifier {
  List<SectionModel> _accountingList = [];
  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> filteredExpenseList = [];
  ExpenseType selectedSection = ExpenseType.all;
  double totalOut = 0;
  double totalIn = 0;
  final fontSize = 12.00;
  final horizontalPadding = 5.00;

  void changeCheckbox(ExpenseType selected) {
    selectedSection = selected;
    notifyListeners();
  }

  fillList() async {
    selectedSection = ExpenseType.all;
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

  exportPdf(PrintDetailsModel model) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');

      // var fontData = File('/assets/font/Cairo-Regular.ttf').readAsBytesSync();
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      pdf.addPage(
        pw.Page(build: (pw.Context context) {
          final pageWidth = context.page.pageFormat.availableWidth;
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("حركة الاموال",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 16,
                            decoration: pw.TextDecoration.underline,
                            fontWeight: pw.FontWeight.bold,
                          ))
                    ]),
                pw.Row(children: [
                  pw.Text("التاريخ من  ${model.dateFrom}  الي  ${model.dateTo}",
                      style: pw.TextStyle(font: ttf, fontSize: fontSize))
                ]),
                pw.Row(children: [
                  pw.Text("المصروف ${model.totalOut}",
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  pw.SizedBox(width: 20),
                  pw.Text("المقبوض ${model.totalIn}",
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                ]),
                model.reasonFilter == ""
                    ? pw.SizedBox()
                    : pw.Row(children: [
                        pw.Text("السبب ${model.reasonFilter}",
                            style: pw.TextStyle(font: ttf, fontSize: fontSize))
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
                            child: pw.Text("التاريخ",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .2),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("القسم",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .4),
                        pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: pw.Text("مصروف",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .15),
                        pw.SizedBox(
                            child: pw.Text("مستلم",
                                style: pw.TextStyle(
                                    font: ttf, fontSize: fontSize)),
                            width: pageWidth * .15),
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
                  child: pw.Text(model.date,
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .2),
              pw.Container(
                  margin:
                      pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: pw.Text(model.sectionModel!.name,
                      style: pw.TextStyle(font: ttf, fontSize: fontSize)),
                  width: pageWidth * .4),
              pw.Container(
                  margin:
                      pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: pw.Text(formatNumber(
                      model.expenseType == ExpenseType.moneyOut
                          ? model.amount
                          : 0)),
                  width: pageWidth * .15),
              pw.SizedBox(
                width: pageWidth * .15,
                child: pw.Text(formatNumber(
                    model.expenseType == ExpenseType.moneyOut
                        ? 0
                        : model.amount)),
              )
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
}
