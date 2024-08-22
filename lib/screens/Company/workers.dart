import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/CompanyDB.dart';
import 'package:notes/screens/Company/AddWorker.dart';

import 'AddCompnay.dart';
import 'CompanyProfileScreen.dart';

class Workers extends StatefulWidget {
  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  final ScrollController controller = ScrollController();
  int? _selectedRowIndex;

  void _onRowSelected(int index) {
    setState(() {
      _selectedRowIndex = index;
    });
  }

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "المندوبين",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCompnay())).then(
                          (value) {
                            setState(() {});
                          },
                        );
                      },
                      child: const Row(
                        children: [Text("اضافة شركة"), Icon(Icons.add)],
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
                  child: FutureBuilder(
                    future: CompanyDB().getAll(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CompanyModel> data =
                            snapshot.data as List<CompanyModel>;
                        return SingleChildScrollView(
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
                                      data.length,
                                      (index) {
                                        return DataRow(
                                          onLongPress: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCompnay(
                                                          company: data[index],
                                                        ))).then(
                                              (value) {
                                                setState(() {});
                                              },
                                            );
                                          },

                                          cells: <DataCell>[
                                            DataCell(Text(data[index].name)),
                                            DataCell(Text(data[index].notes)),
                                            DataCell(Text(data[index].date)),
                                            DataCell(ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompanyProfileScreen(model: data[index],)));
                                              },
                                              child: const Icon(
                                                Icons.search_rounded,
                                                size: 30,
                                              ),
                                            )),
                                          ],
                                        );
                                      },
                                    )),
                              )),
                        );
                      } else {
                        return SingleChildScrollView(
                          controller: controller,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
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
