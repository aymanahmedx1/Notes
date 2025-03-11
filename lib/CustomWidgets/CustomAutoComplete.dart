import 'dart:developer';

import 'package:flutter/material.dart';

class CustomAutoComplete extends StatelessWidget {
  final List<String> options;

  final TextEditingController controller;
  final String label;
  final void Function(String? value)? valueChange;
  final String? initValue;

  const CustomAutoComplete(
      {required this.controller,
      required this.options,
      required this.label,
      this.valueChange,
      this.initValue});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initValue ?? ""),
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text= (selection);
        if (valueChange != null) {
          valueChange!(selection);
        }
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          onChanged: (value) {
            controller.text = value;
            if (valueChange != null) {
              valueChange!(value);
            }
          },
          controller: textEditingController,
          onEditingComplete: onFieldSubmitted,
          focusNode: focusNode,
          decoration: InputDecoration(
            label: Text(label),
            suffixIcon: IconButton(
                onPressed: () {
                  if (valueChange != null) (valueChange!(""));
                  textEditingController.text = "";
                  focusNode.unfocus();
                  controller.text = "";
                },
                icon: const Icon(Icons.highlight_remove_outlined)),
          ),
        );
      },
    );
  }
}
