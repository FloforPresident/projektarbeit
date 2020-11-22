import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';

import 'package:turtlebot/main.dart';

class RoboStatus extends StatefulWidget {
  final channel = MyApp.con();

  RoboStatus({Key key}) : super(key: key);

  _RoboStatusState createState() => _RoboStatusState();
}

class _RoboStatusState extends State<RoboStatus> {

  void up() {
    String data = '{"action": "UP"}';
    widget.channel.sink.add(data);
  }
  void down() {
    String data = '{"action": "DOWN"}';
    widget.channel.sink.add(data);
  }
  void right() {
    String data = '{"action": "RIGHT"}';
    widget.channel.sink.add(data);
  }
  void left() {
    String data = '{"action": "LEFT"}';
    widget.channel.sink.add(data);
  }


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
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200,
                    height: 100,
                    child: FlatButton.icon(
                      onPressed: () {
                        up();
                        RouteGenerator.onTapToRoboStatus(context);
                      },
                      label: Text(''),
                      icon: Icon(Icons.arrow_upward_rounded),
                      color: Colors.grey,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 300,
                    height: 100,
                    child: FlatButton.icon(
                      onPressed: () {
                        left();
                        RouteGenerator.onTapToRoboStatus(context);
                      },
                      label: Text(''),
                      icon: Icon(Icons.arrow_back),
                      color: Colors.grey,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    height: 100,
                    child: FlatButton.icon(
                      onPressed: () {
                        right();
                        RouteGenerator.onTapToRoboStatus(context);
                      },
                      label: Text(''),
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.grey,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    height: 100,
                    child: FlatButton.icon(
                      onPressed: () {
                        down();
                        RouteGenerator.onTapToRoboStatus(context);
                      },
                      label: Text(''),
                      icon: Icon(Icons.arrow_downward_rounded),
                      color: Colors.grey,
                    ),
                  ),
                ]
            )
        )
    );
  }
}

// class RoboStatus extends StatefulWidget {
//   final String _titleText = "RoboStatus";
//
//   _RoboStatusState createState() => _RoboStatusState();
// }
//
// class _RoboStatusState extends State<RoboStatus> {
//   var ident = [
//     ["Status", "Connected"],
//     ["RoboName", "Robob"],
//     ["IP", "192.168.2.44"],
//     ["Controller", "PS4"],
//     ["Recipient", "Bastian Brunsch"],
//     ["Message", "Hallo"],
//     ["Room", "Living Room"],
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               RouteGenerator.onTapToHome(context);
//             },
//           ),
//           title: Text("Controlling"),
//           backgroundColor: Colors.purple,
//         ),
//         body: Center(
//           child: Text("Videostream"),
//         ));
//   }
// }
