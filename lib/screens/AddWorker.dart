import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';

import '../data/CompanyDB.dart';

class AddWorker extends StatefulWidget {
  @override
  State<AddWorker> createState() => _AddWorkerState();
  CompanyModel? selectedModel;

  AddWorker({required this.selectedModel});
}

class _AddWorkerState extends State<AddWorker> {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();
  save()async{
    if(formKey.currentState!.validate()){
      await CompanyDB().addWorker(new WorkerModel(0, nameController.text, phoneController.text, widget.selectedModel!.id));
      Navigator.of(context).pop();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
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
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50, child: Text("الشركة ")),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 70,
                            child: TextFormField(
                              initialValue: widget.selectedModel!.name,
                              enabled: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50, child: Text("المندوب")),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 70,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: nameController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                // valueChanged(value);
                              },
                              validator: (value) {
                                if (value == "") {
                                  return "الاسم مطلوب";
                                } else if (value!.length < 3) {
                                  return "ادخل اسم صالح";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "المندوب",
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Text("رقمه"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 70,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: phoneController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                // valueChanged(value);
                              },
                              validator: (value) {
                                if (value == "") {
                                  return "الرقم مطلوب";
                                } else if (value!.length < 3) {
                                  return "ادخل رقم صالح";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "رقمه",
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }
}
