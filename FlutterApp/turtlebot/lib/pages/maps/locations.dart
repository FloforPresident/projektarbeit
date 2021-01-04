import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/incorrect_ip_adress.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Locations extends StatefulWidget {
  final LocationController controller = new LocationController();
  int dropDownRoomId;
  final colorTheme = Colors.purple;

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

  final WebSocketChannel channel = MyApp.con();


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
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.controller.setData(snapshot.data);

            if (widget.dropDownRoomId != null && Locations.roomItems.isNotEmpty) {
              widget.controller.updateLocations(
                  context, Locations.roomItems[widget.dropDownRoomId].id);
              dropController
                  .setValue(Locations.roomItems[widget.dropDownRoomId]);
            }

            return SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: CustomDropdownLabel(
                        label: Text("Room:", style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        )),
                        child: CustomDropdownMenu<Room>(
                          itemTextStyle: TextStyle(color: Colors.black, fontSize: Theme.of(context).textTheme.bodyText2.fontSize),
                          selectedItemTextStyle: TextStyle(color: Colors.black,backgroundColor: Colors.lightBlue) ,
                          onChanged: (value) async {
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RaisedButton(
                        onPressed: () {
                          addItemDialog(context, dropController.getValue());
                        },
                        child: Text("Hinzufügen"),
                      ),
                    )
                  ],
                ),
              );
          }          else if(snapshot.connectionState == ConnectionState.waiting){
            return Text("");
          } else {
            return IncorrectIP();
          }
        }
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(item.name),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setActiveLocationDialog(context, item);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bool delete = await StatusMessages.onDelete(context);
                      if (delete) {
                        removeItem(item, index);
                      }
                    },
                  )
                ],
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
