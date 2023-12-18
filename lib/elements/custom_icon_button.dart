import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String tooltip;
  final Icon icon;
  final Function function;

  const CustomIconButton(
      {super.key,
      required this.tooltip,
      required this.icon,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => function,
      icon: icon,
      tooltip: tooltip,
    );
  }
}
