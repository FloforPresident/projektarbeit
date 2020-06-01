import 'package:flutter/material.dart';
import 'package:turtlebot/pages/rootpage.dart';
import 'package:turtlebot/services/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TurtleBot',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: RootPage(auth: new Auth()));
  }
}
