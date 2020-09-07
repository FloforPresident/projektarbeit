import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_bar_image_icon.dart';
import 'package:turtlebot/services/routing.dart';

class RoboStatus extends StatefulWidget {

  final String _titleText = "RoboStatus";


  _RoboStatusState createState() => _RoboStatusState();
}



class _RoboStatusState extends State<RoboStatus>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TopAppBar(
              [TopBarImageIcon(Icon(Icons.format_list_bulleted, color: Colors.white),RouteGenerator.onTapToRoboStatus),
                TopBarImageIcon(Icon(Icons.computer),RouteGenerator.onTapToRoboCommands),
                TopBarImageIcon(Icon(Icons.games),RouteGenerator.onTapToRoboManControl)],
              widget._titleText
          ),
          backgroundColor: Colors.purple,

        )

    );
  }
}
