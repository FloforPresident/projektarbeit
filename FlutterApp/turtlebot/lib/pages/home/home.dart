import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/top_app_bar_logout.dart';
import 'package:turtlebot/pages/home/active_location.dart';
import 'package:turtlebot/pages/home/messages.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  final colorTheme = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBarLogout(
            colorTheme: colorTheme,
            page: "Home"
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ActiveLocation(),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 15, 0, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Nachricht",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                  ),
                ),
                Messages(null)
              ],
            )
        )
    );
  }
}
