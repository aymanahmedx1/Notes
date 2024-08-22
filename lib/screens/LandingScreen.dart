import 'package:flutter/material.dart';
import 'package:notes/Commons/AppDrawer.dart';
import 'package:notes/screens/Accounting/AccountingScreen.dart';
import 'package:notes/screens/MoneyTransactionScreen.dart';
import 'package:notes/screens/Company/CompanyScreen.dart';
import 'package:notes/screens/TestScreen.dart';

class Landingscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("الرئيسيه"),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.green,
                    width: 200,
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "المندوبين",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Accountingscreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    width: 200,
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "الحسابات",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.person,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Moneytransactionscreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.teal,
                    width: 200,
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "حركة الاموال",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  color: Colors.teal,
                  width: 200,
                  height: 200,
                  // child: InkWell(
                  //     onTap: () {
                  //       // Navigator.push(
                  //       //     context,
                  //       //     MaterialPageRoute(
                  //       //         builder: (context) => TestScreen()));
                  //     },
                  //     child: Text(
                  //       "حركة الاموال",
                  //     )),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
