import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

class AppFeatures {
  // Function for capitalizing and splitting names (if needed)
  String capitalizeName(String name) {
    List<String> names = name.split(" ");
    for (int i = 0; i < names.length; i++) {
      names[i] = names[i][0].toUpperCase() + names[i].substring(1);
    }
    return names.join(" ");
  }

  // Function for pushing to another page
  pagePush(BuildContext context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: const Color.fromARGB(255, 29, 130, 1),
    ).show(context);
  }

  // Function for showing a flushbar in red
  showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8.0),
      backgroundColor: const Color.fromARGB(255, 230, 50, 50),
    ).show(context);
  }
}
