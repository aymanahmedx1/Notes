import 'package:flutter/material.dart';
import 'package:notes/Commons/CutomTheme.dart';
import 'package:notes/screens/LandingScreen.dart';
import 'package:notes/scrollBehavior.dart';

class Appstart extends StatelessWidget {
  const Appstart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        home: Directionality(
            textDirection: TextDirection.rtl, child: Landingscreen()));
  }
}
