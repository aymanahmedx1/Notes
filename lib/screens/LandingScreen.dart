import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/data/LoginDb.dart';
import 'package:notes/screens/Accounting/AccountingScreen.dart';
import 'package:notes/screens/BackupAndRestoreHome.dart';
import 'package:notes/screens/LoginScreen.dart';
import 'package:notes/screens/MoneyTransactions/MoneyTransactionScreen.dart';
import 'package:notes/screens/Company/CompanyScreen.dart';
import 'package:notes/screens/PersonalAccounting/PersonalAccountingScreen.dart';

import '../CustomWidgets/CutomTextInput.dart';
import '../data/Database.dart';

class Landingscreen extends StatelessWidget {
  static const String rout = "LandingScreen";
  final TextEditingController passwordController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسيه"),
        actions: [
          CustomButton(
              text: "النسخ الاحتياطي والاستعادة",
              onPressed: ()  {
                Navigator.pushNamed(context, BackupAndRestoreHome.rout);
              },
              icon: Icons.backup),
          widthSpace,
          CustomButton(
              text: "تغيير الرقم السري",
              onPressed: () async {
                await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("تغيير الرقم السري"),
                      content: CustomTextInput(
                        label: "الرقم الجديد ",
                        controller: passwordController,
                      ),
                      actions: [
                        CustomButton(
                          icon: Icons.save,
                          onPressed: () async {
                            await LoginDb()
                                .updatePassword(passwordController.text);
                            Navigator.of(context).pop();
                          },
                          text: "حفظ",
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icons.password),
          widthSpace,
          CustomButton(text: "خروج", onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.rout);
          }, icon: Icons.logout  )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CompanyScreen.rout);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.green,
                    width: 200,
                    height: 200,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "المندوبين",
                          style: TextStyle(color: Colors.white),
                        ),
                        widthSpace,
                        Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Accountingscreen.rout);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    width: 200,
                    height: 200,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "الاقسام",
                          style: TextStyle(color: Colors.white),
                        ),
                        widthSpace,
                        Icon(
                          Icons.edit_calendar,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Moneytransactionscreen.rout);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.teal,
                    width: 200,
                    height: 200,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "حركة الاموال",
                          style: TextStyle(color: Colors.white),
                        ),
                        widthSpace,
                        Icon(
                          Icons.money_off,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PersonalAccountingscreen.rout);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.deepOrange,
                    width: 200,
                    height: 200,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "حسابات شخصية",
                          style: TextStyle(color: Colors.white),
                        ),
                        widthSpace,
                        Icon(
                          Icons.money_off,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
