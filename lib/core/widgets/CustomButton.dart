import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {required this.text, required this.color, super.key, this.onpressed});
  final String text;
  final Color color;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 110,
      child: TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: color),
          onPressed: onpressed ?? () {},
          child: Text(text)),
    );
  }
}
