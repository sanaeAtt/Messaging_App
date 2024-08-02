import 'package:flutter/material.dart';
import 'package:messaging_app/screens/RegisterPage.dart';
import 'package:messaging_app/screens/loginPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        registeTap: togglePages,
      );
    } else {
      return RegisterPage(
        loginTap: togglePages,
      );
    }
  }
}
