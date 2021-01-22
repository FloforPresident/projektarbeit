import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/incorrect_ip_adress.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/pages/home/messages.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Friends extends StatefulWidget {
  FriendController controller;
  static List<User> items = [];
  static List<Location> locationItems = [];
  static List<Room> roomItems = [];
  static final colorTheme = Colors.red;
  int currentvalueRoom = null;


  Friends({Key key}) : super(key: key)
  {
    this.controller = FriendController(this);
  }

  @override
  _FriendState createState() {
    return _FriendState();
  }
}

class _FriendState extends State<Friends> {
  final WebSocketChannel channel = MyApp.con();

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

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Friends",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontSize)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: AnimatedList(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: widget.controller.key,
                      initialItemCount: Friends.items.length,
                      itemBuilder: (context, index, animation) {
                        return widget.controller.buildItem(
                            context, Friends.items[index], animation, index);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Text("");
          }
          else {
            return Column(
              
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontSize)),
                  ),
                ),
                IncorrectIP(),
              ],
            );
          }
        });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class FriendController {
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final Friends connectedWidget;



  ControllerCustomDropdown roomDropController =
      ControllerCustomDropdown<Room>();
  ControllerCustomDropdown locationDropController =
      ControllerCustomDropdown<Location>();

  FriendController(this.connectedWidget);

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET FRIENDS"}';
    channel.sink.add(data);
  }

  void setData(json) {
    Friends.items = [];
    Friends.roomItems = [];
    Friends.locationItems = [];

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var users = jsonData['users'];
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];

    for (int i = 0; i < users.length; i++) {
      User u =
          new User(users[i]['id'], users[i]['location_id'], users[i]['name']);
      Friends.items.add(u);
    }
    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(locations[i]['id'], locations[i]['room_id'],
          locations[i]['name'], locations[i]['x'], locations[i]['y']);
      Friends.locationItems.add(l);
    }
    for (int i = 0; i < rooms.length; i++) {
      Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'], rooms[i]['name'],
          rooms[i]['scanned']);
      Friends.roomItems.add(r);
    }
  }

  void removeItem(User user, int index) {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "DELETE FRIEND", "id": "${user.id}"}';
    channel.sink.add(data);

    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, user, animation, index);
    };
    Friends.items.remove(user);
    key.currentState.removeItem(index, build);
  }

  void updateItem(User user, Location location) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "UPDATE FRIEND", "user_id": "${user.id}", "location_id": ${location.id}}';
    channel.sink.add(data);

    for (int i = 0; i < Friends.items.length; i++) {
      if (Friends.items[i].id == user.id) {
        user.setValue(location.id);
        AnimatedListRemovedItemBuilder build = (context, animation) {
          return buildItem(context, Friends.items[i], animation, i);
        };

        key.currentState.removeItem(i, build);
        Friends.items.remove(Friends.items[i]);

        Friends.items.add(user);
        key.currentState.insertItem(i);
      }
    }
  }

  Widget buildItem(
      BuildContext context, User item, Animation animation, int index) {
    String locationName = '';
    String roomName = '';
    for (int i = 0; i < Friends.locationItems.length; i++) {
      if (item.locationID == Friends.locationItems[i].id) {
        Location location = Friends.locationItems[i];
        locationName = location.name;

        for (int y = 0; y < Friends.roomItems.length; y++) {
          if (location.roomId == Friends.roomItems[y].id) {
            roomName = Friends.roomItems[y].name;
          }
        }
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
                flex: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: MyApp.id != item.id
                        ? <Widget>[
                            IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {
                                messageDialog(context, item);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                bool delete = await StatusMessages.onDelete(context);
                                if (delete != null && delete) {
                                  removeItem(item, index);
                                }
                              },
                            )
                          ]
                        : <Widget>[
                            IconButton(
                              icon: Icon(Icons.create),
                              onPressed: () {
                                editItemDialog(context, item);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.assignment_ind_rounded),
                              onPressed: () {},
                            )
                          ]),
              ),
            ],
          ),
          subtitle: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(children: <Widget>[
                Text(roomName + " - ",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                    locationName != ''
                        ? locationName
                        : "No active location set",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))
              ])),
        ),
      ),
    );
  }

  void editItemDialog(BuildContext context, User user) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        List<Location> selectedLocations = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text("Deinen aktuellen Platz ändern"),
                content: Column(
                  children: <Widget>[
                    CustomDropdownLabel(
                      label: Text("Raum"),
                      child: CustomDropdownMenu<Room>(
                          onChanged: (value) {
                            List<Location> buffer = [];
                            for (int i = 0;
                                i < Friends.locationItems.length;
                                i++) {
                              if (Friends.locationItems[i].roomId ==
                                  roomDropController.getValue().id) {
                                buffer.add(Friends.locationItems[i]);
                              }
                            }
                            setState(() {
                              selectedLocations = [];
                              selectedLocations.addAll(buffer);
                              connectedWidget.currentvalueRoom = value;
                            });
                          },
                          startValueId: connectedWidget.currentvalueRoom,
                          controller: roomDropController,
                          data: Friends.roomItems),
                    ),
                    CustomDropdownLabel(
                      label: Text("Platz"),
                      child: CustomDropdownMenu<Location>(
                          controller: locationDropController,
                          data: selectedLocations),
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
                    child: Text("Ändern"),
                    onPressed: () {
                      if (roomDropController.getValue() != null &&
                          locationDropController.getValue() != null) {
                        updateItem(user, locationDropController.getValue());
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

  void messageDialog(BuildContext context, User user) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text("Nachricht senden"),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
              height: height,
              width: width,
              child: SingleChildScrollView(child: Messages(user)));
        }),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen", style: TextStyle(color: Colors.white)),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
