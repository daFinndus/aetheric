import 'package:flutter/material.dart';

// A custom designed button widget
class CustomButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color color;

  const CustomButton({
    super.key,
    required this.text,
    required this.function,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 64.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: TextButton(
        onPressed: () => function(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color == Theme.of(context).colorScheme.onPrimary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
