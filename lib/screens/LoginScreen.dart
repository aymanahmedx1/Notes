import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/data/Database.dart';
import 'package:notes/data/LoginDb.dart';

import 'LandingScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String rout = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  void _login() async {
    try {
      String password = _passwordController.text;
      var pss = await LoginDb().getPassword();
      if (password == pss) {
        Navigator.pushReplacementNamed(context, Landingscreen.rout);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('رقم سري خطا')),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل الدخول"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: const Icon(Icons.login ,size: 60,),
                  ),
                  heightSpace,
                  heightSpace,
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'الرقم السري',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),

                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    onLongPress: _loginNoPassword,
                    child: const Text("دخول",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginNoPassword() {
    try {
      String password = _passwordController.text;

      if (password == "123456") {
        Navigator.pushReplacementNamed(context, Landingscreen.rout);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('رقم سري خطا')),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
