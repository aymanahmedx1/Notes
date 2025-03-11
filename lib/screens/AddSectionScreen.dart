import 'package:flutter/material.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/data/SectionDB.dart';

class Addsectionscreen extends StatefulWidget {
  @override
  State<Addsectionscreen> createState() => _AddsectionscreenState();
  SectionModel? model;
}

class _AddsectionscreenState extends State<Addsectionscreen> {
  final TextEditingController nameController = TextEditingController(text: "");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();
  final labelWidth = 100.00;

  save() async {
    if (formKey.currentState!.validate()) {
      var toSave = SectionModel(
          id: 0, name: nameController.text, totalIn: 0, totalOut: 0);
      if (widget.model == null) {
        await SectionDB().addSection(toSave);
      } else {
        toSave.id = widget.model!.id;
        await SectionDB().updateSection(toSave);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      nameController.text = widget.model!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "اضافه مندوب",
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
                        children: [
                          Icon(Icons.arrow_back),
                          Text("رجوع"),
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: labelWidth, child: Text("الشركة ")),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 300,
                              height: 70,
                              child: TextFormField(
                                controller: nameController,
                                enabled: false,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.indigo, width: 3)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.indigo, width: 3)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.indigo, width: 3)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.green, width: 3)),
                                ),
                              ),
                            ),
                          ],
                        ), // Company Row
                        const SizedBox(
                          height: 15,
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await save();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Column(
                                children: [Icon(Icons.save), Text("حفظ")],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: Scrollbar(
              //     /// Scroll Bar
              //     trackVisibility: true,
              //     // SHow
              //     interactive: true,
              //     // Interact
              //     thickness: 10,
              //     // Width Of Scroll bar
              //     thumbVisibility: true,
              //     // show all time
              //     controller: controller,
              //     child: SingleChildScrollView(
              //       // scroll list
              //       controller: controller,
              //       child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //             width: double.infinity,
              //             child: DataTable(
              //                 columns: const <DataColumn>[
              //                   DataColumn(
              //                     label: Expanded(
              //                       child: Text(
              //                         'الادويه',
              //                         style: TextStyle(
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //                 rows: List.generate(
              //                   5,
              //                       (index) {
              //                     return DataRow(
              //                       onLongPress: () {},
              //                       color: WidgetStateProperty.resolveWith<
              //                           Color>((Set<MaterialState> states) {
              //                         // Color for the row
              //                         return index % 2 == 0
              //                             ? Colors.grey.shade200
              //                             : Colors.white;
              //                       }),
              //                       cells: <DataCell>[
              //                         DataCell(Text('علاج')),
              //                       ],
              //                     );
              //                   },
              //                 )),
              //           )),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
