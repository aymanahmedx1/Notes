import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomAutoComplete.dart';
import 'package:notes/CustomWidgets/CustomDatePicker.dart';
import 'package:notes/CustomWidgets/CutomTextInput.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Providers/AccountingProvider.dart';
import 'package:provider/provider.dart';

import '../../../Commons/Helpers.dart';
import '../../../CustomWidgets/CustomButton.dart';
import '../../../Models/SectionModel.dart';
import '../../../data/SectionDB.dart';

class AccountingDialog {
  createSection(BuildContext context, SectionModel? model) async {
    final TextEditingController textController =
        TextEditingController(text: "");

    if (model != null) {
      textController.text = model.name;
    }
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اضافه قسم"),
          content: CustomTextInput(
            label: "اسم القسم",
            controller: textController,
          ),
          actions: [
            CustomButton(
              icon: Icons.save,
              onPressed: () async {
                if (model != null) {
                  model.name = textController.text;
                  Provider.of<AccountingProvider>(context, listen: false)
                      .updateSection(model);
                } else {
                  var section = SectionModel(
                      totalIn: 0,
                      totalOut: 0,
                      id: 0,
                      name: textController.text);
                  Provider.of<AccountingProvider>(context, listen: false)
                      .addSection(section);
                }
                Navigator.of(context).pop("1");
              },
              text: "حفظ",
            )
          ],
        );
      },
    );
  }

  addExpenseOnSection(BuildContext context, SectionModel section,
      ExpenseType type, ExpenseModel? expenseModel ) async {
    final TextEditingController noteController =
        TextEditingController(text: "");
    final TextEditingController amountController =
        TextEditingController(text: "");
    final TextEditingController reasonController =
        TextEditingController(text: "");
    final TextEditingController dateController =
        TextEditingController(text: "");
    String? initValue ;
    if (expenseModel != null) {
      noteController.text = expenseModel.note;
      amountController.text = expenseModel.amount.toString();
      reasonController.text = expenseModel.reason;
      dateController.text = expenseModel.date;
      initValue = expenseModel.reason;
    }
    String label = type == ExpenseType.moneyIn ? "اضافة مبلغ" : "اضافه مصروف";
    List<String> reasonList =
        Provider.of<AccountingProvider>(context, listen: false)
            .filteredExpenseList
            .where(
              (element) => element.expenseType == type,
            )
            .map((e) => e.reason)
            .toSet()
            .toList();

    dateController.text = formattedDate();
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(label),
              Text(
                " ${section.name} ",
                style: const TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomAutoComplete(
                  initValue: initValue,
                  controller: reasonController,
                  label: "السبب",
                  options: reasonList,
                ),
                heightSpace,
                CustomTextInput(
                  label: "المبلغ",
                  controller: amountController,
                  textInputType: TextInputType.number,
                ),
                heightSpace,
                CustomDatePicker(
                  label: "التاريخ",
                  controller: dateController,
                ),
                heightSpace,
                CustomTextInput(
                  label: "ملاحظات",
                  controller: noteController,
                ),
                heightSpace,
              ],
            ),
          ),
          actions: [
            CustomButton(
              icon: Icons.save,
              onPressed: () async {
                var ex = ExpenseModel(
                    id: 0,
                    note: noteController.text,
                    amount: double.parse(amountController.text),
                    reason: reasonController.text,
                    section: section.id,
                    date: dateController.text,
                    expenseType: type);
                if (expenseModel != null) {
                  ex.id = expenseModel.id;
                  Provider.of<AccountingProvider>(context, listen: false)
                      .updateExpense(ex, section, ex.amount, true);
                } else {
                  Provider.of<AccountingProvider>(context, listen: false)
                      .addNewExpense(ex, section, ex.amount, true);
                }

                Navigator.of(context).pop("1");
              },
              text: "حفظ",
            )
          ],
        );
      },
    );
  }
}
