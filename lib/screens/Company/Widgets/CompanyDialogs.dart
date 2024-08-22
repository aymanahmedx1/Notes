import 'package:flutter/material.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/CompanyDB.dart';

import '../../../Commons/Helpers.dart';
import '../../../CustomWidgets/CustomButton.dart';

class CompanyDialogs {
  final labelWidth = 100.00;
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController drugController = TextEditingController(text: "");
  final TextEditingController totalController = TextEditingController(text: "0");
  final TextEditingController noteController = TextEditingController(text: "");
  final TextEditingController outController = TextEditingController(text: "0");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();
  createOrUpdate(BuildContext context, CompanyModel? model) async {
    final TextEditingController companyNameController =
        TextEditingController(text: "");
    final TextEditingController noteController =
        TextEditingController(text: "");

    if (model != null) {
      companyNameController.text = model.name;
    }
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Directionality(
              textDirection: TextDirection.rtl, child: Text("اضافه شركة")),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: companyNameController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: "اسم شركة"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 70,
                  child: TextFormField(
                    controller: noteController,
                    enabled: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: "ملاحظة"),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(
              icon: Icons.save,
              onPressed: () async {
                if (model != null) {
                  model.name = companyNameController.text;
                  model.notes = noteController.text;
                  await CompanyDB().update(model);
                } else {
                  var m = CompanyModel(
                      id: 0,
                      name: companyNameController.text,
                      notes: noteController.text,
                      date: formattedDate());
                  await CompanyDB().add(m);
                }
                Navigator.of(context).pop("1");
              },
              text: "حفظ",
            )
          ],
        );
      },
    );
  }

  createWorkerDialog(BuildContext context ,CompanyModel selectedModel ,   WorkerModel? model)async {
   await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("اضافه مندوب"),
        content: SingleChildScrollView(
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
                        initialValue: selectedModel!.name,
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
                    await saveWorker(selectedModel,model);
                    Navigator.of(context).pop();
                  },
                  icon: Icons.save,
                  text: "حفظ",
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }


  saveWorker(CompanyModel selectedModel , WorkerModel? model) async {
    if (formKey.currentState!.validate()) {
      var toSave = WorkerModel(
          id: 0,
          name: nameController.text,
          phone: phoneController.text,
          company: selectedModel.id,
          note: noteController.text,
          out: outController.text,
          total: totalController.text,
          drug: drugController.text);
      if (model == null) {
        await CompanyDB().addWorker(toSave);
      } else {
        toSave.id = model.id;
        await CompanyDB().updateWorker(toSave);
      }
    }
  }
}
