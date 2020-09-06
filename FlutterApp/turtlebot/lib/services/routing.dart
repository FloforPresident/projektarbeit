import 'package:flutter/material.dart';
import 'package:turtlebot/pages/robos.dart';
import 'package:turtlebot/pages/rooms.dart';
import 'package:turtlebot/pages/control.dart';
import 'package:turtlebot/pages/friends.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/pages/messages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/robos':
        return MaterialPageRoute(builder: (_) => Robos());
      case '/friends':
        return MaterialPageRoute(builder: (_) => Friends());
      case '/rooms':
        return MaterialPageRoute(builder: (_) => Rooms());
      case '/messages':
        return MaterialPageRoute(builder: (_) => Messages());
      case '/control':
        return MaterialPageRoute(builder: (_) => Control());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
