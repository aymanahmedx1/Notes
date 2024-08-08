import 'package:flutter/material.dart';
import 'package:notes/screens/workers.dart';
import 'package:notes/scrollBehavior.dart';
class Appstart extends StatelessWidget {
  const Appstart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Workers()));
  }
}
