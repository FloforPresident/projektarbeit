import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/top_app_bar.dart';
import 'package:turtlebot/frameworks/on_delete.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Locations extends StatefulWidget {
  final LocationController controller = new LocationController();
  int dropDownRoomId;

  static List<Location> items = [];
  static List<Location> activeItems = [];
  static List<Room> roomItems = [];
  static Location activeLocation;
  static Room activeRoom;

  Locations({Key key}) : super(key: key);

  @override
  _LocationsState createState() {
    return _LocationsState();
  }
}

class _LocationsState extends State<Locations> {

  final WebSocketChannel channel = MyApp.con();

  final colorTheme = Colors.pink;
  ControllerCustomDropdown dropController = ControllerCustomDropdown<Room>();

  @override
  void initState() {
    super.initState();

    widget.controller.getData(channel);
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
          titleText: Text("Locations",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      body: StreamBuilder(
          stream: channel.stream,
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
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey,
                  //       borderRadius: BorderRadius.circular(6),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           offset: Offset(4, 7),
                  //           spreadRadius: 5,
                  //           blurRadius: 3,
                  //         )
                  //       ]),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.fromLTRB(15, 30, 0, 15),
                  //         child: Align(
                  //           alignment: Alignment.centerLeft,
                  //           child: Text("Aktuelle Location",
                  //               style: TextStyle(
                  //                   fontSize: 22.0,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white)),
                  //         ),
                  //       ),
                  //       Card(
                  //         margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  //         elevation: 2,
                  //         child: ListTile(
                  //           title: Container(
                  //             child: Align(
                  //                 alignment: Alignment.topLeft,
                  //                 child: Text(
                  //                     Locations.activeLocation != null
                  //                     ? Locations.activeLocation.name
                  //                     : "Keine aktive Location ausgewählt"
                  //                 )
                  //             ),
                  //           ),
                  //           subtitle: Container(
                  //               margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  //               child: Text(
                  //                   Locations.activeRoom != null
                  //                   ? Locations.activeRoom.name
                  //                   : 'Wähle unten eine aktive Location oder füge eigene hinzu',
                  //                   style: TextStyle(
                  //                     color: Colors.indigo,
                  //                     fontSize: 15.0,
                  //                     fontWeight: FontWeight.bold,
                  //                   ))),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    padding: EdgeInsets.fromLTRB(15,0,15,20),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(4, 7),
                            spreadRadius: 5,
                            blurRadius: 3,
                          )
                        ]),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 30, 0, 15),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Verfügbare Locations",
                                    style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold)))),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: CustomDropdownLabel(
                            label: Text("Room:", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            )),
                            child: CustomDropdownMenu<Room>(
                              itemTextStyle: TextStyle(color: Colors.black87),
                              selectedItemTextStyle: TextStyle(color: Colors.white, backgroundColor: Colors.lightBlue) ,
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
                        ),
                      ],
                    ),
                  ),

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
                Navigator.of(context).pop();
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
                  }
                  Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class LocationController {
  final GlobalKey<AnimatedListState> key = GlobalKey();

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET LOCATIONS", "id": ${MyApp.id}}';
    channel.sink.add(data);
  }

  void setData(json) {
    Locations.items = [];
    Locations.roomItems = [];
    Locations.activeItems = [];
    Locations.activeRoom = null;
    Locations.activeLocation = null;

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];

    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(locations[i]['id'], locations[i]['room_id'],
          locations[i]['name'], locations[i]['x'], locations[i]['y']);
      Locations.items.add(l);
      Locations.activeItems.add(l);
    }
    for (int i = 0; i < rooms.length; i++) {
      Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'], rooms[i]['name'],
          rooms[i]['scanned']);
      Locations.roomItems.add(r);
    }

    // Get active Location
    var user = jsonData["user"]["location_id"];
    for(int i = 0; i < Locations.items.length; i++) {
      if(user == Locations.items[i].id) {
        Locations.activeLocation = Locations.items[i];
        for(int y = 0; y < Locations.roomItems.length; y++) {
          if(Locations.activeLocation.roomId == Locations.roomItems[y].id) {
            Locations.activeRoom = Locations.roomItems[y];
          }
        }
      }
    }
  }

  void removeItem(Location location, int index) {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DELETE LOCATION", "id": "${location.id}"}';
    channel.sink.add(data);

    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, location, animation, index);
    };
    Locations.items.remove(location);
    Locations.activeItems.remove(location);
    key.currentState.removeItem(index, build);
  }

  void addItem(int roomID, String title, double x, double y) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "ADD LOCATION", "roomID": "$roomID", "title": "$title", "x": "$x", "y": "$y"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();
        final jsonData = jsonDecode(jsonDataString);

        Location location = new Location(jsonData['id'], jsonData['room_id'],
            jsonData['name'], jsonData['x'], jsonData['y']);

        int end = Locations.activeItems.length;
        Locations.activeItems.add(location);
        Locations.items.add(location);
        key.currentState.insertItem(end);
      }
    });
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
                          removeItem(item, index);
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
