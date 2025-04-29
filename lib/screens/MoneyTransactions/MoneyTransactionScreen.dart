import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/Providers/MoneyTransactionProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../Commons/Helpers.dart';
import '../../CustomWidgets/CustomAutoComplete.dart';
import '../../CustomWidgets/CustomButton.dart';
import '../../CustomWidgets/CustomDatePicker.dart';
import '../../CustomWidgets/Spacers.dart';
import '../../Models/PrintDetailsModel.dart';
import '../Accounting/Widgets/table_data.dart';

class Moneytransactionscreen extends StatelessWidget {
  static const String rout = "MoneyTransactionScreen";
  final ScrollController controller = ScrollController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController dateFromController =
  TextEditingController(text: formattedDate());
  final TextEditingController dateToController =
  TextEditingController(text: formattedDate());
  final TextEditingController filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    Provider.of<MoneyTransactionProvider>(context, listen: false).fillList();

    // Theme colors for better aesthetics
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("حركة الاموال"),
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: "تصدير PDF",
              onPressed: () async {
                var provider = Provider.of<MoneyTransactionProvider>(context, listen: false);

                PrintDetailsModel c = PrintDetailsModel(
                 data : AccountingTableData(
                  width: MediaQuery.of(context).size.width / 12,
                  filter: provider.filteredExpenseList,
                  controller: controller,
                  section: SectionModel(id: 0, name: "name", totalIn: 0, totalOut: 0),
                ),

           //       data: data,
                  dateFrom: dateFromController.text,
                  dateTo: dateToController.text,
                  reasonFilter: filterController.text,
                  title: "model.name",
                  totalIn: provider.totalIn.toInt(),
                  totalOut: provider.totalOut.toInt(),

                );



                await provider.exportPdf(c);
              },
            ),
          ],
        ),

        body: Consumer<MoneyTransactionProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    alignment: WrapAlignment.start,
                    children: [
                      SizedBox(
                        width: isMobile ? width * 0.3 : width * 0.9,
                        height: MediaQuery.of(context).size.height / 20 ,
                        child: CustomDatePicker(
                          label: "التاريخ من",
                          controller: dateFromController,
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? width * 0.3 : width * 0.9,
                        height: MediaQuery.of(context).size.height / 20 ,
                        child: CustomDatePicker(
                          label: "التاريخ الى",
                          controller: dateToController,
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? width * 0.3 : width * 0.9,
                        height: MediaQuery.of(context).size.height / 20 ,
                        child: CustomButton(
                          text: "بحث",
                          onPressed: () {
                            provider.filter(
                              dateFromController.text,
                              dateToController.text,
                              filterController.text,
                            );
                          },
                          icon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                  heightSpace,
                  Wrap(
                    spacing: 3,
                    runSpacing: 5,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isMobile ? width * 0.9 : width * 1,
                        height: MediaQuery.of(context).size.height / 20 ,
                        child: CustomAutoComplete(
                          valueChange: (value) {
                            provider.filter(
                              dateFromController.text,
                              dateToController.text,
                              value ?? "",
                            );
                          },
                          options: provider.expenseList.map((e) => e.sectionModel!.name).toSet().toList(),
                          label: "فلتر القسم",
                          controller: filterController,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22 ,
                        child: FilterChip(
                          label: const Text("عرض الكل"),
                          selected: provider.selectedSection == ExpenseType.all,
                          onSelected: (value) {
                            provider.changeCheckbox(ExpenseType.all);
                            provider.filter(
                              dateFromController.text,
                              dateToController.text,
                              filterController.text,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22 ,
                        child: FilterChip(
                          label: const Text("عرض المستلمة فقط"),
                          selected: provider.selectedSection == ExpenseType.moneyIn,
                          onSelected: (value) {
                            provider.changeCheckbox(ExpenseType.moneyIn);
                            provider.filter(
                              dateFromController.text,
                              dateToController.text,
                              filterController.text,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22 ,
                        child: FilterChip(
                          label: const Text("عرض المصروفة فقط"),
                          selected: provider.selectedSection == ExpenseType.moneyOut,
                          onSelected: (value) {
                            provider.changeCheckbox(ExpenseType.moneyOut);
                            provider.filter(
                              dateFromController.text,
                              dateToController.text,
                              filterController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Beautiful card for the data table
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Scrollbar(
                            trackVisibility: true,
                            interactive: true,
                            thickness: 8,
                            radius: const Radius.circular(4),
                            controller: controller,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: buildBeautifulDataTable(context, provider, isMobile, primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }








  Widget buildBeautifulDataTable(
      BuildContext context,
      MoneyTransactionProvider provider,
      bool isSmallScreen,
      Color primaryColor) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width -50,
      child: Theme(
        // Override theme for the DataTable
        data: Theme.of(context).copyWith(
          dividerColor: Colors.grey.shade300,
          dataTableTheme: DataTableThemeData(
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 14,
            ),
            dataTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
        child: DataTable(
          columnSpacing: isSmallScreen ? 16 : 25,
          dataRowHeight: 65, // More height for better spacing
          horizontalMargin: 2,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          border: TableBorder(
            horizontalInside: BorderSide(width: 1, color: Colors.grey.shade200),
            top: BorderSide(width: 2, color: primaryColor.withOpacity(0.5)),
            bottom: BorderSide(width: 1, color: Colors.grey.shade300),
            left: BorderSide(width: 1, color: Colors.grey.shade300),
            right: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          columns: [
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('ت'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('التاريخ'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('القسم'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('المبلغ المصروف'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('المبلغ المستلم'),
              ),
            ),
          ],
          rows: List.generate(
            provider.filteredExpenseList.length,
                (index) {
              final expense = provider.filteredExpenseList[index];
              final bool isMoneyOut = expense.expenseType == ExpenseType.moneyOut;

              return DataRow(
                color: index % 2 == 0
                    ? MaterialStateProperty.all(Colors.grey.shade50)
                    : null,
                cells: <DataCell>[
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.pink[600],
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        expense.date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        expense.sectionModel!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: isMoneyOut ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          formatNumber(expense.amount),
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) : const Text("-"),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: !isMoneyOut ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          formatNumber(expense.amount),
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ) : const Text("-"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}