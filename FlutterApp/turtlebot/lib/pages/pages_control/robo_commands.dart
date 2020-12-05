import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';

class RoboCommands extends StatefulWidget {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            RouteGenerator.onTapToHome(context);
          },
        ),
        title: TopAppBar(navigationFields: [
          TopBarImageIcon(Icon(Icons.format_list_bulleted),
              RouteGenerator.onTapToRoboStatus),
          TopBarImageIcon(Icon(Icons.computer, color: Colors.white),
              RouteGenerator.onTapToRoboCommands),
          TopBarImageIcon(
              Icon(Icons.games), RouteGenerator.onTapToRoboManControl)
        ],titleText: widget._titleText),
        backgroundColor: Colors.purple,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[RaisedButton(
            child: Text("Scan Room"),
          ),
            RaisedButton(
              child: Text("Bla bla"),
            )],
        ),
      )

    );
  }
}
