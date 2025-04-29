import 'package:flutter/material.dart';
import 'package:notes/Commons/CutomTheme.dart';
import 'package:notes/screens/Accounting/AccountingScreen.dart';
import 'package:notes/screens/BackupAndRestoreHome.dart';
import 'package:notes/screens/Company/CompanyFinishScreen.dart';
import 'package:notes/screens/Company/CompanyProfileScreen.dart';
import 'package:notes/screens/Company/CompanyScreen.dart';
import 'package:notes/screens/Company/MovementsScreen.dart';
import 'package:notes/screens/LandingScreen.dart';
import 'package:notes/screens/LoginScreen.dart';
import 'package:notes/screens/MoneyTransactions/MoneyTransactionScreen.dart';
import 'package:notes/screens/PersonalAccounting/PersonalAccountingScreen.dart';
import 'package:notes/scrollBehavior.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Appstart extends StatelessWidget {
  const Appstart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar', 'SA'),
      // Arabic, Saudi Arabia
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



      home: LoginScreen(),
      routes: {
        Landingscreen.rout: (context) => Landingscreen(),
        CompanyScreen.rout: (context) => CompanyScreen(),
        CompanyProfileScreen.rout: (context) => CompanyProfileScreen(),
        CompanyFinishScreen.rout: (context) => CompanyFinishScreen(),
        Accountingscreen.rout: (context) => Accountingscreen(),
        Moneytransactionscreen.rout: (context) => Moneytransactionscreen(),
        Movementsscreen.rout: (context) => Movementsscreen(),
        PersonalAccountingscreen.rout: (context) => PersonalAccountingscreen(),
        LoginScreen.rout: (context) => LoginScreen(),
        BackupAndRestoreHome.rout: (context) => BackupAndRestoreHome(),
      },
    );
  }
}
