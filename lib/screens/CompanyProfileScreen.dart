import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/CompanyDB.dart';

import 'AddWorker.dart';

class CompanyProfileScreen extends StatefulWidget {
  late CompanyModel model;

  CompanyProfileScreen({required this.model});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final ScrollController controller = ScrollController();

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
                  Column(
                    children: [
                      Text(
                        "تفاصيل شركة ",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.model.name,
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
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
                                builder: (context) => AddWorker(
                                      selectedModel: widget.model,
                                    ))).then((value) {
                                      setState(() {
                                        
                                      });
                                    },);
                      },
                      child: const Row(
                        children: [Text("اضافه مندوب"), Icon(Icons.add)],
                      )),
                ],
              ),
              Expanded(
                  child: FutureBuilder(
                    future: CompanyDB().getAllWorkers() ,
                  builder: (context, snapshot) {
                     if(snapshot.hasData){
                       List<WorkerModel> models = snapshot.data as List<WorkerModel> ;
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
                                   ],
                                   rows: List.generate(
                                     models.length,
                                         (index) {
                                       return DataRow(
                                         onLongPress: () {
                                         },
                                         color: WidgetStateProperty.resolveWith<Color>(
                                                 (Set<MaterialState> states) {
                                               return index % 2 == 0
                                                   ? Colors.grey.shade200
                                                   : Colors.white;
                                             }),
                                         cells: <DataCell>[
                                           DataCell(Text(models[index].name)),
                                           DataCell(Text(models[index].phone)),

                                         ],
                                       );
                                     },
                                   )),
                             )),
                       );
                     }else{
                       return SingleChildScrollView(
                         controller: controller,
                         child: Center(child: Text("لا توجد بيانات"),),
                       );
                     }
                    }
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
