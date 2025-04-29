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
    // Get the screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final tileSize = isSmallScreen ? 140.0 : 180.0;
    final spacing = isSmallScreen ? 5.0 : 10.0;

    // Create a menu tile widget for reuse
    Widget menuTile({
      required Color color,
      required String title,
      required IconData icon,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: color,
          width: tileSize,
          height: tileSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 24 : 30,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Make the app bar responsive
    final appBar = AppBar(
      title: const Text("الرئيسية"),
      actions: isSmallScreen
          ? [
        // For small screens, show a menu button that opens a dropdown
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'backup') {
              Navigator.pushNamed(context, BackupAndRestoreHome.rout);
            } else if (value == 'password') {
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
            } else if (value == 'logout') {
              Navigator.pushReplacementNamed(context, LoginScreen.rout);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'backup',
              child: Row(
                children: [
                  Icon(Icons.backup, size: 20),
                  SizedBox(width: 8),
                  Text("النسخ الاحتياطي والاستعادة"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'password',
              child: Row(
                children: [
                  Icon(Icons.password, size: 20),
                  SizedBox(width: 8),
                  Text("تغيير الرقم السري"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text("خروج"),
                ],
              ),
            ),
          ],
        ),
      ]
          : [
        // For larger screens, show all buttons
        CustomButton(
            text: "النسخ الاحتياطي والاستعادة",
            onPressed: () {
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
        CustomButton(
            text: "خروج",
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.rout);
            },
            icon: Icons.logout)
      ],
    );

    // Create menu grid based on screen size
    Widget menuGrid() {
      if (isSmallScreen) {
        // Single column layout for small screens
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            menuTile(
              color: Colors.green,
              title: "المندوبين",
              icon: Icons.person,
              onTap: () {
                Navigator.pushNamed(context, CompanyScreen.rout);
              },
            ),
            SizedBox(height: spacing),
            menuTile(
              color: Colors.blue,
              title: "الاقسام",
              icon: Icons.edit_calendar,
              onTap: () {
                Navigator.pushNamed(context, Accountingscreen.rout);
              },
            ),
            SizedBox(height: spacing),
            menuTile(
              color: Colors.teal,
              title: "حركة الاموال",
              icon: Icons.money_off,
              onTap: () {
                Navigator.pushNamed(context, Moneytransactionscreen.rout);
              },
            ),
            SizedBox(height: spacing),
            menuTile(
              color: Colors.deepOrange,
              title: "حسابات شخصية",
              icon: Icons.money_off,
              onTap: () {
                Navigator.pushNamed(context, PersonalAccountingscreen.rout);
              },
            ),
          ],
        );
      } else if (screenWidth < 900) {
        // 2x2 grid for medium screens
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                menuTile(
                  color: Colors.green,
                  title: "المندوبين",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, CompanyScreen.rout);
                  },
                ),
                SizedBox(width: spacing),
                menuTile(
                  color: Colors.blue,
                  title: "الاقسام",
                  icon: Icons.edit_calendar,
                  onTap: () {
                    Navigator.pushNamed(context, Accountingscreen.rout);
                  },
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                menuTile(
                  color: Colors.teal,
                  title: "حركة الاموال",
                  icon: Icons.money_off,
                  onTap: () {
                    Navigator.pushNamed(context, Moneytransactionscreen.rout);
                  },
                ),
                SizedBox(width: spacing),
                menuTile(
                  color: Colors.deepOrange,
                  title: "حسابات شخصية",
                  icon: Icons.money_off,
                  onTap: () {
                    Navigator.pushNamed(context, PersonalAccountingscreen.rout);
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        // Single row for very large screens
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            menuTile(
              color: Colors.green,
              title: "المندوبين",
              icon: Icons.person,
              onTap: () {
                Navigator.pushNamed(context, CompanyScreen.rout);
              },
            ),
            SizedBox(width: spacing),
            menuTile(
              color: Colors.blue,
              title: "الاقسام",
              icon: Icons.edit_calendar,
              onTap: () {
                Navigator.pushNamed(context, Accountingscreen.rout);
              },
            ),
            SizedBox(width: spacing),
            menuTile(
              color: Colors.teal,
              title: "حركة الاموال",
              icon: Icons.money_off,
              onTap: () {
                Navigator.pushNamed(context, Moneytransactionscreen.rout);
              },
            ),
            SizedBox(width: spacing),
            menuTile(
              color: Colors.deepOrange,
              title: "حسابات شخصية",
              icon: Icons.money_off,
              onTap: () {
                Navigator.pushNamed(context, PersonalAccountingscreen.rout);
              },
            ),
          ],
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(isSmallScreen ? 10 : 20),
          child: SingleChildScrollView(
            child: menuGrid(),
          ),
        ),
      ),
    );
  }
}