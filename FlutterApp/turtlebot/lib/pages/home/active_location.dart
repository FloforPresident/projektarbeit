import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/pages/maps/locations.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class ActiveLocation extends StatefulWidget {
  final ActiveLocationController controller = new ActiveLocationController();

  static List<Location> locationItems = [];
  static List<Room> roomItems = [];
  static Location activeLocation;
  static Room activeRoom;
  static User user;

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
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.controller.setData(snapshot.data);

            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: colorTheme.withOpacity(0),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.withOpacity(0.0), width: 4.0)
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Aktuelle Location",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white)),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 2,
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                          ActiveLocation.activeLocation != null
                                              ? ActiveLocation.activeLocation.name
                                              : "Nichts ausgewählt"
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.create),
                                        onPressed: () {
                                          widget.controller.editItemDialog(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]
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

          } else {
            return Text('');
          }
        }
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class ActiveLocationController {
  ControllerCustomDropdown roomDropController = ControllerCustomDropdown<Room>();
  ControllerCustomDropdown locationDropController = ControllerCustomDropdown<Location>();


  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET LOCATIONS", "id": ${MyApp.id}}';

    channel.sink.add(data);
  }

  void setData(json) {
    ActiveLocation.activeRoom = null;
    ActiveLocation.activeLocation = null;

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];
    var userData = jsonData["user"];

    ActiveLocation.user = new User(userData['id'], userData['location_id'], userData['name']);
    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(locations[i]['id'], locations[i]['room_id'],
          locations[i]['name'], locations[i]['x'], locations[i]['y']);
      if(ActiveLocation.user.locationID == l.id){
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

  void editItemDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          List<Location> selectedLocations = [];
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(10.0))),
                  title: Text("Aktuellen Platz ändern"),
                  content: Builder(
                      builder: (context) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;

                        return Container(
                          height: height,
                          width: width,
                          child: Locations()
                        );
                      }
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Schließen"),
                      onPressed: () {
                        RouteGenerator.onTapToHome(context);
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }
}
