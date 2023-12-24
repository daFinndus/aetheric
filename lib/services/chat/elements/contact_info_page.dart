import 'package:flutter/material.dart';

class ContactInfoPage extends StatelessWidget {
  final String name;
  final String status;
  final String imageUrl;

  const ContactInfoPage({
    super.key,
    required this.name,
    required this.status,
    required this.imageUrl,
  });

  // TODO: Make place for contact info
  // TODO: Should contain name, image, status, date since met, etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Info',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
          ),
        ),
      ),
    );
  }
}
