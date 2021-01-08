import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtlebot/frameworks/top_app_bar_logout.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class Controls extends StatefulWidget {
  final ControlController controller = new ControlController();
  final Color textColor = Colors.white;
  static final Color colorTheme = Colors.green;
  final Color borderActionButtonColor = Colors.white;
  final Color controlPadBackground = Color(0xffe7ebda);
  final Color borderConrolPadBackground = Colors.green;
  final double borderFloatingWidth = 3.0;
  final double iconSize = 55.0;

  Controls({Key key}) : super(key: key);

  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0,10,0,10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child:
                      Mjpeg(
                        isLive: true,
                        stream:"http://${SocketInfo.hostAdress}${SocketInfo.portVideoStream}/stream?topic=/Face_Recognition_Stream",
                        error: (context,value)
                        {
                          return Center(child: Text("Leider kein Video-Stream gefunden"));
                        },
                      )
                      ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                            border: Border.all(
                              color: widget.borderActionButtonColor,
                              width: widget.borderFloatingWidth,
                            )),
                        child: SizedBox(
                          height: widget.iconSize,
                          width: widget.iconSize,
                          child: FloatingActionButton(
                              backgroundColor: Controls.colorTheme,
                              heroTag: "up",
                              onPressed: () {
                                widget.controller.up();
                              },
                              child: Icon(Icons.arrow_upward,
                                  color: widget.textColor)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: widget.borderActionButtonColor,
                                      width: widget.borderFloatingWidth,
                                    )),
                                margin: EdgeInsets.fromLTRB(0, 0, 60, 0),
                                child: SizedBox(
                                  height: widget.iconSize,
                                  width: widget.iconSize,
                                  child: FloatingActionButton(
                                      onPressed: () {
                                        widget.controller.left();
                                      },
                                      backgroundColor: Controls.colorTheme,
                                      heroTag: "left",
                                      child: Icon(Icons.arrow_back_rounded,
                                          color: widget.textColor)),
                                )),
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: widget.borderActionButtonColor,
                                      width: widget.borderFloatingWidth,
                                    )),
                                child: SizedBox(
                                  height: widget.iconSize,
                                  width: widget.iconSize,
                                  child: FloatingActionButton(
                                      onPressed: () {
                                        widget.controller.right();
                                      },
                                      backgroundColor: Controls.colorTheme,
                                      heroTag: "right",
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: widget.textColor,
                                      )),
                                ))
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: widget.borderActionButtonColor,
                                  width: widget.borderFloatingWidth)),
                          child: SizedBox(
                            width: widget.iconSize,
                            height: widget.iconSize,
                            child: FloatingActionButton(
                                onPressed: () {
                                  widget.controller.down();
                                },
                                heroTag: "down",
                                backgroundColor: Controls.colorTheme,
                                child: Icon(Icons.arrow_downward_rounded,
                                    color: widget.textColor)),
                          )),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.grey,
                            width: widget.borderFloatingWidth)),
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.blueGrey,
                      onPressed: () {
                        widget.controller.stop();
                      },
                      child: Text("Stop",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ))
              ],
            ),
          ]),
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

  void stop() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "STOP"}';
    channel.sink.add(data);
  }
}
