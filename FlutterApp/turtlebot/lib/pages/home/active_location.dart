import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class ActiveLocation extends StatefulWidget {
  final MessageController controller = new MessageController();

  static Location activeLocation;
  static Room activeRoom;

  ActiveLocation({Key key}) : super(key: key);

  @override
  _ActiveLocationState createState() {
    return _ActiveLocationState();
  }
}

class _ActiveLocationState extends State<ActiveLocation> {
  final channel = MyApp.con();

  final colorTheme = Colors.orange;

  double _fontsize = 18;
  double _leftStart = 40;
  double _topSpace = 15;
  double _spaceRightLabel = 20;

  get spaceRightLabel {
    return _spaceRightLabel;
  }

  get topSpace {
    return _topSpace;
  }

  get fontsize {
    return _fontsize;
  }

  get leftStart {
    return _leftStart;
  }

  @override
  void initState() {
    super.initState();

    widget.controller.getData(channel);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: BoxDecoration(
              color: colorTheme.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(4, 7),
                  spreadRadius: 1,
                  blurRadius: 8,
                )
              ]),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Aktuelle Location",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  elevation: 2,
                  child: ListTile(
                    title: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          ActiveLocation.activeLocation != null
                            ? ActiveLocation.activeLocation.name
                            : "Keine aktive Location ausgewählt"
                        )
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        ActiveLocation.activeRoom != null
                          ? ActiveLocation.activeRoom.name
                          : '',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class MessageController {

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET LOCATIONS"}';
    channel.sink.add(data);
  }

  void setData(json) {
    ActiveLocation.activeRoom = null;
    ActiveLocation.activeLocation = null;

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];

    var user = jsonData["user"]["location_id"];
    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(locations[i]['id'], locations[i]['room_id'],
          locations[i]['name'], locations[i]['x'], locations[i]['y']);
      if(user == l.id){
        ActiveLocation.activeLocation = l;
        for (int i = 0; i < rooms.length; i++) {
          Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'], rooms[i]['name'],
              rooms[i]['scanned']);
          if(ActiveLocation.activeLocation.roomId == r.id){
            ActiveLocation.activeRoom = r;
          }
        }
      }
    }
  }

  void sendMessage(User user, String subject, String message) {
    WebSocketChannel channel = MyApp.con();

    String data = '{"action": "SEND MESSAGE", "from_user": ${MyApp.id}, "to_user": ${user.id}, "subject": "$subject", "message": "$message"}';
    channel.sink.add(data);
  }
}
