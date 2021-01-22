import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/incorrect_ip_adress.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/alertDialogs/error_messages.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ignore: must_be_immutable
class Rooms extends StatefulWidget {
  final colorTheme = Colors.purple;
  RoomController controller;
  final double spaceBetweenIcons = 8.0;
  final EdgeInsetsGeometry paddingCard = EdgeInsets.fromLTRB(0, 12.0, 0, 8.0);

  static List<Room> items = [];
  static List<Robo> roboItems = [];
  static Room newRoom;

  Rooms({Key key})  : super(key: key)
  {
    this.controller = RoomController(this);
  }

  @override
  _RoomState createState() {
    return _RoomState();
  }
}

class _RoomState extends State<Rooms> {
  final WebSocketChannel channel = MyApp.con();

  @override
  void initState() {
    super.initState();

    widget.controller.getData(channel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widget.controller.setData(snapshot.data);

                return Column(
                  children: [
                    AnimatedList(
                      key: widget.controller.key,
                      initialItemCount: Rooms.items.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        return widget.controller.buildItem(
                            context, Rooms.items[index], animation, index,
                            iconsize: widget.spaceBetweenIcons,
                            paddingCard: widget.paddingCard);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RaisedButton(
                        onPressed: () {
                          widget.controller.addItemDialog(context);
                        },
                        child: Text("Hinzufügen"),
                      ),
                    )
                  ],
                );
              } else if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Text("");
              } else {
                return IncorrectIP();
              }
            }),
      ],
    );
  }




  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class RoomController {
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final Rooms connectedWidget;

  RoomController(this.connectedWidget);

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET ROOMS"}';
    channel.sink.add(data);
  }

  void setData(json) {
    Rooms.items = [];
    Rooms.roboItems = [];

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var rooms = jsonData['rooms'];
    var robos = jsonData['robos'];

    for (int i = 0; i < rooms.length; i++) {
      Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'], rooms[i]['name'],
          rooms[i]['scanned']);
      Rooms.items.add(r);
    }
    for (int i = 0; i < robos.length; i++) {
      Robo r = new Robo(robos[i]['id'], robos[i]['name'], robos[i]['ip']);
      Rooms.roboItems.add(r);
    }
  }

  void removeItem(Room room, int index) {
    //Remove Shared Preference
    removeSelectedRoom();

    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DELETE ROOM", "id": "${room.id}"}';
    channel.sink.add(data);

    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, room, animation, index, paddingCard: connectedWidget.paddingCard);
    };

    Rooms.items.remove(room);
    key.currentState.removeItem(index, build);
  }

  void addItem(int roboID, String name) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "ADD ROOM", "roboID": "$roboID", "name": "$name"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();
        final jsonData = jsonDecode(jsonDataString);

        Rooms.newRoom = new Room(jsonData['id'], jsonData['robo_id'],
            jsonData['name'], jsonData['scanned']);

        int end = Rooms.items.length;
        Rooms.items.add(Rooms.newRoom);
        key.currentState.insertItem(end);
      }
    });
  }

  void updateItem(Room room, Robo robo) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "UPDATE ROBO", "room_id": ${room.id}, "robo_id": ${robo.id}}';
    channel.sink.add(data);

    for (int i = 0; i < Rooms.items.length; i++) {
      if (Rooms.items[i].id == room.id) {
        room.setValue(robo.id);
        AnimatedListRemovedItemBuilder build = (context, animation) {
          return buildItem(context, Rooms.items[i], animation, i, paddingCard: connectedWidget.paddingCard);
        };

        key.currentState.removeItem(i, build);
        Rooms.items.remove(Rooms.items[i]);

        Rooms.items.add(room);
        key.currentState.insertItem(i);
      }
    }
  }

  void startScan() {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "SCAN ROOM", "room_id": ${Rooms.newRoom.id}}';
    channel.sink.add(data);
  }

  void newRoomRoboAlreadyTaken(Robo robo) {
    for (int i = 0; i < Rooms.items.length; i++) {
      if (Rooms.items[i].roboID == robo.id) {
        int id;
        WebSocketChannel channel = MyApp.con();
        String data =
            '{"action": "UPDATE ROBO", "room_id": ${Rooms.items[i].id}, "robo_id": $id}';

        channel.sink.add(data);

        Room room = Rooms.items[i];
        room.setValue(id);
        AnimatedListRemovedItemBuilder build = (context, animation) {
          return buildItem(context, Rooms.items[i], animation, i);
        };

        key.currentState.removeItem(i, build);
        Rooms.items.remove(Rooms.items[i]);

        Rooms.items.add(room);
        key.currentState.insertItem(i);
      }
    }
  }

  // Remove Shared Preference
  void removeSelectedRoom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('room_id', null);
  }

  Widget buildItem(
      BuildContext context, Room currentRoom, Animation animation, int index,
      {double iconsize = 8.0, EdgeInsetsGeometry paddingCard = const EdgeInsets.fromLTRB(0, 12.0, 0, 8.0)}) {
    String roboName = '';
    for (int i = 0; i < Rooms.roboItems.length; i++) {
      if (currentRoom.roboID == Rooms.roboItems[i].id) {
        roboName = Rooms.roboItems[i].name;
      }
    }

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Padding(
            padding: paddingCard,
            child: Table(
              columnWidths: {
                1: IntrinsicColumnWidth(),
              },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(currentRoom.name)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(iconsize, 0, iconsize, 0),
                              child: currentRoom.scanned
                                  ? Icon(Icons.check_box)
                                  : Icon(Icons.check_box_outline_blank),
                            ),
                            IconButton(
                              constraints: BoxConstraints(),
                              padding:
                                  EdgeInsets.fromLTRB(iconsize, 0, iconsize, 0),
                              icon: Icon(Icons.map),
                              onPressed: () {
                                RouteGenerator.onTapToFullscreenMap(
                                    context, currentRoom);
                              },
                            ),
                            IconButton(
                              padding:
                                  EdgeInsets.fromLTRB(iconsize, 0, iconsize, 0),
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.create),
                              onPressed: () {
                                editItemDialog(context, currentRoom);
                              },
                            ),
                            IconButton(
                              constraints: BoxConstraints(),
                              padding:
                                  EdgeInsets.fromLTRB(iconsize, 0, iconsize, 0),
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                bool delete =
                                    await StatusMessages.onDelete(context);
                                if (delete != null && delete) {
                                  removeItem(currentRoom, index);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          subtitle: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(roboName != '' ? roboName : 'Kein Roboter ausgewählt',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      ),
    );
  }

  void addItemDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    ControllerCustomDropdown dropController = ControllerCustomDropdown<Robo>();


    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Neuen Raum hinzufügen"),
            content: Builder(builder: (context) {
              var height = MediaQuery
                  .of(context)
                  .size
                  .height;
              var width = MediaQuery
                  .of(context)
                  .size
                  .width;

              return Container(
                height: height,
                width: width,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                    CustomDropdownLabel(
                      label: Text("Robo:"),
                      child: CustomDropdownMenu<Robo>(
                          controller: dropController, data: Rooms.roboItems),
                    ),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              FlatButton(
                child: Text("Schließen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Hinzufügen"),
                onPressed: () {
                  if (controller.text.isNotEmpty &&
                      dropController.getValue() != null) {
                    newRoomRoboAlreadyTaken(dropController.getValue());
                    addItem(dropController
                        .getValue()
                        .id, controller.text);

                    // scanMapDialog(context);
                    Navigator.of(context).pop();
                  } else {
                    ErrorMessages.noDataEntered(context);
                  }
                },
              ),
            ],
          );
        });
  }
  void editItemDialog(BuildContext context, Room room) {
    ControllerCustomDropdown dropController = ControllerCustomDropdown<Robo>();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text("Update your settings"),
                content: Column(
                  children: <Widget>[
                    CustomDropdownLabel(
                      label: Text("Robo:"),
                      child: CustomDropdownMenu<Robo>(
                          controller: dropController, data: Rooms.roboItems),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Schließen"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Update"),
                    onPressed: () {
                      if (dropController.getValue() != null) {
                        newRoomRoboAlreadyTaken(dropController.getValue());
                        updateItem(room, dropController.getValue());
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
