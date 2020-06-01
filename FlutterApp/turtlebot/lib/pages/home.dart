import 'package:flutter/material.dart';
import 'package:turtlebot/services/navigation.dart';

import 'package:turtlebot/services/authentication.dart';

class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: FloatingActionButton.extended(
            label: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: signOut,
            backgroundColor: Colors.blue,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: AppNavBarController(),
    );
  }
}
