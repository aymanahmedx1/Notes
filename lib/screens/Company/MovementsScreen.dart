import 'package:flutter/material.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:provider/provider.dart';

import '../../CustomWidgets/CutomTextInput.dart';

class Movementsscreen extends StatelessWidget {
  static const String rout = "Movementsscreen";

  final ScrollController controller = ScrollController();

  final TextEditingController filterController =
  TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("التفاصيل"),
            centerTitle: true,
          ),
          body: Consumer<CompanyProvider>(
            builder: (context, accountingProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

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
                                            'العدد',
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
                                    ],
                                    rows: List.generate(
                                      accountingProvider
                                          .movemensModels.length,
                                          (index) {
                                        return DataRow(
                                          onLongPress: () {

                                          },
                                          cells: <DataCell>[
                                            DataCell(Text("${index + 1}")),
                                            DataCell(Text(accountingProvider
                                                .movemensModels[index]
                                                .qty.toString())),
                                            DataCell(Text(accountingProvider
                                                .movemensModels[index]
                                                .date)),

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
