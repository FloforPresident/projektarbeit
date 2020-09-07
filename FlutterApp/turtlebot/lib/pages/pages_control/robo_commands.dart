import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_bar_image_icon.dart';
import 'package:turtlebot/services/routing.dart';

class RoboCommands extends StatefulWidget
{
  final String _titleText = "Robo-Commands";
  @override
  State<StatefulWidget> createState() {

    return _RoboCommandsState();
  }

}

class _RoboCommandsState extends State<RoboCommands> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TopAppBar(
              [
                TopBarImageIcon(Icon(Icons.format_list_bulleted),
                    RouteGenerator.onTapToRoboStatus),
                TopBarImageIcon(
                    Icon(Icons.computer, color: Colors.white), RouteGenerator.onTapToRoboCommands),
                TopBarImageIcon(
                    Icon(Icons.games), RouteGenerator.onTapToRoboManControl)
              ],
              widget._titleText
          ),
          backgroundColor: Colors.purple,

        )

    );
  }
}

