import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/Commons/Helpers.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/CutomTextInput.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/Providers/AccountingProvider.dart';
import 'package:notes/screens/Accounting/Widgets/Dialogs.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomColumnButton.dart';
import 'AccountingDetailsScreen.dart';

class Accountingscreen extends StatelessWidget {
  static const String rout = "Accountingscreen";

  final ScrollController controller = ScrollController();

  final TextEditingController filterController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("الاقسام"),
        centerTitle: true,
        actions: [
          ElevatedButton(
              onPressed: () async {
                await AccountingDialog().createSection(context, null);
              },
              child: const Row(
                children: [Text("جديد"), Icon(Icons.add)],
              )),
        ],
      ),
      body: Consumer<AccountingProvider>(
        builder: (context, accountingProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: width / 12 * 4,
                        child: CustomTextInput(
                          label: "فلتر القسم ",
                          controller: filterController,
                          valueChange: (value) {
                            Provider.of<AccountingProvider>(context,
                                    listen: false)
                                .filterAccounts(value);
                          },
                        )),
                  ],
                ),
                Expanded(
                  child: Scrollbar(
                    /// Scroll Bar
                    trackVisibility: true,
                    // SHow
                    interactive: true,
                    // Interact
                    thickness: 10,
                    // Width Of Scroll bar
                    controller: controller,
                    // Controll scroll bar location
                    thumbVisibility: true,
                    // show all time
                    child: SingleChildScrollView(
                      // scroll list
                      controller: controller,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'م',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'القسم',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'المصروف',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'المستلم',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'العمليات',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  accountingProvider
                                      .filteredAccountingList.length,
                                  (index) {
                                    return DataRow(
                                      onLongPress: () {
                                        AccountingDialog().createSection(
                                            context,
                                            accountingProvider
                                                .filteredAccountingList[index]);
                                      },
                                      cells: <DataCell>[
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(accountingProvider
                                            .filteredAccountingList[index]
                                            .name)),
                                        DataCell(Text(formatNumber(
                                            accountingProvider
                                                .filteredAccountingList[index]
                                                .totalOut))),
                                        DataCell(Text(formatNumber(
                                            accountingProvider
                                                .filteredAccountingList[index]
                                                .totalIn))),
                                        DataCell(makeOperationRow(
                                            context,
                                            accountingProvider
                                                .filteredAccountingList[index]))
                                      ],
                                    );
                                  },
                                )),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget makeOperationRow(BuildContext context, SectionModel section) {
    return Row(
      children: [
        CustomColumnButton(
          onPressed: () {
            Provider.of<AccountingProvider>(context, listen: false)
                .showAddExpenseDialog(
                    context, section, ExpenseType.moneyIn, null);
          },
          icon: Icons.add,
          text: "اضافة مبلغ",
        ),
        widthSpace,
        CustomColumnButton(
          onPressed: () =>
              Provider.of<AccountingProvider>(context, listen: false)
                  .showAddExpenseDialog(
                      context, section, ExpenseType.moneyOut, null),
          icon: Icons.remove,
          text: "صرف مبلغ",
        ),
        widthSpace,
        CustomColumnButton(
          onPressed: () {
            Provider.of<AccountingProvider>(context, listen: false)
                .fillExpenseList(section);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountingDetailsScreen(section)));
          },
          icon: Icons.more_horiz,
          text: "تفاصيل",
        ),
      ],
    );
  }
}
