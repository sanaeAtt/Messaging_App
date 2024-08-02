import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_services.dart';
import 'package:messaging_app/commons/MyBtn.dart';
import 'package:messaging_app/commons/MyTextField.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  final void Function() registeTap;
  final TextEditingController mailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  LoginPage({super.key, required this.registeTap});

//function
  void login(BuildContext context) async {
    //quthService
    final authServices = AuthServices();
    //tryLogin
    try {
      await authServices.signInWithEmailAndPassword(
          mailController.text, pwController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcom Back...!!!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Gap(24),
            MyTextField(
              myController: mailController,
              obscureText: false,
              hintText: "email",
            ),
            Gap(24),
            MyTextField(
              myController: pwController,
              obscureText: true,
              hintText: "password",
            ),
            Gap(24),

            //login
            MyBtn(
              myText: "Login",
              onTap: () => login(context),
            ),
            //register

            Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: registeTap,
                  child: Text(
                    "Register Now.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
