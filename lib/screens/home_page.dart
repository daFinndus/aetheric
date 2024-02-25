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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('This page seems to be empty.'),
      ],
    );
  }
}
