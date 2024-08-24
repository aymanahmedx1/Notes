import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  double? width = 300;
  double? height = 70;
  bool? enabled = true;
  TextInputType? textInputType =  TextInputType.text ;
  final String label;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? valueChange;
  final void Function()? onTab;
  AutovalidateMode? validateMode = AutovalidateMode.disabled;
  TextEditingController? controller = TextEditingController(text: "");

  CustomTextInput({this.width,
    this.height,
    this.validator,
    this.validateMode,
    this.controller,
    this.enabled,
    this.textInputType,
    this.valueChange,
    this.onTab,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        onChanged: valueChange,
        onTap: onTab,
        textDirection: TextDirection.rtl,
        controller: controller,
        validator: validator,
        enabled:enabled,
        autovalidateMode: validateMode,
        keyboardType: textInputType,
        decoration: InputDecoration(
            label: Text(label),
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        textAlign: TextAlign.center,
      ),
    );
  }
}
