import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Commons/Helpers.dart';
import 'package:notes/CustomWidgets/CustomAutoComplete.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/Providers/AccountingProvider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomButton.dart';
import '../../CustomWidgets/CustomDatePicker.dart';
import '../../data/SectionDB.dart';

class AccountingDetailsScreen extends StatelessWidget {
  final SectionModel model;

  final ScrollController controller = ScrollController();
  final TextEditingController dateFromController =
      TextEditingController(text: formattedDate());

  final TextEditingController dateToController =
      TextEditingController(text: formattedDate());
  final TextEditingController filterController = TextEditingController();

  AccountingDetailsScreen(this.model);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(" تفاصيل القسم  ${model.name}"),
        centerTitle: true,
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
                        child: CustomDatePicker(
                          label: "التاريخ من",
                          controller: dateFromController,
                        )),
                    widthSpace,
                    SizedBox(
                        width: width / 12 * 4,
                        child: CustomDatePicker(
                          label: "التاريخ الي",
                          controller: dateToController,
                        )),
                    widthSpace,
                    CustomButton(
                      text: "بحث",
                      onPressed: () {
                        accountingProvider.filterExpenseList(
                            dateFromController.text,
                            dateToController.text,
                            filterController.text);
                      },
                      icon: Icons.search,
                    )
                  ],
                ),
                heightSpace,
                Row(
                  children: [
                    SizedBox(
                      width: width / 12 * 4,
                      child: CustomAutoComplete(
                        options: Provider.of<AccountingProvider>(context,
                                listen: false)
                            .expenseList
                            .map((e) => e.reason)
                            .toSet()
                            .toList(),
                        label: "فلتر السبب",
                        controller: filterController,
                        valueChange: (value) {
                          accountingProvider.filterExpenseList(
                              dateFromController.text,
                              dateToController.text,
                              value);
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                heightSpace,
                Row(
                  children: [
                    const Text("المصروف"),
                    widthSpace,
                    Text(
                      formatNumber(Provider.of<AccountingProvider>(context).totalOut),
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                    widthSpace,
                    widthSpace,
                    const Text("المقبوض"),
                    widthSpace,
                    Text(
                      formatNumber(Provider.of<AccountingProvider>(context).totalIn),
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
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
                                        'No',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'السبب',
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
                                        'التاريخ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'ملاحظات',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  accountingProvider.filteredExpenseList.length,
                                  (index) {
                                    return DataRow(
                                      onLongPress: () {},
                                      cells: <DataCell>[
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(
                                            overflow: TextOverflow.ellipsis,
                                            accountingProvider
                                                .filteredExpenseList[index]
                                                .reason)),
                                        DataCell(Text(
                                          accountingProvider
                                                      .filteredExpenseList[
                                                          index]
                                                      .expenseType ==
                                                  ExpenseType.moneyOut
                                              ? "${formatNumber(accountingProvider.filteredExpenseList[index].amount)}"
                                              : "0",
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        DataCell(Text(
                                          accountingProvider
                                                      .filteredExpenseList[
                                                          index]
                                                      .expenseType ==
                                                  ExpenseType.moneyIn
                                              ? "${formatNumber(accountingProvider.filteredExpenseList[index].amount)}"
                                              : "0",
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        DataCell(Text(
                                            overflow: TextOverflow.ellipsis,
                                            accountingProvider
                                                .filteredExpenseList[index]
                                                .date)),
                                        DataCell(Text(accountingProvider
                                            .filteredExpenseList[index].note))
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
}
