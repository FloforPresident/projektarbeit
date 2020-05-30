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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          RaisedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/robos');
            },
            icon: Icon(Icons.mood),
            label: Text('Robos'),
            color: Colors.cyan,
          ),
          RaisedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/friends');
            },
            icon: Icon(Icons.perm_contact_calendar),
            label: Text('Friends'),
            color: Colors.red,
          ),
          RaisedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/rooms');
            },
            icon: Icon(Icons.location_on),
            label: Text('Rooms'),
            color: Colors.green,
          ),
          RaisedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
            icon: Icon(Icons.mail),
            label: Text('Message'),
            color: Colors.orange,
          ),
          RaisedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/control');
            },
            icon: Icon(Icons.videogame_asset),
            label: Text('Control'),
            color: Colors.purple,
          ),
        ],
      )),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (int index) {
      //     setState(() => _selectedIndex = index);

      //     switch (_selectedIndex) {
      //       case 0:
      //         return Navigator.pushNamed(context, '/');
      //       case 1:
      //         return Navigator.pushNamed(context, '/friends');
      //       case 2:
      //         return Navigator.pushNamed(context, '/rooms');
      //       case 3:
      //         return Navigator.pushNamed(context, '/messages');
      //       case 4:
      //         return Navigator.pushNamed(context, '/control');
      //     }
      //   },
      //   currentIndex: _selectedIndex,
      //   iconSize: 30,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.mood),
      //         title: Text('Robos'),
      //         backgroundColor: Colors.cyan),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.perm_contact_calendar),
      //         title: Text('Friends'),
      //         backgroundColor: Colors.red),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.location_on),
      //         title: Text('Rooms'),
      //         backgroundColor: Colors.green),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.mail),
      //         title: Text('Messages'),
      //         backgroundColor: Colors.orange),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.videogame_asset),
      //         title: Text('Control'),
      //         backgroundColor: Colors.purple),
      //   ],
      // ),
    );
  }
}
