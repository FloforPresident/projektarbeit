import 'package:flutter/material.dart';

import 'robos.dart';
import 'friends.dart';
import 'rooms.dart';
import 'messages.dart';
import 'control.dart';

class AppNavBarController extends StatefulWidget {
  @override
  _AppNavBarControllerState createState() => _AppNavBarControllerState();
}

class _AppNavBarControllerState extends State<AppNavBarController> {
  final List<Widget> pages = [
    Robos(key: PageStorageKey('Page1')),
    Friends(key: PageStorageKey('Page2')),
    Rooms(key: PageStorageKey('Page3')),
    Messages(key: PageStorageKey('Page4')),
    Control(key: PageStorageKey('Page5')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _AppNavBar() => BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        currentIndex: _selectedIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              title: Text('Robos'),
              backgroundColor: Colors.cyan),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_calendar),
              title: Text('Friends'),
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: Text('Rooms'),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Text('Messages'),
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              title: Text('Control'),
              backgroundColor: Colors.purple),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _AppNavBar(),
        body: PageStorage(child: pages[_selectedIndex], bucket: bucket));
  }
}
