import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomButton.dart';
import 'package:flutter/material.dart';
import '../../CustomWidgets/NoDataWidget.dart';
import '../../Models/CompanyModel.dart';
import '../../Providers/CompanyProvider.dart';

class CompanyFinishScreen extends StatelessWidget {
  static const String rout = "CompanyFinishScreen";
  final ScrollController controller = ScrollController();

  final TextEditingController searchController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    //double width = context.size!.width ;
    final companyModel =
        ModalRoute.of(context)!.settings.arguments as CompanyModel;
    Provider.of<CompanyProvider>(context, listen: false)
        .fillFinishedWorkerList(companyModel.id, 1);
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
                  "تفاصيل العمليات المكتملة لشركة    ",
                ),
                Text(
                  companyModel.name,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
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
                 // const SizedBox(width: 50, child: Text("بحث")),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: TextFormField(
                      onChanged: (value) {
                        companyProvider.finishedWorkerFilter(value);
                      },
                      textAlign: TextAlign.center,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "بحث بأسم المندوب أو ألمنتج",
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: companyProvider.finishedFilter.isEmpty
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
                                      'رقم الموبايل',
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
                                      'العدد المصروف',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'ملاحظة',
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
                              ],
                              rows: List.generate(
                                companyProvider.finishedFilter.length,
                                (index) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text("${index + 1}")),
                                      DataCell(Text(companyProvider
                                          .finishedFilter[index].name)),
                                      DataCell(Text(companyProvider
                                          .finishedFilter[index].phone)),
                                      DataCell(Text(companyProvider
                                          .finishedFilter[index].drug)),
                                      DataCell(Text(
                                          "${companyProvider.finishedFilter[index].total}")),
                                      DataCell(Text(
                                          "${companyProvider.finishedFilter[index].out}")),
                                      DataCell(Text(companyProvider
                                          .finishedFilter[index].note)),
                                      DataCell(Text(companyProvider
                                          .finishedFilter[index].date)),
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
