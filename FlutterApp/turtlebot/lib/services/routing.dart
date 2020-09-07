import 'package:flutter/material.dart';
import 'package:turtlebot/pages/pages_control/robo_commands.dart';
import 'package:turtlebot/pages/pages_control/robo_man_control.dart';
import 'package:turtlebot/pages/pages_control/robo_status.dart';
import 'package:turtlebot/pages/robos.dart';
import 'package:turtlebot/pages/rooms.dart';
import 'package:turtlebot/pages/friends.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/pages/messages.dart';

class RouteGenerator {

  _RouteGenerator() {}

  static const String RouteRoboStatus = '/roboStatus';
  static const String RouteRoboCommands = '/roboCommands';
  static const String RouteManualControl = '/manControl';



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
      case RouteRoboStatus:
        return MaterialPageRoute(builder: (_) => RoboStatus());
      case RouteRoboCommands:
        return MaterialPageRoute(builder: (_) => RoboCommands());
      case RouteManualControl:
        return MaterialPageRoute(builder: (_) => RoboManControl());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  static onTapToRoboStatus(BuildContext context)
  {
    Navigator.pushNamed(context,RouteGenerator.RouteRoboStatus);
  }

  static onTapToRoboCommands(BuildContext context)
  {
    Navigator.pushNamed(context,RouteGenerator.RouteRoboCommands);
  }

  static onTapToRoboManControl(BuildContext context)
  {
    Navigator.pushNamed(context,RouteGenerator.RouteManualControl);
  }
}
