import 'package:flutter/material.dart';
import 'package:notes/Commons/CutomTheme.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/screens/Accounting/AccountingScreen.dart';
import 'package:notes/screens/Company/CompanyProfileScreen.dart';
import 'package:notes/screens/Company/CompanyScreen.dart';
import 'package:notes/screens/LandingScreen.dart';
import 'package:notes/screens/TestScreen.dart';
import 'package:notes/scrollBehavior.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Appstart extends StatelessWidget {
  const Appstart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar', 'SA'), // Arabic, Saudi Arabia
      supportedLocales: const [
        Locale('ar', 'SA'), // Add any other RTL locales you want to support
        // Other supported locales...
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: Landingscreen(),
      routes: {
        Landingscreen.rout: (context) => Landingscreen(),
        CompanyScreen.rout: (context) => CompanyScreen(),
        CompanyProfileScreen.rout: (context) => CompanyProfileScreen(),
        Accountingscreen.rout: (context) => Accountingscreen(),
        "test": (context) => TestScreen(),

      },
    );
  }
}
