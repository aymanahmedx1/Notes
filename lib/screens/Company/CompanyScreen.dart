import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/NoDataWidget.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:provider/provider.dart';
import 'CompanyProfileScreen.dart';

class CompanyScreen extends StatelessWidget {
  static const String rout = "CompanyScreen";
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "المندوبين",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          CustomButton(
            onPressed: () {
              Provider.of<CompanyProvider>(context, listen: false)
                  .createOrUpdate(context, null);
            },
            text: "اضافة شركة",
            icon: Icons.add,
          )
        ],
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, companyProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 50, child: Text("بحث")),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 300,
                      height: 70,
                      child: TextFormField(
                        onChanged: (value) =>
                            companyProvider.companyFilter(value),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "اسم الشركة",
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: companyProvider.filterdCompanyModels.isEmpty
                      ? NoDataWidget()
                      : Scrollbar(
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
                                      columns: const <DataColumn>[
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
                                              'الشركه',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'ملاحظه',
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
                                              'المزيد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                        companyProvider
                                            .filterdCompanyModels.length,
                                        (index) {
                                          return DataRow(
                                            onLongPress: () {
                                              Provider.of<CompanyProvider>(
                                                      context,
                                                      listen: false)
                                                  .createOrUpdate(
                                                      context,
                                                      companyProvider
                                                              .filterdCompanyModels[
                                                          index]);
                                            },
                                            cells: <DataCell>[
                                              DataCell(Text("${index + 1}")),
                                              DataCell(Text(companyProvider
                                                  .filterdCompanyModels[index]
                                                  .name)),
                                              DataCell(Text(companyProvider
                                                  .filterdCompanyModels[index]
                                                  .notes)),
                                              DataCell(Text(companyProvider
                                                  .filterdCompanyModels[index]
                                                  .date)),
                                              DataCell(Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Provider.of<CompanyProvider>(
                                                              context,
                                                              listen: false)
                                                          .fillWorkerList(
                                                              companyProvider
                                                                  .filterdCompanyModels[
                                                                      index]
                                                                  .id,
                                                              0);
                                                      Navigator.pushNamed(
                                                        context,
                                                        CompanyProfileScreen
                                                            .rout,
                                                        arguments: companyProvider
                                                                .filterdCompanyModels[
                                                            index],
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.more_horiz,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  widthSpace,
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDeleteDialog(
                                                          context,
                                                          companyProvider
                                                                  .filterdCompanyModels[
                                                              index]);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                      elevation: 5 ,
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              )),
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

  void showDeleteDialog(BuildContext context, CompanyModel companymodel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.dangerous,
            size: 40,
            color: Colors.red,
          ),
          actions: [
            CustomButton(
              icon: Icons.check,
              onPressed: () {
                Provider.of<CompanyProvider>(context, listen: false)
                    .deleteCompany(companymodel);
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
              "هل انت متاكد من حذف الشركه والمندوبين التابعين لها ؟"),
        );
      },
    );
  }
}
