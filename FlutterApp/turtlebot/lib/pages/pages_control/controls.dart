import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Controls extends StatefulWidget {
  final ControlController controller = new ControlController();
  Color textColor = Colors.white;
  Color backgroundColor = Colors.green;
  Color borderActionButtonColor = Colors.white;
  Color controlPadBackground = Color(0xffe7ebda);
  Color borderConrolPadBackground = Colors.green;
  double borderFloatingWidth = 3.0;

  Controls({Key key}) : super(key: key);

  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Center(child: Icon(Icons.arrow_back, color: widget.textColor,)),
            onPressed: () {
              RouteGenerator.onTapToHome(context);
            },
          ),
          title: Text("Controlling",style: TextStyle(
            color: widget.textColor)
          ),
          backgroundColor: widget.backgroundColor,
        ),
        body: Container(
            child: Container(
              height: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(child: Container(decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black
                      )
                    ),child: Center(child: Text("Video")))),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.borderConrolPadBackground,
                          width: 4.0,
                        ),
                        shape: BoxShape.circle,
                        color: widget.controlPadBackground,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:Border.all(
                                  color: widget.borderActionButtonColor,
                                  width: widget.borderFloatingWidth,
                                )
                            ),
                            child: FloatingActionButton(
                                backgroundColor: widget.backgroundColor,
                                heroTag:"up",
                                onPressed: () {},
                                child: Icon(Icons.arrow_upward, color: widget.textColor)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:Border.all(
                                      color: widget.borderActionButtonColor,
                                      width: widget.borderFloatingWidth,
                                    )
                                ),
                                    margin:EdgeInsets.fromLTRB(0, 0, 70, 0) ,child: FloatingActionButton(onPressed: () {},backgroundColor: widget.backgroundColor,heroTag:"left", child: Icon(Icons.arrow_back_rounded, color: widget.textColor))),
                                Container(decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:Border.all(
                                    color: widget.borderActionButtonColor,
                                    width: widget.borderFloatingWidth,
                                  )
                                ), child: FloatingActionButton(onPressed: () {},backgroundColor: widget.backgroundColor,  heroTag:"right", child: Icon(Icons.arrow_forward_rounded, color: widget.textColor,)))
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:Border.all(
                                color: widget.borderActionButtonColor,
                                width: widget.borderFloatingWidth
                              )
                          ),
                              child: FloatingActionButton(onPressed: () {}, heroTag:"down",backgroundColor: widget.backgroundColor, child: Icon(Icons.arrow_downward_rounded, color: widget.textColor))),
                        ],
                      ),
                    ),
                    Container(width: 200, height: 40 ,margin: EdgeInsets.fromLTRB(20, 20, 20, 20), child: RaisedButton(onPressed: (){}, child: Text("Stop"),))
                  ]),
            )));
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
