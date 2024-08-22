import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/CompanyDB.dart';
import 'package:notes/screens/Company/Widgets/CompanyDialogs.dart';
import 'AddWorker.dart';

class CompanyProfileScreen extends StatefulWidget {
  late CompanyModel model;

  CompanyProfileScreen({required this.model});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final ScrollController controller = ScrollController();
  final TextEditingController searchController =
      TextEditingController(text: "");
  List<WorkerModel> models = [];

  List<WorkerModel> filter = [];

  @override
  void initState() {
    getData();
  }

  Future<void> getData() async {
    models = [];
    filter = [];
    models = await CompanyDB().getAllWorkers(widget.model.id);
    filter = List<WorkerModel>.from(models);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(
                    "تفاصيل شركة ",
                  ),
                  Text(
                    widget.model.name,
                    style: const TextStyle(
                        color: Colors.deepOrange,
                       ),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                    await CompanyDialogs().createWorkerDialog(context, widget.model, null);
                    await getData();

                    },
                    child: const Row(
                      children: [Text("اضافه مندوب"), Icon(Icons.add)],
                    ))
              ],
            ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
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
                    onChanged: (value) {
                      if (value != "") {
                        filter.clear();
                        filter = models
                            .where((i) =>
                        i.drug.contains(value) ||
                            i.name.contains(value))
                            .toList();
                      } else {
                        filter = new List<WorkerModel>.from(models);
                      }
                      setState(() {});
                    },
                    textAlign: TextAlign.center,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "اسم المندوب او العلاج",
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                  // scroll list
                  controller: controller,
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'الاسم',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'الجوال',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'الادوية',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'العدد الكلي',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'العدد المنصرف',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'ملاحظه',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(
                          filter.length,
                              (index) {
                            return DataRow(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddWorker(
                                          selectedModel: widget.model,
                                          model: filter[index],
                                        ))).then(
                                      (value) {
                                    setState(() {});
                                  },
                                );
                              },
                              cells: <DataCell>[
                                DataCell(Text(filter[index].name)),
                                DataCell(Text(filter[index].phone)),
                                DataCell(Text(filter[index].drug)),
                                DataCell(Text(filter[index].total)),
                                DataCell(Text(filter[index].out)),
                                DataCell(Text(filter[index].note)),
                              ],
                            );
                          },
                        )),
                  ),
                ))
          ],
        ),
      )),
    );
  }

}
