import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/on_delete.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Rooms extends StatefulWidget {
  final RoomController controller = new RoomController();
  final WebSocketChannel channel = MyApp.con();

  static List<Room> items = [];
  static List<Robo> roboItems = [];
  static Room newRoom;

  Rooms({Key key}) : super(key: key);

  @override
  _RoomState createState() {
    return _RoomState();
  }
}

class _RoomState extends State<Rooms> {
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final colorTheme = Colors.purple;

  ControllerCustomDropdown dropController = ControllerCustomDropdown<Robo>();

  @override
  void initState() {
    super.initState();

    widget.controller.getData(widget.channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            RouteGenerator.onTapToHome(context);
          },
        ),
        title: TopAppBar(
          navigationFields: <Widget>[
            TopBarImageIcon(
              Icon(
                Icons.map,
                color: Colors.white,
                size: 30,
              ),
              (context) {}),
            TopBarImageIcon(
                Icon(Icons.room, size: 30), RouteGenerator.onTapToLocations),
          ],
          titleText: Text("Rooms", style: TextStyle(
            color: Colors.white,
          )),
        ),
        backgroundColor: colorTheme,
      ),
      body: StreamBuilder(
        stream: widget.channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            widget.controller.setData(snapshot.data);

            return AnimatedList(
              key: key,
              initialItemCount: Rooms.items.length,
              itemBuilder: (context, index, animation) {
                return buildItem(Rooms.items[index], animation, index);
              },
            );
          } else {
            return Text('');
          }
        }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: colorTheme,
        onPressed: () {
          addItemDialog(context);
        },
      ),
    );
  }

  Widget buildItem(Room item, Animation animation, int index) {
    String roboName = '';
    for (int i = 0; i < Rooms.roboItems.length; i++) {
      if (item.roboID == Rooms.roboItems[i].id) {
        roboName = Rooms.roboItems[i].name;
      }
    }

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[
                    Text(item.name),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  child: Padding(
                    child: item.scanned ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                    padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                  ),
                  alignment: Alignment.centerRight,
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
                        editItemDialog(context, item);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool delete = await OnDelete.onDelete(context);
                        if (delete) {
                          widget.controller.removeItem(item);
                          RouteGenerator.onTapToRooms(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
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

  void editItemDialog(BuildContext context, Room room) {
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
                        controller: dropController,
                        data: Rooms.roboItems),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Schließen"),
                    onPressed: () {
                      RouteGenerator.onTapToRooms(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Update"),
                    onPressed: () {
                      if(dropController.getValue() != null) {
                        widget.controller.updateItem(room, dropController.getValue());
                        RouteGenerator.onTapToRooms(context);
                      }
                    },
                  ),
                ],
              )
            );
          }
        );
      }
    );
  }

  void addItemDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          title: Text("Neuen Raum hinzufügen"),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

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
            }
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Schließen"),
              onPressed: () {
                RouteGenerator.onTapToRooms(context);
              },
            ),
            FlatButton(
              child: Text("Weiter"),
              onPressed: () {
                if (controller.text.isNotEmpty && dropController.getValue() != null) {
                  widget.controller.addItem(dropController.getValue().id, controller.text);

                  scanMapDialog(context);
                }
              },
            ),
          ],
        );
      }
    );
  }

  void scanMapDialog(BuildContext context) {
    bool _startScan = false;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            title: Text("Raum scannen"),
            content: StatefulBuilder(
                builder: (context, setState) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Text("Dieser Vorgang kann einige Zeit dauern, sobald er abgeschlossen ist wird der Raum abgehakt in der Raum-Liste erscheinen."),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: RaisedButton(
                            child: Text("Start"),
                            color: colorTheme,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _startScan = true;
                              });
                              widget.controller.startScan();
                            },
                          ),
                        ),
                        CheckboxListTile(
                          title: Text("Scan gestartet"),
                          value: _startScan,
                          onChanged: (bool value) {},
                        )
                      ],
                    ),
                  );
                }
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Schließen"),
                onPressed: () {
                  RouteGenerator.onTapToRooms(context);
                },
              ),
              FlatButton(
                child: Text("Fertig"),
                onPressed: () {
                  if (_startScan) {
                    RouteGenerator.onTapToRooms(context);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}

class RoomController {

  void getData (WebSocketChannel channel) {
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
      Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'],
          rooms[i]['name'], rooms[i]['scanned']);
      Rooms.items.add(r);
    }
    for (int i = 0; i < robos.length; i++) {
      Robo r = new Robo(
          robos[i]['id'], robos[i]['name'], robos[i]['ip']);
      Rooms.roboItems.add(r);
    }
  }

  void removeItem(Room room) {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DELETE ROOM", "id": "${room.id}"}';
    channel.sink.add(data);
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

        Rooms.newRoom = new Room(jsonData['id'], jsonData['robo_id'], jsonData['name'], jsonData['scanned']);
      }
    });
  }

  void updateItem(Room room, Robo robo) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "UPDATE ROBO", "room_id": ${room.id}, "robo_id": ${robo.id}}';
    channel.sink.add(data);
  }

  void startScan() {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "SCAN ROOM", "room_id": ${Rooms.newRoom.id}}';
    channel.sink.add(data);
  }
}