// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testing_bloc_course/strings.dart' show enterYourEmailHere;

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
