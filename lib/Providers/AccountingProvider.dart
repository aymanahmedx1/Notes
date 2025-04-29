import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import '../Commons/Helpers.dart';
import '../Helpers/save_and_open_files.dart';
import '../Models/PersonalPrintDetailsModel.dart';
import '../Models/PrintDetailsModel.dart';
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
  final fontSize = 12.00;

  final horizontalPadding = 5.00;

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

  void showAddExpenseDialog(
    BuildContext context,
    SectionModel section,
    ExpenseType type,
    ExpenseModel? expenseModel,
  ) async {
    await AccountingDialog().addExpenseOnSection(
      context,
      section,
      type,
      expenseModel,
    );
    fillAccountingList();
  }

  void filterExpenseList(
    String dateFrom,
    String dateTo,
    String? text,
    ExpenseType type,
  ) {
    filteredExpenseList = [];
    filteredExpenseList =
        expenseList.where((element) {
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
    ExpenseModel ex,
    SectionModel section,
    double amount,
    bool isPlus,
  ) async {
    await SectionDB().addExpense(ex);
    await SectionDB().updateAmount(
      section,
      ex.amount,
      ex.expenseType,
      SectionDB.additionOP,
    );
    fillAccountingList();
  }

  void filterAccounts(String? value) {
    filteredAccountingList = [];
    filteredAccountingList =
        _accountingList
            .where((element) => element.name.contains(value ?? ""))
            .toList();
    notifyListeners();
  }

  void updateExpense(
    ExpenseModel ex,
    SectionModel section,
    double amount,
    bool bool,
  ) async {
    double oldValue = await SectionDB().getExpenseAmount(ex.id);
    await SectionDB().updateAmount(
      section,
      oldValue,
      ex.expenseType,
      SectionDB.subOp,
    );
    await SectionDB().updateExpense(ex);
    await SectionDB().updateAmount(
      section,
      ex.amount,
      ex.expenseType,
      SectionDB.additionOP,
    );
    fillExpenseList(section);
    fillAccountingList();
  }

  void changeCheckbox(ExpenseType selected) {
    selectedSection = selected;
    notifyListeners();
  }

  exportPdf(PrintDetailsModel model) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');

      // var fontData = File('/assets/font/Cairo-Regular.ttf').readAsBytesSync();
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            final pageWidth = context.page.pageFormat.availableWidth;
            final pageHeight = context.page.pageFormat.availableHeight;

            // Calculate responsive sizes based on page dimensions
            final headerFontSize = pageWidth * 0.04;
            final normalFontSize = pageWidth * 0.03;
            final smallFontSize = pageWidth * 0.025;


            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Container(
                    alignment : pw.Alignment.center ,
                    margin: pw.EdgeInsets.only(bottom: pageHeight * 0.02),

                    child:
                      pw.Text(
                        model.title,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: headerFontSize,

                          //       decoration: pw.TextDecoration.underline,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                  ),
                  pw.Container(
                    margin: pw.EdgeInsets.only(bottom: pageHeight * 0.01),
                    child:
                      pw.Text(
                        "التاريخ من   ${model.dateFrom}        الى   ${model.dateTo}",
                        style: pw.TextStyle(font: ttf, fontSize: normalFontSize),
                      ),

                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Text(
                        "المصروف  ${_formatNumberWithCommas(model.totalOut)}",
                        style: pw.TextStyle(font: ttf, fontSize: normalFontSize),
                      ),
                      pw.SizedBox(width: pageWidth * 0.05),
                      pw.Text(
                        "المستلم  ${_formatNumberWithCommas(model.totalIn)}",
                        style: pw.TextStyle(font: ttf, fontSize: normalFontSize),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: pageHeight * 0.015),
                  model.reasonFilter == ""
                      ? pw.SizedBox()
                      : pw.Container(
                    margin: pw.EdgeInsets.only(bottom: pageHeight * 0.01),
                        child:
                          pw.Text(
                            "السبب ${model.reasonFilter}",
                            style: pw.TextStyle(font: ttf, fontSize: normalFontSize),
                          ),

                      ),
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(vertical: pageHeight * 0.01),
                    color: const PdfColor.fromInt(0xFF878787),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [

                        _buildTableHeaderCell("ت", ttf, normalFontSize, pageWidth * 0.08),
                        _buildTableHeaderCell("السبب", ttf, normalFontSize, pageWidth * 0.30),
                        _buildTableHeaderCell("المصروف", ttf, normalFontSize, pageWidth * 0.15),
                        _buildTableHeaderCell("المستلم", ttf, normalFontSize, pageWidth * 0.15),
                        _buildTableHeaderCell("التاريخ", ttf, normalFontSize, pageWidth * 0.17),
                        _buildTableHeaderCell("ملاحظات", ttf, normalFontSize, pageWidth * 0.15),



                      ],
                    ),
                  ),

                  // Table content
                  pw.Expanded(
                    child: pw.ListView.builder(
                      itemCount: model.data.filter.length,
                      itemBuilder: (context, index) {
                        final item = model.data.filter[index];
                        final bgColor = index % 2 == 0
                            ? PdfColor.fromInt(0xFFF5F5F5)
                            : PdfColor.fromInt(0xFFFFFFFF);

                        return pw.Container(
                          color: bgColor,
                          padding: pw.EdgeInsets.symmetric(vertical: pageHeight * 0.008),
                          child: pw.Row(
                            children: [
                              _buildTableCell("${index + 1}", ttf, smallFontSize, pageWidth * 0.08),
                              _buildTableCell(item.reason, ttf, smallFontSize, pageWidth * 0.30),
                              _buildTableCell(
                                  item.expenseType == ExpenseType.moneyOut
                                      ? _formatNumberWithCommas(item.amount)
                                      : "0",
                                  ttf, smallFontSize, pageWidth * 0.15),
                              _buildTableCell(
                                  item.expenseType == ExpenseType.moneyIn
                                      ? _formatNumberWithCommas(item.amount)
                                      : "0",
                                  ttf, smallFontSize, pageWidth * 0.15),
                              _buildTableCell(item.date, ttf, smallFontSize, pageWidth * 0.17),
                              _buildTableCell(item.note, ttf, smallFontSize, pageWidth * 0.15),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Footer
                  pw.Container(
                    margin: pw.EdgeInsets.only(top: pageHeight * 0.02),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      "الصفحة ${context.pageNumber}",
                      style: pw.TextStyle(font: ttf, fontSize: smallFontSize),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      await saveAndOpenPdf('Accounting_pdf', pdfBytes);
    } catch (e) {
      log(e.toString());
    }
  }
















  // Helper method to build header cells with consistent styling
  pw.Widget _buildTableHeaderCell(String text, pw.Font font, double fontSize, double width) {
    return pw.Container(
      width: width,
      alignment: pw.Alignment.center,
      padding: pw.EdgeInsets.symmetric(horizontal: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

// Helper method to build table cells with consistent styling
  pw.Widget _buildTableCell(String text, pw.Font font, double fontSize, double width) {
    return pw.Container(
      width: width,
      alignment: pw.Alignment.center,
      padding: pw.EdgeInsets.symmetric(horizontal: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: fontSize),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

// Helper method to format numbers with commas and no decimal places
  String _formatNumberWithCommas(dynamic value) {
    // Convert input to double, regardless of whether it's int or double
    double numberValue;
    if (value is int) {
      numberValue = value.toDouble();
    } else if (value is double) {
      numberValue = value;
    } else {
      // If it's a string or another type, try to parse it as double
      try {
        numberValue = double.parse(value.toString());
      } catch (e) {
        return value.toString(); // Return as is if parsing fails
      }
    }

    // Check if the number is a whole number
    bool isWholeNumber = numberValue == numberValue.roundToDouble();

    // If it's a whole number, convert to int to remove decimal part completely
    String valueStr = isWholeNumber
        ? numberValue.round().toString()
        : numberValue.toString();

    // Split number into integer and decimal parts
    List<String> parts = valueStr.split('.');
    String integerPart = parts[0];

    // Format integer part with commas
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formattedIntegerPart = integerPart.replaceAllMapped(reg, (Match match) => '${match[1]},');

    // Return only the integer part with commas
    return formattedIntegerPart;
  }











  makePdfFileRow(int index, ExpenseModel model, pw.Font ttf, double pageWidth) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.SizedBox(width: pageWidth * .1, child: pw.Text("${index + 1}")),
          pw.SizedBox(
            child: pw.Text(
              model.reason,
              style: pw.TextStyle(font: ttf, fontSize: fontSize),
            ),
            width: pageWidth * .3,
          ),
          pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: pw.Text(
              model.expenseType == ExpenseType.moneyOut
                  ? "${formatNumber(model.amount)}"
                  : "0",
              style: pw.TextStyle(font: ttf, fontSize: fontSize),
            ),
            width: pageWidth * .1,
          ),
          pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: pw.Text(
              model.expenseType == ExpenseType.moneyIn
                  ? "${formatNumber(model.amount)}"
                  : "0",
              style: pw.TextStyle(font: ttf, fontSize: fontSize),
            ),
            width: pageWidth * .1,
          ),
          pw.SizedBox(
            child: pw.Text(
              model.date,
              style: pw.TextStyle(font: ttf, fontSize: fontSize),
            ),
            width: pageWidth * .2,
          ),
          pw.SizedBox(
            child: pw.Text(
              model.note,
              style: pw.TextStyle(font: ttf, fontSize: fontSize),
            ),
            width: pageWidth * .2,
          ),
        ],
      ),
    );
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
            id: 0,
            name: "name",
            totalIn: totalIn,
            totalOut: totalOut,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: model.data.filter.length,
    );
  }

  makeRow(
    int index,
    ExpenseModel expense,
    BuildContext context,
    double colSize,
    SectionModel section,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        makeChild("${index + 1}", colSize * .5),
        makeChild(expense.reason, colSize * 1.5),
        makeChild(
          expense.expenseType == ExpenseType.moneyOut
              ? "${formatNumber(expense.amount)}"
              : "0",
          colSize * 2.5,
        ),
        makeChild(
          expense.expenseType == ExpenseType.moneyIn
              ? "${formatNumber(expense.amount)}"
              : "0",
          colSize * 2.5,
        ),
        makeChild(expense.date, colSize * 2),
        makeChild(expense.note, colSize * 2),
      ],
    );
  }

  makeChild(String data, double width) {
    return SizedBox(
      width: width,
      child: Text(data, textAlign: TextAlign.center),
    );
  }

  deleteSection(SectionModel model) async {
    await SectionDB().deleteSectionWithExpenses(model);
    await fillAccountingList();
  }
}
