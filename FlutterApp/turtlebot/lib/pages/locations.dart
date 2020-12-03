import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Locations extends StatefulWidget {
  final LocationController controller = new LocationController();
  final WebSocketChannel channel = MyApp.con();
  int dropDownRoomId;

  static List<Location> items = [];
  static List<Location> activeItems = [];
  static List<Room> roomItems = [];

  Locations({Key key}) : super(key: key);

  @override
  _LocationsState createState() {
    return _LocationsState();
  }
}

class _LocationsState extends State<Locations> {
  final colorTheme = Colors.pink;
  ControllerCustomDropdown dropController = ControllerCustomDropdown<Room>();

  @override
  void initState() {
    super.initState();

    widget.controller.getData(widget.channel);
    getSelectedRoom();
  }

  void getSelectedRoom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int roomID = prefs.getInt('room_id');

    if (roomID != null) {
      setState(() {
        widget.dropDownRoomId = roomID;
      });
    }
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
        backgroundColor: colorTheme,
        title: TopAppBar(
          navigationFields: <Widget>[
            TopBarImageIcon(
                Icon(Icons.map, size: 30), RouteGenerator.onTapToRooms),
            TopBarImageIcon(
                Icon(Icons.room, color: Colors.white, size: 30), (context) {}),
          ],
          titleText: "Locations",
        ),
      ),
      body: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              widget.controller.setData(snapshot.data);

              if (widget.dropDownRoomId != null) {
                widget.controller.updateLocations(
                    context, Locations.roomItems[widget.dropDownRoomId].id);
                dropController
                    .setValue(Locations.roomItems[widget.dropDownRoomId]);
              }

              return SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(4,7),
                          spreadRadius: 5,
                          blurRadius: 3,
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 30, 0, 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("CurrentLocation",
                                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),                  
                        Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          elevation: 2,
                          child: ListTile(
                            title: Container(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child:
                                  Text("Here hast to be the current Location")),
                            ),
                            subtitle: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text("Here has to be to room to the Location",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 30, 0, 15),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Verfügbare Locations",
                              style: TextStyle(fontSize: 20.0)))),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                    child: CustomDropdownLabel(
                      label: "Room",
                      child: CustomDropdownMenu<Room>(
                        onChanged: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setInt(
                              'room_id', dropController.getCurrentIndex());

                          widget.controller.updateLocations(
                              context, dropController.getValue().id);
                        },
                        startValueId: widget.dropDownRoomId,
                        controller: dropController,
                        data: Locations.roomItems,
                      ),
                    ),
                  ),
                  AnimatedList(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    key: widget.controller.key,
                    initialItemCount: Locations.activeItems.length,
                    itemBuilder: (context, index, animation) {
                      return widget.controller.buildItem(context,
                          Locations.activeItems[index], animation, index);
                    },
                  )
                ]),
              );
            } else {
              return Text('');
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (dropController.getValue() != null) {
            addItemDialog(context, dropController.getValue());
          }
        },
        backgroundColor: colorTheme,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void addItemDialog(BuildContext context, Room room) {
    TextEditingController titleController = TextEditingController();
    TextEditingController xController = TextEditingController();
    TextEditingController yController = TextEditingController();

    String roomString = room.name;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Neuen Platz in $roomString hinzufügen"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: xController,
                decoration: InputDecoration(labelText: "X-Koordinate"),
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(labelText: "Y-Koordinate"),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Schließen"),
              onPressed: () {
                RouteGenerator.onTapToLocations(context);
              },
            ),
            FlatButton(
              child: Text("Hinzufügen"),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    xController.text.isNotEmpty &&
                    yController.text.isNotEmpty) {
                  widget.controller.addItem(
                      room.id,
                      titleController.text,
                      double.parse(xController.text),
                      double.parse(yController.text));
                  RouteGenerator.onTapToLocations(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LocationController {
  final GlobalKey<AnimatedListState> key = GlobalKey();

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET LOCATIONS"}';
    channel.sink.add(data);
  }

  void setData(json) {
    Locations.items = [];
    Locations.roomItems = [];
    Locations.activeItems = [];

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];

    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(
          locations[i]['location_id'],
          locations[i]['room_id'],
          locations[i]['title'],
          locations[i]['x'],
          locations[i]['y']);
      Locations.items.add(l);
      Locations.activeItems.add(l);
    }
    for (int i = 0; i < rooms.length; i++) {
      Room r = new Room(rooms[i]['room_id'], rooms[i]['robo_id'],
          rooms[i]['title'], rooms[i]['scanned']);
      Locations.roomItems.add(r);
    }
  }

  void removeItem(Location location) {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DELETE LOCATION", "id": "${location.id}"}';
    channel.sink.add(data);
  }

  void addItem(int roomID, String title, double x, double y) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "ADD LOCATION", "roomID": "$roomID", "title": "$title", "x": "$x", "y": "$y"}';
    channel.sink.add(data);
  }

  void updateItem(int userID, Location location) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "UPDATE FRIEND", "user_id": "$userID", "location_id": ${location.id}}';
    channel.sink.add(data);
  }

  void updateLocations(BuildContext context, int roomId) {
    bool inserted = false;
    int indexRemoveableItem = 0;

    for (int i = 0; i < Locations.items.length; i++) {
      for (int y = 0; y < Locations.activeItems.length; y++) {
        if (Locations.items[i].id == Locations.activeItems[y].id) {
          inserted = true;
          indexRemoveableItem = y;
        }
      }
      if (Locations.items[i].roomId == roomId && !inserted) {
        int end = Locations.activeItems.length;
        Locations.activeItems.add(Locations.items[i]);

        AnimatedListItemBuilder build = (context, index, animation) {
          return buildItem(
              context, Locations.activeItems[index], animation, index);
        };
        if (key.currentState != null) {
          key.currentState.insertItem(end);
        }
      } else if (Locations.items[i].roomId != roomId && inserted) {
        Location removeItem =
            Locations.activeItems.removeAt(indexRemoveableItem);
        AnimatedListRemovedItemBuilder build = (context, animation) {
          return buildItem(context, removeItem, animation, indexRemoveableItem);
        };
        if (key.currentState != null) {
          key.currentState.removeItem(indexRemoveableItem, build);
        }
      }
      inserted = false;
    }
  }

  Widget buildItem(
      BuildContext context, Location item, Animation animation, int index) {
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
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.create),
                      onPressed: () {
                        setActiveLocationDialog(context, item);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool delete = await OnDelete.onDelete(context);
                        if (delete) {
                          removeItem(item);
                          RouteGenerator.onTapToLocations(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setActiveLocationDialog(BuildContext context, Location location) {
    String locationString = location.name;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text("Willst du $locationString zu deinem aktuellen Platz machen?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Nein"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Ja"),
            onPressed: () {
              updateItem(MyApp.id, location);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
