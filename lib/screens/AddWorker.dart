import 'package:flutter/material.dart';

class AddWorker extends StatelessWidget {
  final TextEditingController companyController =
      TextEditingController(text: "");

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
                SizedBox(height: 30,),
                Row(
                  children: [
                    Container(
                      width: 300,
                      height: 50,
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
                          hintText: "الشركه",
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
                SizedBox(height: 10,),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 300,
                          height: 50,
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
                              hintText: "المندوب",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        Container(
                          width: 300,
                          height: 50,
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
                              hintText: "رقمه",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 3)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Scrollbar( /// Scroll Bar
                    trackVisibility: true, // SHow
                    interactive: true, // Interact
                    thickness: 10, // Width Of Scroll bar
                    thumbVisibility: true, // show all time
                    child: SingleChildScrollView( // scroll list
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Container(
                            width: double.infinity,
                            child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'الادويه',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

                                ],
                                rows:
                                List.generate(5, (index) {
                                  return  DataRow(
                                    onLongPress: () {


                                    },
                                    color:  WidgetStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                      // Color for the row
                                      return index % 2 == 0 ? Colors.grey.shade200 : Colors.white;
                                    }),
                                    cells: <DataCell>[
                                      DataCell(Text('علاج')),
                                    ],
                                  );
                                },)

                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
