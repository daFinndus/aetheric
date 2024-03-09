import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aetheric/services/app/features.dart';
import 'package:aetheric/elements/custom_text_field.dart';
import 'package:aetheric/elements/custom_text_button.dart';
import 'package:aetheric/services/auth/screens/data_birthday_page.dart';

class DataPersonalNamePage extends StatefulWidget {
  const DataPersonalNamePage({super.key});

  @override
  State<DataPersonalNamePage> createState() => _DataPersonalNamePageState();
}

class _DataPersonalNamePageState extends State<DataPersonalNamePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final preferences = SharedPreferences.getInstance();

  final AppFeatures _app = AppFeatures();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: SizedBox(
                width: SizerUtil.width,
                height: SizerUtil.height,
                child: ListView(
                  children: [
                    SizedBox(
                      width: SizerUtil.width,
                      height: SizerUtil.height * 0.875,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "What's your name?",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 64.0),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                CustomTextField(
                                  icon: Icons.person,
                                  hintText: 'First Name',
                                  isPassword: false,
                                  obscureText: false,
                                  controller: _firstNameController,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  icon: Icons.person_outline,
                                  hintText: 'Last Name',
                                  isPassword: false,
                                  obscureText: false,
                                  controller: _lastNameController,
                                ),
                                const SizedBox(height: 64.0),
                                CustomTextButton(
                                  text: 'Next',
                                  function: () => _saveDataAndNavigate(context),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, size: 16.0),
                          SizedBox(width: 8.0),
                          Text(
                            'This data is for internal use only',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16.0)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function for checking if the data is valid
  bool _checkData(String firstName, String lastName) {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return true;
    }
    return false;
  }

  // Save the data to local storage, then navigate to the next page
  _saveDataAndNavigate(BuildContext context) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    if (!_checkData(firstName, lastName)) {
      _app.showErrorFlushbar(context, 'Please enter your data');
      return;
    }

    firstName = _app.capitalizeName(_firstNameController.text);
    lastName = _app.capitalizeName(_lastNameController.text);

    await preferences.then((pref) {
      pref.setString('firstName', firstName);
      pref.setString('lastName', lastName);
    });

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DataBirthdayPage()),
      );
    }
  }
}
