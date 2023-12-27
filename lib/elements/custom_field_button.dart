import 'package:flutter/material.dart';

// A container which executes a function when pressed
// Mainly used on the settings page right now
class CustomFieldButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function function;

  const CustomFieldButton({
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
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}