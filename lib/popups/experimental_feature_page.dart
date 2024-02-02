import 'package:flutter/material.dart';

// This class is a placeholder for an experimental feature
class ExperimentalFeaturePage extends StatelessWidget {
  final String title;
  const ExperimentalFeaturePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "This is an placeholder page for '$title'.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
