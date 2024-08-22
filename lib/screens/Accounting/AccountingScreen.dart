import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/PageHeader.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/data/SectionDB.dart';
import 'package:notes/screens/Accounting/Widgets/Dialogs.dart';

import 'AccountingDetailsScreen.dart';

class Accountingscreen extends StatefulWidget {
  @override
  State<Accountingscreen> createState() => _AccountingscreenState();
}

class _AccountingscreenState extends State<Accountingscreen> {
  final ScrollController controller = ScrollController();
  final TextEditingController dateFromController =
      TextEditingController(text: "");
  final TextEditingController dateToController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Pageheader(name: "الحسابات"),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [Text("الرئيسيه"), Icon(Icons.home)],
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await AccountingDialog().createSection(context, null);
                        setState(() {});
                      },
                      child: const Row(
                        children: [Text("جديد"), Icon(Icons.add)],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text("التاريخ من "),
                  Container(
                    width: 300,
                    height: 40,
                    child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: dateFromController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: "2024/8/14",
                        )),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text("الي "),
                  Container(
                    width: 300,
                    height: 40,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: dateToController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        hintText: "2024/8/14",
                      ),
                    ),
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
                          child: FutureBuilder(
                              future: SectionDB().getAllSections(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  List<SectionModel> list =
                                      snap.data as List<SectionModel>;
                                  return DataTable(
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
                                              'العمليات',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                        list.length,
                                        (index) {
                                          return DataRow(
                                            onLongPress: () async {
                                              await AccountingDialog()
                                                  .createSection(
                                                      context, list[index]);
                                              setState(() {});
                                            },
                                            cells: <DataCell>[
                                              DataCell(SizedBox(
                                                width: 20,
                                                child: Text("$index"),
                                              )),
                                              DataCell(Text(list[index].name)),
                                              DataCell(
                                                  Text("${list[index].total}")),
                                              DataCell(
                                                  makeOperationRow(list[index]))
                                            ],
                                          );
                                        },
                                      ));
                                } else {
                                  return Center(child: Text("لا توجد بيانات"));
                                }
                              }),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget makeOperationRow(SectionModel section) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
         String? res =    await AccountingDialog().addExpenseOnSection(context, section);
            setState(() {

            });
          if(res!=null){
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar("تم الاضافه بنجاح"));
          }
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(
          width: 5,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountingDetailsScreen(section)));
          },
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  snackBar(String text) => SnackBar(
    backgroundColor: Colors.white,
        content: Text(text,style: const TextStyle(color: Colors.deepOrange),),
      );
}
