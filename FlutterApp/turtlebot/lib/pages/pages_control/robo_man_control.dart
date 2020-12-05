import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';

class RoboManControl extends StatefulWidget {
  final String _titleText = "Robo-Manual-Control";

  @override
  State<StatefulWidget> createState() {
    return _RoboManControlState();
  }
}

class _RoboManControlState extends State<RoboManControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            RouteGenerator.onTapToHome(context);
          },
        ),
        title: TopAppBar(navigationFields: [
          TopBarImageIcon(Icon(Icons.format_list_bulleted),
              RouteGenerator.onTapToRoboStatus),
          TopBarImageIcon(Icon(Icons.computer, ),
              RouteGenerator.onTapToRoboCommands),
          TopBarImageIcon(
              Icon(Icons.games, color: Colors.white), RouteGenerator.onTapToRoboManControl)
        ], titleText: widget._titleText),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
