import 'package:flutter/material.dart';

class TaskComponents extends StatelessWidget {
  const TaskComponents(
      {required this.title,
      required this.hintText,
      this.controller,
      this.icon,
      this.readOnly = false,
      this.validator,
      super.key});
  final TextEditingController? controller;

  final String title;
  final String hintText;
  final Widget? icon;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          validator: validator,
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: icon),
        ),
      ],
    );
  }
}
