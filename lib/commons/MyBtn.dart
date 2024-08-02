import 'package:flutter/material.dart';

class MyBtn extends StatelessWidget {
  final void Function()? onTap;
  final String myText;
  const MyBtn({super.key, required this.myText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(myText),
        ),
      ),
    );
  }
}
