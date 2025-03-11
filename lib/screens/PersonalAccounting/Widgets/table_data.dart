import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/data/PersonalAccountingDb.dart';
import 'package:provider/provider.dart';

import '../../../Commons/Helpers.dart';
import '../../../CustomWidgets/CustomButton.dart';
import '../../../CustomWidgets/Spacers.dart';
import '../../../Providers/PersonalAccountingProvider.dart';

class PersonalAccountingTableData extends StatelessWidget {
  final double width;
  final List<ExpenseModel> filter;
  final ScrollController controller;
  final SectionModel section ;
  PersonalAccountingTableData(
      {required this.width, required this.filter, required this.controller , required this.section});

  @override
  Widget build(BuildContext context) {
    final double colSize = width / 12;
    return ListView.separated(
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return makeRow(index, filter[index], context, colSize , section);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: filter.length);
  }

  makeRow(int index, ExpenseModel expense, BuildContext context, double colSize,
      SectionModel section) {
    return InkWell(
      onLongPress: () {
        showOptionsDialog(context, expense, section);
      },
      child: Row(
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
      ),
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

  void showOptionsDialog(
      BuildContext context, ExpenseModel expenseModel, SectionModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اختر اجراء "),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                    text: "تعديل",
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<PersonalAccountingProvider>(context, listen: false)
                          .showAddExpenseDialog(context, model,
                              expenseModel.expenseType, expenseModel);
                    },
                    icon: Icons.edit),
                heightSpace,
                CustomButton(
                    text: "حذف",
                    onPressed: ()async {
                        await PersonalAccountingDB().deleteExpense(expenseModel);
                        Provider.of<PersonalAccountingProvider>(context, listen: false)
                            .fillExpenseList(section);
                        Provider.of<PersonalAccountingProvider>(context, listen: false)
                            .fillAccountingList();
                      Navigator.pop(context);
                    },
                    icon: Icons.delete_forever_sharp)
              ],
            ),
          ),
        );
      },
    );
  }
}
