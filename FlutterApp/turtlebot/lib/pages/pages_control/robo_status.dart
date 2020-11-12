import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/frameworks/custom_data_table/custom_dataTable.dart';


class RoboStatus extends StatefulWidget {
  final String _titleText = "RoboStatus";

  _RoboStatusState createState() => _RoboStatusState();
}

class _RoboStatusState extends State<RoboStatus> {
  var ident = [
    ["Status", "Connected"],
    ["RoboName", "Robob"],
    ["IP", "192.168.2.44"],
    ["Controller", "PS4"],
    ["Recipient", "Bastian Brunsch"],
    ["Message", "Hallo"],
    ["Room", "Living Room"],
  ];

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
          title: Text("Controlling"),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Text("Videostream"),
        ));
  }
}
