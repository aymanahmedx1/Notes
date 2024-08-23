import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CutomTextInput.dart';
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CustomTextInput(label: "label"),),);
  }
}
