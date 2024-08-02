import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_services.dart';
import 'package:messaging_app/commons/MyBtn.dart';
import 'package:messaging_app/commons/MyTextField.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final void Function() loginTap;
  RegisterPage({super.key, required this.loginTap});

//function

  void register(BuildContext context) {
    final auth = AuthServices();
    if (pwController.text == confirmPwController.text) {
      try {
        auth.registerWithEmailAndPassword(
            nameController.text, mailController.text, pwController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password confirm incrrect"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's Create Account...!!!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),

              Gap(24),
              MyTextField(
                myController: nameController,
                obscureText: false,
                hintText: "Name",
              ),
              Gap(24),
              MyTextField(
                myController: mailController,
                obscureText: false,
                hintText: "Email",
              ),
              Gap(24),
              MyTextField(
                myController: pwController,
                obscureText: true,
                hintText: "Password",
              ),
              Gap(24),
              MyTextField(
                myController: confirmPwController,
                obscureText: true,
                hintText: "Confirm Password",
              ),
              Gap(24),

              //login
              MyBtn(
                myText: "Register",
                onTap: () => register(context),
              ),
              //register

              Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already memeber? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: loginTap,
                    child: Text(
                      "Login Now.",
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
      ),
    );
  }
}
