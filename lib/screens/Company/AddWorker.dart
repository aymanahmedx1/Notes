import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/Models/CompanyModel.dart';

import '../../data/CompanyDB.dart';

class AddWorker extends StatefulWidget {
  @override
  State<AddWorker> createState() => _AddWorkerState();
  CompanyModel? selectedModel;
  WorkerModel? model;

  AddWorker({required this.selectedModel, this.model});
}

class _AddWorkerState extends State<AddWorker> {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController drugController = TextEditingController(text: "");
  final TextEditingController totalController = TextEditingController(text: "0");
  final TextEditingController noteController = TextEditingController(text: "");
  final TextEditingController outController = TextEditingController(text: "0");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();
  final labelWidth = 100.00;

  save() async {
    if (formKey.currentState!.validate()) {
      var toSave = WorkerModel(
          id: 0,
          name: nameController.text,
          phone: phoneController.text,
          company: widget.selectedModel!.id,
          note: noteController.text,
          out: outController.text,
          total: totalController.text,
          drug: drugController.text);
      if (widget.model == null) {
        await CompanyDB().addWorker(toSave);
        Navigator.of(context).pop();
        log("Saved");
      } else {
        toSave.id = widget.model!.id;
        await CompanyDB().updateWorker(toSave);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      phoneController.text = widget.model!.phone;
      noteController.text = widget.model!.note;
      outController.text = widget.model!.out;
      totalController.text = widget.model!.total;
      drugController.text = widget.model!.drug;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:const Text("اضافة مندوب"),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: labelWidth, child: Text("الشركة ")),
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
                            keyboardType: TextInputType.text,
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
                        SizedBox(
                            width: labelWidth, child: Text("المندوب")),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            ),
                          ),
                        ),
                      ],
                    ), // Name Row
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: labelWidth,
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
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            decoration: const InputDecoration(
                              hintText: "رقمه",
                            ),
                          ),
                        ),
                      ],
                    ), // Phone
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: labelWidth,
                            child: const Text("الادوية")),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: drugController,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              // valueChanged(value);
                              //
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
                              hintText: "الادوية",
                            ),
                          ),
                        ),
                      ],
                    ), //Drug
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: labelWidth,
                            child: Text("العدد الكلي")),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: totalController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "العدد الكلي",
                            ),
                          ),
                        ),
                      ],
                    ), // Total
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: labelWidth,
                            child: const Text("العدد المصروف")),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: outController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "العدد المصروف",
                            ),
                          ),
                        ),
                      ],
                    ), // out
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: labelWidth, child: Text("ملاحظة")),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: noteController,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              // valueChanged(value);
                              //
                            },
                            validator: (value) {
                              if (value == "") {
                                return "الاسم مطلوب";
                              } else if (value!.length < 3) {
                                return "ادخل اسم صالح";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "ملاحظة",
                            ),
                          ),
                        ),
                      ],
                    ), //notes
                    const SizedBox(
                      height: 50,
                    ),
                   CustomButton(
                     onPressed: ()async{
                       await save();
                     },
                     icon: Icons.save,
                     text: "حفظ",
                   ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
