import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CutomTextInput.dart';

Future<String> getDate(BuildContext context, String? currentDate) async {
  var date = DateTime.now();
  currentDate ??= "${date.year}-${date.month}-${date.day}";
  var current = convertDate(currentDate);
  DateTime? selected = await showDatePicker(
    context: context,
    firstDate: DateTime(date.year - 20, date.month, date.day),
    lastDate: DateTime(date.year + 20, date.month, date.day),
    initialDate: current,
  );
  selected ??= DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(selected);
  return formattedDate;
}

convertDate(String date) {
  try {
    DateTime current = DateTime.parse(date);
    return current;
  } catch (e) {
    return DateTime.now();
  }
}

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  CustomDatePicker({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String selected = await getDate(context, controller.text);
        controller.text = selected;
      },
      child: CustomTextInput(
        onTab: () async {
          String selected = await getDate(context, controller.text);
          controller.text = selected;
        },
        enabled: true,
        label: label,
        controller: controller,
        textInputType: TextInputType.datetime,
      ),
    );
  }
}
