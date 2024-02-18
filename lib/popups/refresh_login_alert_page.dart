import 'package:flutter/material.dart';

import 'package:aetheric/services/auth/functions/auth.dart';
import 'package:aetheric/services/auth/elements/auth_button.dart';

// This page is shown when the user has to refresh their login
class RefreshLoginAlertPage extends StatefulWidget {
  const RefreshLoginAlertPage({super.key});

  @override
  State<RefreshLoginAlertPage> createState() => _RefreshLoginAlertPageState();
}

class _RefreshLoginAlertPageState extends State<RefreshLoginAlertPage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Please refresh your login',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Text(
            'For security reasons, the last login cannot be older than 5 minutes. Please login again by clicking the button below.',
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 64.0),
          AuthButton(
            text: 'Sign out',
            function: () => _auth.signOut().then((value) =>
                Navigator.popUntil(context, (route) => route.isFirst)),
          ),
        ],
      ),
    );
  }
}