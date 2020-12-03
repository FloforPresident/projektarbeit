import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Controls extends StatefulWidget {
  final ControlController controller = new ControlController();

  Controls({Key key}) : super(key: key);

  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {

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
                        widget.controller.up();
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
                        widget.controller.left();
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
                        widget.controller.right();
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
                        widget.controller.down();
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

class ControlController {
  void up() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "UP"}';
    channel.sink.add(data);
  }
  void down() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DOWN"}';
    channel.sink.add(data);
  }
  void right() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "RIGHT"}';
    channel.sink.add(data);
  }
  void left() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "LEFT"}';
    channel.sink.add(data);
  }
}
