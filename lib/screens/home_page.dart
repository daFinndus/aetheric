import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _buildEmptyPage(),
      ),
    );
  }

  _buildEmptyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_sharp,
          color: Theme.of(context).colorScheme.primary,
          size: 32.0,
        ),
        const SizedBox(height: 32.0),
        const Text('This page seems to be empty.'),
      ],
    );
  }
}
