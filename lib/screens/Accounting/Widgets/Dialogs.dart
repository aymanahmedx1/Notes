import 'dart:developer';

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
    String title = "اضافه قسم";

    if (model != null) {
      textController.text = model.name;
      title = "تعديل قسم";
    }
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
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
            ),
            heightSpace,
            model != null
                ? CustomButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () async {
                      if (model != null) {
                        model.name = textController.text;
                      await showDeleteDialog(context, model);
                      }
                      Navigator.of(context).pop("1");
                    },
                    text: "حذف",
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }

  showDeleteDialog(BuildContext context,SectionModel? model) async{
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog (
          icon: const Icon(
            Icons.dangerous,
            size: 40,
            color: Colors.red,
          ),
          actions: [
            CustomButton(
              icon: Icons.check,
              onPressed: ()async {
                await  Provider.of<AccountingProvider>(context, listen: false)
                    .deleteSection(model!);
                Navigator.pop(context);
              },
              text: "تاكيد",
            ),
            heightSpace,
            CustomButton(
              icon: Icons.cancel,
              onPressed: () {
                Navigator.pop(context);
              },
              text: "رجوع",
            )
          ],
          title: const Text(
              "هل انت متاكد من الحذف "),
        );
      },
    );
  }


  addExpenseOnSection(BuildContext context, SectionModel section,
      ExpenseType type, ExpenseModel? expenseModel) async {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController noteController =
        TextEditingController(text: "");
    final TextEditingController amountController =
        TextEditingController(text: "");
    final TextEditingController reasonController =
        TextEditingController(text: "");
    final TextEditingController dateController =
        TextEditingController(text: "");
    String? initValue;
    if (expenseModel != null) {
      noteController.text = expenseModel.note;
      amountController.text = expenseModel.amount.toString();
      reasonController.text = expenseModel.reason;
      dateController.text = expenseModel.date;
      initValue = expenseModel.reason;
    }
    String label = type == ExpenseType.moneyIn ? "اضافة مبلغ" : "اضافه مصروف";
    // List<String> reasonList =
    //     Provider.of<AccountingProvider>(context, listen: false)
    //         .filteredExpenseList
    //         .where(
    //           (element) => element.expenseType == type,
    //         )
    //         .map((e) => e.reason)
    //         .toSet()
    //         .toList();
    List<String> reasonList =
        List.of(await SectionDB().getExpenseReasonListForSuggest(type));
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
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                    validateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "ادخل مبلغ صالح ";
                      }
                      if (int.tryParse(value) == null) {
                        return "ادخل مبلغ صالح ";
                      }
                      return null;
                    },
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
          ),
          actions: [
            CustomButton(
              icon: Icons.save,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
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
                }
              },
              text: "حفظ",
            )
          ],
        );
      },
    );
  }
}
