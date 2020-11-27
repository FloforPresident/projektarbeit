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

    if(roomID != null) {
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

              if(widget.dropDownRoomId != null) {
                widget.controller.updateLocations(context, Locations.roomItems[widget.dropDownRoomId].id);
              }

              return Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: CustomDropdownLabel(
                    label: "Room",
                    child: CustomDropdownMenu<Room>(
                      onChanged: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('room_id', dropController.getCurrentIndex());

                        widget.controller.updateLocations(context, dropController.getValue().id);
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
                    return widget.controller.buildItem(context, Locations.activeItems[index], animation, index);
                  },
                )
              ]);
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
          title: Text("Add Location to $roomString"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: xController,
                decoration: InputDecoration(labelText: "X-Coordinate"),
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(labelText: "Y-Coordinate"),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
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
          rooms[i]['title']);
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

  void updateLocations(BuildContext context, int roomId) {
    bool inserted = false;
    int indexRemoveableItem = 0;

    for(int i = 0; i < Locations.items.length; i++) {
      for(int y = 0; y < Locations.activeItems.length; y++) {
        if(Locations.items[i].id == Locations.activeItems[y].id) {
          inserted = true;
          indexRemoveableItem = y;
        }
      }
      if(Locations.items[i].roomId == roomId && !inserted){
        int end = Locations.activeItems.length;
        Locations.activeItems.add(Locations.items[i]);

        AnimatedListItemBuilder build = (context, index, animation) {
          return buildItem(context, Locations.activeItems[index], animation, index);
        };
        if(key.currentState != null) {
          key.currentState.insertItem(end);
        }
      }
      else if(Locations.items[i].roomId != roomId && inserted) {
        Location removeItem = Locations.activeItems.removeAt(indexRemoveableItem);
        AnimatedListRemovedItemBuilder build = (context, animation) {
          return buildItem(context, removeItem, animation, indexRemoveableItem);
        };
        if(key.currentState != null) {
          key.currentState.removeItem(indexRemoveableItem, build);
        }
      }
      inserted = false;
    }
  }

  Widget buildItem(BuildContext context, Location item, Animation animation, int index) {
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
                      onPressed: () {},
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
}

// class Locations extends StatefulWidget {
//   final channel = MyApp.con();
//   int dropDownRoomId;
//
//   Locations({Key key}) : super(key: key);
//
//   @override
//   _LocationsState createState() {
//     return _LocationsState();
//   }
// }
//
// class _LocationsState extends State<Locations> {
//   List<Location> items = [];
//   List<Location> activeItems = [];
//   List<Room> roomItems = [];
//
//   final GlobalKey<AnimatedListState> key = GlobalKey();
//   final colorTheme = Colors.pink;
//   ControllerCustomDropdown dropController = ControllerCustomDropdown<Room>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     getLocations();
//     getSelectedRoom();
//   }
//
//   void getLocations() {
//     String data = '{"action": "GET LOCATIONS"}';
//     widget.channel.sink.add(data);
//   }
//
//   void getSelectedRoom() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final int roomID = prefs.getInt('room_id');
//
//     if(roomID != null) {
//       setState(() {
//         widget.dropDownRoomId = roomID;
//       });
//     }
//   }
//
//   void updateLocations(int roomId) {
//     bool inserted = false;
//     int indexRemoveableItem = 0;
//
//     for(int i = 0; i < items.length; i++) {
//       for(int y = 0; y < activeItems.length; y++) {
//         if(items[i].id == activeItems[y].id) {
//           inserted = true;
//           indexRemoveableItem = y;
//         }
//       }
//       if(items[i].roomId == roomId && !inserted){
//         int end = activeItems.length;
//         activeItems.add(items[i]);
//
//         AnimatedListItemBuilder build = (context, index, animation) {
//           return buildItem(activeItems[index], animation, index);
//         };
//         if(key.currentState != null) {
//           key.currentState.insertItem(end);
//         }
//       }
//       else if(items[i].roomId != roomId && inserted) {
//         Location removeItem = activeItems.removeAt(indexRemoveableItem);
//         AnimatedListRemovedItemBuilder build = (context, animation) {
//           return buildItem(removeItem, animation, indexRemoveableItem);
//         };
//         if(key.currentState != null) {
//           key.currentState.removeItem(indexRemoveableItem, build);
//         }
//       }
//       inserted = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             RouteGenerator.onTapToHome(context);
//           },
//         ),
//         backgroundColor: colorTheme,
//         title: TopAppBar(
//           navigationFields: <Widget>[
//             TopBarImageIcon(
//                 Icon(Icons.map, size: 30), RouteGenerator.onTapToRooms),
//             TopBarImageIcon(
//                 Icon(Icons.room, color: Colors.white, size: 30), (context) {}),
//           ],
//           titleText: "Locations",
//         ),
//       ),
//       body: StreamBuilder(
//           stream: widget.channel.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               String jsonDataString = snapshot.data.toString();
//               var jsonData = jsonDecode(jsonDataString);
//               var locations = jsonData['locations'];
//               var rooms = jsonData['rooms'];
//
//               for (int i = 0; i < locations.length; i++) {
//                 Location l = new Location(
//                     locations[i]['location_id'],
//                     locations[i]['room_id'],
//                     locations[i]['title'],
//                     locations[i]['x'],
//                     locations[i]['y']);
//                 items.add(l);
//                 activeItems.add(l);
//               }
//               for (int i = 0; i < rooms.length; i++) {
//                 Room r = new Room(rooms[i]['room_id'], rooms[i]['robo_id'],
//                     rooms[i]['title']);
//                 roomItems.add(r);
//               }
//
//               if(widget.dropDownRoomId != null) {
//                 updateLocations(roomItems[widget.dropDownRoomId].id);
//               }
//
//               return Column(children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
//                   child: CustomDropdownLabel(
//                     label: "Room",
//                     child: CustomDropdownMenu<Room>(
//                       onChanged: () async {
//                         final SharedPreferences prefs = await SharedPreferences.getInstance();
//                         prefs.setInt('room_id', dropController.getCurrentIndex());
//
//                         updateLocations(dropController.getValue().id);
//                       },
//                       startValueId: widget.dropDownRoomId,
//                       controller: dropController,
//                       data: roomItems,
//                     ),
//                   ),
//                 ),
//                 AnimatedList(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   key: key,
//                   initialItemCount: activeItems.length,
//                   itemBuilder: (context, index, animation) {
//                     return buildItem(activeItems[index], animation, index);
//                   },
//                 )
//               ]);
//             } else {
//               return Text('');
//             }
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (dropController.getValue() != null) {
//             _LocationsController addItemCon = _LocationsController(colorTheme);
//             addItemCon.addItemDialog(context, dropController.getValue());
//           }
//         },
//         backgroundColor: colorTheme,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget buildItem(Location item, Animation animation, int index) {
//     return SizeTransition(
//       sizeFactor: animation,
//       child: Card(
//         elevation: 2,
//         child: ListTile(
//           title: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 4,
//                 child: Row(
//                   children: <Widget>[
//                     Text(item.name),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.create),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () async {
//                         bool delete = await OnDelete.onDelete(context);
//                         if (delete) {
//                           _LocationsController deleteItemCon =
//                               _LocationsController(colorTheme);
//                           deleteItemCon.removeItem(item);
//                           RouteGenerator.onTapToLocations(context);
//                         }
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     super.dispose();
//   }
// }
//
// class _LocationsController {
//   final Color colorTheme;
//   WebSocketChannel channel;
//
//   _LocationsController(this.colorTheme) {
//     channel = MyApp.con();
//   }
//
//   void removeItem(Location location) {
//     int id = location.id;
//     String data = '{"action": "DELETE LOCATION", "id": "$id"}';
//     channel.sink.add(data);
//   }
//
//   void addItem(int roomID, String title, double x, double y) {
//     String data =
//         '{"action": "ADD LOCATION", "roomID": "$roomID", "title": "$title", "x": "$x", "y": "$y"}';
//     channel.sink.add(data);
//   }
//
//   void setActiveItem(int locationID) {
//     int userID = MyApp.id;
//     String data =
//         '{"action": "SET LOCATION", "userID": "$userID", "locationID": "$locationID"}';
//     channel.sink.add(data);
//   }
//
//   void addItemDialog(BuildContext context, Room room) {
//     TextEditingController titleController = TextEditingController();
//     TextEditingController xController = TextEditingController();
//     TextEditingController yController = TextEditingController();
//
//     String roomString = room.name;
//
//     showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) => SingleChildScrollView(
//         child: AlertDialog(
//           title: Text("Add Location to $roomString"),
//           content: Column(
//             children: <Widget>[
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(labelText: "Name"),
//               ),
//               TextField(
//                 controller: xController,
//                 decoration: InputDecoration(labelText: "X-Coordinate"),
//               ),
//               TextField(
//                 controller: yController,
//                 decoration: InputDecoration(labelText: "Y-Coordinate"),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("No"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             FlatButton(
//               child: Text("Yes"),
//               onPressed: () {
//                 if (titleController.text.isNotEmpty &&
//                     xController.text.isNotEmpty &&
//                     yController.text.isNotEmpty) {
//                   addItem(
//                       room.id,
//                       titleController.text,
//                       double.parse(xController.text),
//                       double.parse(yController.text));
//                   RouteGenerator.onTapToLocations(context);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
