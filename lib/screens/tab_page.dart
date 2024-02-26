import 'dart:io';
import 'package:flutter/material.dart';

import 'package:aetheric/screens/chat_page.dart';
import 'package:aetheric/screens/setting_page.dart';

class TabPage extends StatelessWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        bottomNavigationBar: _buildTabBar(),
        body: _buildTabBarView(),
      ),
    );
  }
}

Widget _buildTabBar() {
  return TabBar(
    padding: EdgeInsets.only(
      top: 8.0,
      left: 16.0,
      right: 16.0,
      bottom: Platform.isIOS ? 32.0 : 8.0,
    ),
    tabs: const [
      Tab(
        icon: Icon(Icons.chat),
        text: 'Chat',
      ),
      Tab(
        icon: Icon(Icons.settings),
        text: 'Settings',
      ),
    ],
  );
}

Widget _buildTabBarView() {
  return const TabBarView(
    children: [
      ChatPage(),
      SettingPage(),
    ],
  );
}
