import 'package:flutter/material.dart';

// This is the widget that's used in our profile page
// It displays the user's information in a nice way
class CustomProfileTextBox extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String labelText;
  final bool readOnly;
  final bool obscureText;

  const CustomProfileTextBox({
    super.key,
    required this.icon,
    required this.hintText,
    required this.labelText,
    required this.readOnly,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8.0),
          Text(hintText, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(': $labelText')
        ],
      ),
    );
  }
}
