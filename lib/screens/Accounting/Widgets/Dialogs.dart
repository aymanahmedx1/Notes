import 'package:flutter/material.dart';

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
          title: const Directionality(
              textDirection: TextDirection.rtl, child: Text("اضافه قسم")),
          content: SizedBox(
            width: 300,
            height: 70,
            child: TextFormField(
              controller: textController,
              enabled: true,
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: "اسم القسم"),
            ),
          ),
          actions: [
            CustomButton(
              icon: Icons.save,
              onPressed: () async {
                if (model != null) {
                  model.name = textController.text;
                  await SectionDB().updateSection(model);
                } else {
                  await saveNewSection(textController.text);
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

  saveNewSection(String section) async {
    var Section = SectionModel(total: 0, id: 0, name: section);
    await SectionDB().addSection(Section);
  }

  addExpenseOnSection(BuildContext context, SectionModel section) async {
    final TextEditingController noteController =
        TextEditingController(text: "");
    final TextEditingController amountController =
        TextEditingController(text: "");
    final TextEditingController reasonController =
        TextEditingController(text: "");
    final TextEditingController dateController =
        TextEditingController(text: "");
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                const Text("اضافه مصروف"),
                Text(
                  " ${section.name} ",
                  style: const TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: reasonController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: "السبب"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: amountController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "المبلغ"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: dateController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "التاريخ"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: noteController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: "ملاحظات"),
                  ),
                ),
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
                    date: dateController.text);
                await SectionDB().addExpense(ex);
                await SectionDB().updateAmount(section, ex.amount, true);
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
