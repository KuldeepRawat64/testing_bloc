// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testing_bloc_course/strings.dart' show enterYourPasswordHere;

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordTextField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      obscureText: true,
      controller: passwordController,
      decoration: const InputDecoration(
        hintText: enterYourPasswordHere,
      ),
    );
  }
}
