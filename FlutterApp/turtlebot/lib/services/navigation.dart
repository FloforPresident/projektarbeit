import 'package:flutter/material.dart';
import 'package:turtlebot/pages/control.dart';
import 'package:turtlebot/pages/friends.dart';
import 'package:turtlebot/pages/messages.dart';
import 'package:turtlebot/pages/robos.dart';
import 'package:turtlebot/pages/rooms.dart';

class AppNavBarController extends StatefulWidget {
  @override
  _AppNavBarControllerState createState() => _AppNavBarControllerState();
}

class _AppNavBarControllerState extends State<AppNavBarController> {
  int _selectedIndex = 0;

  final _pages = [
    Robos(),
    Friends(),
    Rooms(),
    Messages(),
    Control(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
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
        ));

    // return Container(
    //   padding: EdgeInsets.all(20),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       ButtonTheme(
    //         minWidth: 300,
    //         height: 100,
    //         child: RaisedButton.icon(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/robos');
    //           },
    //           icon: Icon(Icons.mood),
    //           label: Text('Robos'),
    //           color: Colors.blue,
    //         ),
    //       ),
    //       ButtonTheme(
    //         minWidth: 300,
    //         height: 100,
    //         child: RaisedButton.icon(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/friends');
    //           },
    //           icon: Icon(Icons.perm_contact_calendar),
    //           label: Text('Friends'),
    //           color: Colors.red,
    //         ),
    //       ),
    //       ButtonTheme(
    //         minWidth: 200,
    //         height: 100,
    //         child: RaisedButton.icon(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/rooms');
    //           },
    //           icon: Icon(Icons.location_on),
    //           label: Text('Rooms'),
    //           color: Colors.green,
    //         ),
    //       ),
    //       ButtonTheme(
    //         minWidth: 200,
    //         height: 100,
    //         child: RaisedButton.icon(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/messages');
    //           },
    //           icon: Icon(Icons.mail),
    //           label: Text('Message'),
    //           color: Colors.orange,
    //         ),
    //       ),
    //       ButtonTheme(
    //         minWidth: 200,
    //         height: 100,
    //         child: RaisedButton.icon(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/control');
    //           },
    //           icon: Icon(Icons.videogame_asset),
    //           label: Text('Control'),
    //           color: Colors.purple,
    //         ),
    //       ),
    //       // FloatingActionButton(
    //       //   onPressed: () {
    //       //     Navigator.pushNamed(context, '/login');
    //       //   },
    //       //   child: Text('Login'),
    //       //   backgroundColor: Colors.yellow,
    //       // )
    //     ],
    //   ),
    // );
  }
}
