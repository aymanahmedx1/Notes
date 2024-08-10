import 'package:flutter/material.dart';

class Accountdetailsscreen extends StatelessWidget {
  //final account ;
  final ScrollController controller = ScrollController();
  final TextEditingController companyController =
  TextEditingController(text: "");
   //Accountdetailsscreen({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    return  Directionality(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "الحسابات",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back),
                              Text("رجوع"),
                            ],
                          ))
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
                                          'تاريخ',
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
                                          'مبلغ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    300,
                                        (index) {
                                      return DataRow(
                                        onLongPress: () {

                                        },
                                        color:
                                        WidgetStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                              return index % 2 == 0
                                                  ? Colors.grey.shade200
                                                  : Colors.white;
                                            }),
                                        cells: <DataCell>[
                                          DataCell(SizedBox(width: 20,child: Text("$index"),)),
                                          DataCell(Text("تاريخ")),
                                          DataCell(Text('ملاحظه')),
                                          DataCell(Text('مبلغ')),
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
            ),
          )),
    );
  }
}
