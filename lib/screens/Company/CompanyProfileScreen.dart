import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/NoDataWidget.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/screens/Company/Widgets/CompanyDialogs.dart';
import 'package:provider/provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  static const String rout = "CompanyProfileScreen";
  final ScrollController controller = ScrollController();

  final TextEditingController searchController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    //double width = context.size!.width ;
    final companyModel =
        ModalRoute.of(context)!.settings.arguments as CompanyModel;
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "تفاصيل شركة ",
                ),
                Text(
                  companyModel.name,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    companyProvider.createWorker(context, companyModel, null);
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
              const SizedBox(
                height: 10,
              ),
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
                        companyProvider.workerFilter(value);
                      },
                      textAlign: TextAlign.center,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "اسم المندوب او العلاج",
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: companyProvider.filter.isEmpty
                      ? NoDataWidget()
                      : SingleChildScrollView(
                          // scroll list
                          controller: controller,
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
                                      'الاسم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'الجوال',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'المنتجات',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      'العدد الكلي',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      'العدد المنصرف',
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
                              ],
                              rows: List.generate(
                                companyProvider.filter.length,
                                (index) {
                                  return DataRow(
                                    onLongPress: () {
                                      if (companyProvider.filter[index].out >=
                                          companyProvider.filter[index].total) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "اختر اجراء للمتابعه"),
                                              actions: [
                                                CustomButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    companyProvider
                                                        .createWorker(
                                                            context,
                                                            companyModel,
                                                            companyProvider
                                                                .filter[index]);
                                                  },
                                                  text: "تعديل",
                                                  icon: Icons.edit,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomButton(
                                                  onPressed: () {
                                                    companyProvider
                                                        .markWorkerAsFinish(
                                                            companyProvider
                                                                .filter[index]);
                                                    Navigator.pop(context);
                                                  },
                                                  text: "انتهي",
                                                  icon: Icons.check,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        companyProvider.createWorker(
                                            context,
                                            companyModel,
                                            companyProvider.filter[index]);
                                      }
                                    },
                                    cells: <DataCell>[
                                      DataCell(Text("${index+1}")),
                                      DataCell(Text(
                                          companyProvider.filter[index].name)),
                                      DataCell(Text(
                                          companyProvider.filter[index].phone)),
                                      DataCell(Text(
                                          companyProvider.filter[index].drug)),
                                      DataCell(Text(
                                          "${companyProvider.filter[index].total}")),
                                      DataCell(Text(
                                          "${companyProvider.filter[index].out}")),
                                      DataCell(Text(
                                          companyProvider.filter[index].note)),
                                    ],
                                  );
                                },
                              )),
                        ))
            ],
          ),
        ));
      },
    );
  }
}
