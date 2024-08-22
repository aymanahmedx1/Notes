import 'package:flutter/material.dart';
import 'package:notes/Models/SectionModel.dart';

import '../../CustomWidgets/PageHeader.dart';
import '../../data/SectionDB.dart';

class AccountingDetailsScreen extends StatelessWidget {
  late SectionModel model;

  final ScrollController controller = ScrollController();

  AccountingDetailsScreen(this.model);

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
              Pageheader(name: " تفاصيل القسم  ${model.name}"),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [Text("رجوع"), Icon(Icons.arrow_back)],
                      )),
                  const SizedBox(
                    width: 20,
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
                              future: SectionDB().getSectionDetails(model),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  List<ExpenseModel> list =
                                      snap.data as List<ExpenseModel>;
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
                                              'السبب',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'المبلغ',
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
                                        list.length,
                                        (index) {
                                          return DataRow(
                                            onLongPress: () {},
                                            cells: <DataCell>[
                                              DataCell(SizedBox(
                                                width: 20,
                                                child: Text("${index+1}"),
                                              )),
                                              DataCell(
                                                  Text(list[index].reason)),
                                              DataCell(Text(
                                                  "${list[index].amount}")),
                                              DataCell(Text(
                                                  "${list[index].date}")),
                                              DataCell(
                                                  Text("${list[index].note}"))
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
}
