import 'package:flutter/material.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/Providers/MoneyTransactionProvider.dart';
import 'package:provider/provider.dart';

import '../../Commons/Helpers.dart';
import '../../CustomWidgets/CustomAutoComplete.dart';
import '../../CustomWidgets/CustomButton.dart';
import '../../CustomWidgets/CustomDatePicker.dart';
import '../../CustomWidgets/Spacers.dart';
import '../../Models/PrintDetailsModel.dart';
import '../Accounting/Widgets/table_data.dart';

class Moneytransactionscreen extends StatelessWidget {
  static const String rout = "Moneytransactionscreen";
  final ScrollController controller = ScrollController();
  final TextEditingController companyController =
      TextEditingController(text: "");

  final TextEditingController dateFromController =
      TextEditingController(text: formattedDate());

  final TextEditingController dateToController =
      TextEditingController(text: formattedDate());
  final TextEditingController filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    Provider.of<MoneyTransactionProvider>(context, listen: false).fillList();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "حركة الاموال ",
        ),
        centerTitle: true,
      ),
      body: Consumer<MoneyTransactionProvider>(
        builder: (context, moneyTransactionProvider, child) {
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
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: width / 12 * 4,
                        child: CustomDatePicker(
                          label: "التاريخ الى",
                          controller: dateToController,
                        )),
                    widthSpace,
                    CustomButton(
                      text: "بحث",
                      onPressed: () {
                        moneyTransactionProvider.filter(dateFromController.text,
                            dateToController.text, filterController.text);
                      },
                      icon: Icons.search,
                    ),
                    widthSpace,
                    CustomButton(
                      text: "تصدير pdf",
                      onPressed: () async {
                        var data = AccountingTableData(
                          width: width,
                          filter: moneyTransactionProvider.filteredExpenseList,
                          controller: controller,
                          section: new SectionModel(id: 0, name: "name", totalIn: 0, totalOut: 0),
                        );
                        PrintDetailsModel c = PrintDetailsModel(
                            data: data,
                            dateFrom: dateFromController.text,
                            dateTo: dateToController.text,
                            reasonFilter: filterController.text,
                            title: "model.name",
                            totalIn: Provider.of<MoneyTransactionProvider>(context,listen: false).totalIn.toInt(),
                            totalOut: Provider.of<MoneyTransactionProvider>(context,listen: false).totalOut.toInt());
                        await moneyTransactionProvider.exportPdf(c);
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
                        valueChange: (value) {
                          moneyTransactionProvider.filter(dateFromController.text,
                              dateToController.text, value??"");
                        },
                        options: Provider.of<MoneyTransactionProvider>(context,
                                listen: false)
                            .expenseList
                            .map((e) => e.sectionModel!.name)
                            .toSet()
                            .toList(),
                        label: "فلتر القسم",
                        controller: filterController,
                      ),
                    ),
                    widthSpace,
                    const Text("عرض الكل"),
                    Checkbox(
                      value: moneyTransactionProvider.selectedSection ==
                          ExpenseType.all,
                      onChanged: (value) {
                        moneyTransactionProvider
                            .changeCheckbox(ExpenseType.all);
                        moneyTransactionProvider.filter(dateFromController.text,
                            dateToController.text, filterController.text);
                      },
                    ),
                    widthSpace,
                    const Text("عرض المبالغ المستلمة فقط"),
                    Checkbox(
                      value: moneyTransactionProvider.selectedSection ==
                          ExpenseType.moneyIn,
                      onChanged: (value) {
                        moneyTransactionProvider
                            .changeCheckbox(ExpenseType.moneyIn);
                        moneyTransactionProvider.filter(dateFromController.text,
                            dateToController.text, filterController.text);
                      },
                    ),
                    widthSpace,
                    const Text("عرض المبالغ المصروفة فقط"),
                    Checkbox(
                      value: moneyTransactionProvider.selectedSection ==
                          ExpenseType.moneyOut,
                      onChanged: (value) {
                        moneyTransactionProvider
                            .changeCheckbox(ExpenseType.moneyOut);
                        moneyTransactionProvider.filter(dateFromController.text,
                            dateToController.text, filterController.text);
                      },
                    ),
                  ],
                ),
                heightSpace,
                Row(
                  children: [
                    const Text("مجموع المبلغ المصروف"),
                    widthSpace,
                    Text(
                      formatNumber(moneyTransactionProvider.totalOut),
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                    widthSpace,
                    widthSpace,
                    const Text(" مجموع المبلغ المستلم"),
                    widthSpace,
                    Text(
                      formatNumber(moneyTransactionProvider.totalIn),
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
                          child: SizedBox(
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
                                        'تاريخ',
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
                                        'المبلغ المصروف',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'المبلغ المستلم',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  moneyTransactionProvider
                                      .filteredExpenseList.length,
                                  (index) {
                                    return DataRow(
                                      onLongPress: () {},
                                      color: WidgetStateProperty.resolveWith<
                                          Color>((Set<WidgetState> states) {
                                        return index % 2 == 0
                                            ? Colors.grey.shade200
                                            : Colors.white;
                                      }),
                                      cells: <DataCell>[
                                        DataCell(SizedBox(
                                          width: 20,
                                          child: Text("${index + 1}"),
                                        )),
                                        DataCell(Text(moneyTransactionProvider
                                            .filteredExpenseList[index].date)),
                                        DataCell(Text(moneyTransactionProvider
                                            .filteredExpenseList[index]
                                            .sectionModel!
                                            .name)),
                                        DataCell(Text(formatNumber(
                                            moneyTransactionProvider
                                                        .filteredExpenseList[
                                                            index]
                                                        .expenseType ==
                                                    ExpenseType.moneyOut
                                                ? moneyTransactionProvider
                                                    .filteredExpenseList[index]
                                                    .amount
                                                : 0))),
                                        DataCell(Text(formatNumber(
                                            moneyTransactionProvider
                                                        .filteredExpenseList[
                                                            index]
                                                        .expenseType ==
                                                    ExpenseType.moneyOut
                                                ? 0
                                                : moneyTransactionProvider
                                                    .filteredExpenseList[index]
                                                    .amount))),
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
