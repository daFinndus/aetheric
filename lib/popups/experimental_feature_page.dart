import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

// This class is a placeholder for an experimental feature
class ExperimentalFeaturePage extends StatelessWidget {
  const ExperimentalFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          width: SizerUtil.width,
          height: SizerUtil.height * 0.25,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 32.0,
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    'This feature is still under development.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
