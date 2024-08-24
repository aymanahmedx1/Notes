import 'package:flutter/material.dart';

class CustomAutoComplete extends StatelessWidget {
  final List<String> options;

  final TextEditingController controller;
  final String label;

  const CustomAutoComplete(
      {required this.controller, required this.options, required this.label});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          onChanged: (value) => controller.text = value,
          controller: textEditingController,
          onEditingComplete: onFieldSubmitted,
          focusNode: focusNode,
          decoration: InputDecoration(label: Text(label)),
        );
      },
    );
  }
}
