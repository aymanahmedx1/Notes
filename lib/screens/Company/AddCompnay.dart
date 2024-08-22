import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/CompanyDB.dart';

class AddCompnay extends StatelessWidget {

  final TextEditingController companyController =
      TextEditingController(text: "");
  final TextEditingController noteController = TextEditingController(text: "");
  final ScrollController controller = ScrollController();
  late final CompanyModel? company ;
  saveCompany() async {
    if (companyController.text != "") {
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.year}-${currentDate.month}-${currentDate.day}";
      var m = CompanyModel(0, companyController.value.text,
          noteController.value.text, formattedDate);
     if(company == null){
       await CompanyDB().add(m);
     }else{
       m.id = company!.id ;
       await CompanyDB().update(m);
     }
    }
  }
  AddCompnay({this.company}){
      if(company!=null){
        companyController.text = this.company!.name ;
        noteController.text = this.company!.notes ;
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
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "اضافه شركة",
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
                SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            hintText: "اسم الشركة",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
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
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: noteController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: (value) {
                            // valueChanged(value);
                          },
                          validator: (value) {},
                          decoration: InputDecoration(
                            hintText: "ملاحظه",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
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
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 10)),
                            onPressed: () async {
                              await saveCompany();
                              Navigator.of(context).pop();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.save),
                                Text("حفظ"),
                              ],
                            )),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
