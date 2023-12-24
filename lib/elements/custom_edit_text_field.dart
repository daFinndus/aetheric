import 'package:flutter/material.dart';

class CustomEditTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  const CustomEditTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).primaryColor,
      ),
      child: TextField(
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          iconColor: Theme.of(context).colorScheme.onPrimary,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          border: InputBorder.none,
          icon: Icon(icon),
          hintText: hintText,
        ),
      ),
    );
  }
}
