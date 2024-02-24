import 'package:aetheric/services/auth/screens/data_username_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/elements/custom_text_button.dart';

class DataBirthdayPage extends StatefulWidget {
  const DataBirthdayPage({super.key});

  @override
  State<DataBirthdayPage> createState() => _DataBirthdayPageState();
}

class _DataBirthdayPageState extends State<DataBirthdayPage> {
  DateTime _date = DateTime(1999, 1, 1);

  final preference = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 72.0),
          Text(
            'When were you born?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'Other users are able to see this information',
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 64.0),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime(1999, 1, 1),
              onDateTimeChanged: (DateTime newDate) {
                debugPrint(newDate.toString());
                setState(() {
                  _date = DateTime(newDate.year, newDate.month, newDate.day);
                });
              },
            ),
          ),
          const SizedBox(height: 64.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Text(
                  'You should be around ${_calculateAge().toString()} years old, right?',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomButton(
                  text: 'Approve and continue',
                  function: () => _saveDataAndNavigate(context),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculating age of user based on month and year
  int _calculateAge() {
    DateTime current = DateTime.now();
    DateTime birthday = _date;

    int age = current.year - birthday.year;
    if (current.month < birthday.month) {
      age--;
    }

    return age;
  }

  _saveDataAndNavigate(BuildContext context) async {
    preference.then((pref) => {
          pref.setString('birthday', _date.toString()),
        });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DataUsernamePage()),
    );
  }
}
