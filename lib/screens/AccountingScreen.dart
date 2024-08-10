import 'package:flutter/material.dart';
import 'package:notes/screens/AccountDetailsScreen.dart';

class Accountingscreen extends StatelessWidget {
  final ScrollController controller = ScrollController();
  final TextEditingController companyController =
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
              SizedBox(
                height: 10,
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AddWorker()));
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
                      controller: companyController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.always,
                      onChanged: (value) {
                        // valueChanged(value);
                      },
                      validator: (value) {},
                      decoration: InputDecoration(
                        hintText: "2024/8/14",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.red, width: 3)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                      ),
                    ),
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
                      controller: companyController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.always,
                      onChanged: (value) {
                        // valueChanged(value);
                      },
                      validator: (value) {},
                      decoration: InputDecoration(
                        hintText: "2024/8/14",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.red, width: 3)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
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
                                      'القسم',
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
                                      'المصروف',
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Accountdetailsscreen()));
                                    },
                                    color:
                                        WidgetStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                      return index % 2 == 0
                                          ? Colors.grey.shade200
                                          : Colors.white;
                                    }),
                                    cells: <DataCell>[
                                      DataCell(SizedBox(
                                        width: 20,
                                        child: Text("$index"),
                                      )),
                                      DataCell(Text("القسم")),
                                      DataCell(Text('2024-10-1')),
                                      DataCell(Text('20')),
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
