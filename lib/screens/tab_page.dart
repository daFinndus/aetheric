import 'package:flutter/material.dart';

import 'package:aetheric/screens/chat_page.dart';
import 'package:aetheric/screens/home_page.dart';
import 'package:aetheric/screens/setting_page.dart';

class TabPage extends StatelessWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        bottomNavigationBar: _buildTabBar(),
        body: _buildTabBarView(),
      ),
    );
  }
}

Widget _buildTabBar() {
  return const TabBar(
    padding: EdgeInsets.all(8.0),
    tabs: [
      Tab(
        icon: Icon(Icons.chat),
        text: 'Chat',
      ),
      Tab(
        icon: Icon(Icons.home),
        text: 'Home',
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
      HomePage(),
      SettingPage(),
    ],
  );
}
