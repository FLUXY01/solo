import 'package:flutter/material.dart';
class MyEmailField extends StatelessWidget {
  final String hintText;
  final bool isObsecureText;
  final TextEditingController controller;
  const MyEmailField(
  {super.key,required this.hintText, required this.isObsecureText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObsecureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderSide: BorderSide(),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
      ),
    );
  }
}
