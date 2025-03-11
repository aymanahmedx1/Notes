import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomDatePicker.dart';
import 'package:notes/CustomWidgets/CutomTextInput.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/data/CompanyDB.dart';
import 'package:provider/provider.dart';

import '../../../Commons/Helpers.dart';
import '../../../CustomWidgets/CustomAutoComplete.dart';
import '../../../CustomWidgets/CustomButton.dart';

class CompanyDialogs {
  final labelWidth = 100.00;
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController drugController = TextEditingController(text: "");
  final TextEditingController totalController = TextEditingController(text: "");
  final TextEditingController noteController = TextEditingController(text: "");
  final TextEditingController outController = TextEditingController(text: "0");
  final TextEditingController dateController = TextEditingController(text: "");
  final TextEditingController expController = TextEditingController(text: "");
  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();

  createOrUpdate(BuildContext context, CompanyModel? model) async {
    final TextEditingController companyNameController =
        TextEditingController(text: "");
    final TextEditingController noteController =
        TextEditingController(text: "");
    String title = "اضافة شركة";
    if (model != null) {
      companyNameController.text = model.name;
      noteController.text = model.notes;
      title = "تعديل شركة"  ;
    }
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextInput(
                  label: "اسم شركة",
                  controller: companyNameController,
                ),
                heightSizedBox,
                CustomTextInput(
                  label: "ملاحظة ",
                  controller: noteController,
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
                  Provider.of<CompanyProvider>(context, listen: false)
                      .updateCompany(model);
                } else {
                  var m = CompanyModel(
                      id: 0,
                      name: companyNameController.text,
                      notes: noteController.text,
                      date: formattedDate());
                  Provider.of<CompanyProvider>(context, listen: false)
                      .addCompany(m);
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

  createWorkerDialog(BuildContext context, CompanyModel companyModel,
      WorkerModel? workerModel) async {
    if (workerModel != null) {
      nameController.text = workerModel.name;
      phoneController.text = workerModel.phone;
      drugController.text = workerModel.drug;
      totalController.text = workerModel.total.toString();
      noteController.text = workerModel.note;
      // outController.text = workerModel.out.toString();
      dateController.text = workerModel.date;
      expController.text = workerModel.expDate;
      priceController.text = workerModel.price.toString();
    } else {
      dateController.text = formattedDate();
    }
    List<String> names= List.from(await CompanyDB().getAllWorkerNames(companyModel.id));
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اضافة مندوب"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextInput(
                    width: 1000,
                    label: 'الشركة',
                    controller: TextEditingController(text: companyModel.name),
                    enabled: false,
                  ),
                  heightSizedBox,
                  CustomAutoComplete(
                    label: 'المندوب',
                    controller: nameController,
                    options:names,
                    valueChange: (value) async{
                      if(value!=null){
                        phoneController.text= await CompanyDB().getWorkerPhoneByName(value);
                      }
                    },
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'رقمه',
                    controller: phoneController,
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'المنتجات',
                    controller: drugController,
                    validateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == "") {
                        return "ادخل اسم صالح";
                      }
                      return null;
                    },
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'العدد الكلي',
                    controller: totalController,
                    textInputType: TextInputType.number,
                    validateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرقم مطلوب";
                      } else if (int.tryParse(value) == null) {
                        return "ادخل رقم صالح";
                      } else if (int.parse(value) < 1) {
                        return "ادخل رقم صالح";
                      }
                      return null;
                    },
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'العدد المصروف',
                    controller: outController,
                    textInputType: TextInputType.number,
                    validateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null) {
                        if ((int.tryParse(value) ?? 0) >
                            (int.tryParse(totalController.text) ?? 0)) {
                          return "الرقم المصروف يجب ان يكون اصغر من الكلي";
                        }else if(workerModel!=null && (int.tryParse(value) !=null ) && (int.parse(value) + workerModel.out ) > workerModel.total  ){
                          return "الرقم المصروف يجب ان يكون اصغر من الكلي";
                        }
                      }
                      return null;
                    },
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'السعر ',
                    controller: priceController,
                    textInputType: TextInputType.number,
                    validateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null) {

                      }
                      return null;
                    },
                  ),
                  heightSizedBox,
                  CustomTextInput(
                    label: 'ملاحظة',
                    controller: noteController,
                  ),
                  heightSizedBox,
                  CustomDatePicker(
                    controller: dateController,
                    label: "التاريخ",
                  ),
                  heightSizedBox,
                  CustomDatePicker(
                    controller: expController,
                    label: "اكسباير",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 300,
                    child: CustomButton(
                      onPressed: () {
                        bool res =
                            saveWorker(context, companyModel, workerModel);
                        if (res) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icons.save,
                      text: "حفظ",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool saveWorker(
      BuildContext context, CompanyModel selectedModel, WorkerModel? model) {
    if (formKey.currentState!.validate()) {
      var toSave = WorkerModel(
          id: 0,
          name: nameController.text,
          phone: phoneController.text,
          company: selectedModel.id,
          note: noteController.text,
          out: int.parse(outController.text),
          total: int.parse(totalController.text),
          drug: drugController.text,
          date: dateController.text,
          expDate: expController.text,
          finish: 0,
          price: double.parse(priceController.text)
      );
      if (model == null) {
        Provider.of<CompanyProvider>(context, listen: false).saveWorker(toSave);
      } else {
        toSave.id = model.id;
        Provider.of<CompanyProvider>(context, listen: false)
            .updateWorker(toSave);
      }
      return true;
    } else {
      return false;
    }
  }

  var heightSizedBox = const SizedBox(
    height: 15,
  );
}
