import 'package:flutter/material.dart';

// A custom button with an important color (red)
class CustomFieldButtonImportant extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function function;

  const CustomFieldButtonImportant({
    super.key,
    required this.icon,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        height: 48.0,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.red,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
