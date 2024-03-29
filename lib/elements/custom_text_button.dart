import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

// A custom designed button widget
class CustomTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function function;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          width: SizerUtil.width,
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
      },
    );
  }
}
