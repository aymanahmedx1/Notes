import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/screens/Accounting/AccountingScreen.dart';
import 'package:notes/screens/MoneyTransactions/MoneyTransactionScreen.dart';
import 'package:notes/screens/Company/CompanyScreen.dart';
import 'package:notes/screens/PersonalAccounting/PersonalAccountingScreen.dart';

class Landingscreen extends StatelessWidget {
  static const String rout = "LandingScreen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسيه"),
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
