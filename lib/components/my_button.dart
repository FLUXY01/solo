import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const MyButton({super.key, required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF4A148C),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title,style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          ),
        ),
      ),
    );
  }
}
