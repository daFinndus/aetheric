import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

// This class has some app features that are used in multiple places
class AppFeatures {
  // Function for capitalizing and splitting names (if needed)
  String capitalizeName(String name) {
    List<String> names = name.split(" ");
    for (int i = 0; i < names.length; i++) {
      names[i] = names[i][0].toUpperCase() + names[i].substring(1);
    }
    return names.join(" ");
  }

  // Function for showing a bottom sheet
  showBottomSheet(BuildContext context, page) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return page;
      },
    );
  }

  // Function for showing a flushbar in green
  showSuccessFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.only(right: 16.0, bottom: 24.0, left: 16.0),
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: const Color.fromARGB(255, 30, 145, 50),
    ).show(context);
  }

  // Function for showing a flushbar in red
  showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.only(right: 16.0, bottom: 24.0, left: 16.0),
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: const Color.fromARGB(255, 230, 50, 50),
    ).show(context);
  }
}
