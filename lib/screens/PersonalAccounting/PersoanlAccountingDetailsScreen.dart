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
import '../../CustomWidgets/NoDataWidget.dart';
import '../../Models/PersonalPrintDetailsModel.dart';
import '../../Models/PrintDetailsModel.dart';
import '../../data/SectionDB.dart';
import 'Widgets/table_data.dart';
import 'Widgets/table_header.dart';

class PersonalAccountingDetailsScreen extends StatelessWidget {
  final SectionModel model;

  final ScrollController controller = ScrollController();
  final TextEditingController dateFromController =
      TextEditingController(text: formattedDate());

  final TextEditingController dateToController =
      TextEditingController(text: formattedDate());
  final TextEditingController filterController = TextEditingController();
  PersonalAccountingDetailsScreen(this.model);

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
                            filterController.text,
                            accountingProvider.selectedSection);
                      },
                      icon: Icons.search,
                    ),
                    widthSpace,
                    CustomButton(
                      text: "تصدير",
                      onPressed: () async {
                        var data = PersonalAccountingTableData(
                          width: width,
                          filter: accountingProvider.filteredExpenseList,
                          controller: controller,
                          section: model,
                        );
                        PersonalPrintDetailsModel c = PersonalPrintDetailsModel(
                            data: data,
                            dateFrom: dateFromController.text,
                            dateTo: dateToController.text,
                            reasonFilter: filterController.text,
                            title: "Title",
                            totalIn: Provider.of<AccountingProvider>(context,listen: false).totalIn.toInt(),
                            totalOut: Provider.of<AccountingProvider>(context,listen: false).totalOut.toInt());
                        await accountingProvider.exportPersonalPdf(c);
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
                              value,
                              accountingProvider.selectedSection);
                        },
                      ),
                    ),
                    widthSpace,
                    const Text("الكل"),
                    Checkbox(
                      value:
                          accountingProvider.selectedSection == ExpenseType.all,
                      onChanged: (value) {
                        accountingProvider.changeCheckbox(ExpenseType.all);
                        accountingProvider.filterExpenseList(
                            dateFromController.text,
                            dateToController.text,
                            filterController.text,
                            accountingProvider.selectedSection);
                      },
                    ),
                    widthSpace,
                    const Text("القبض"),
                    Checkbox(
                      value: accountingProvider.selectedSection ==
                          ExpenseType.moneyIn,
                      onChanged: (value) {
                        accountingProvider.changeCheckbox(ExpenseType.moneyIn);
                        accountingProvider.filterExpenseList(
                            dateFromController.text,
                            dateToController.text,
                            filterController.text,
                            accountingProvider.selectedSection);
                      },
                    ),
                    widthSpace,
                    const Text("المصروف"),
                    Checkbox(
                      value: accountingProvider.selectedSection ==
                          ExpenseType.moneyOut,
                      onChanged: (value) {
                        accountingProvider.changeCheckbox(ExpenseType.moneyOut);
                        accountingProvider.filterExpenseList(
                            dateFromController.text,
                            dateToController.text,
                            filterController.text,
                            accountingProvider.selectedSection);
                      },
                    ),
                  ],
                ),
                heightSpace,
                Row(
                  children: [
                    const Text("المصروف"),
                    widthSpace,
                    Text(
                      formatNumber(
                          Provider.of<AccountingProvider>(context).totalOut),
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                    widthSpace,
                    widthSpace,
                    const Text("المقبوض"),
                    widthSpace,
                    Text(
                      formatNumber(
                          Provider.of<AccountingProvider>(context).totalIn),
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
                PersonalAccountingTableHeader(
                  width: width,
                ),
                Expanded(
                    child: accountingProvider.filteredExpenseList.isEmpty
                        ? NoDataWidget()
                        : SingleChildScrollView(
                            // scroll list
                            child: PersonalAccountingTableData(
                              width: width,
                              filter: accountingProvider.filteredExpenseList,
                              controller: controller,
                              section: model,
                            ),
                          ))
              ],
            ),
          );
        },
      ),
    ));
  }
}