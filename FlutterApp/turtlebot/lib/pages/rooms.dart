import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Rooms extends StatefulWidget {
  final channel = MyApp.con();

  Rooms({Key key}) : super(key: key);

  @override
  _RoomState createState() {
    return _RoomState();
  }
}

class _RoomState extends State<Rooms> {
  List<Room> items = [];
  List<Robo> roboItems = [];
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final colorTheme = Colors.green;

  @override
  void initState() {
    super.initState();
    // broadcast = widget.channel.stream.asBroadcastStream();

    getRooms();
  }

  void getRooms() {
    int userID = MyApp.id;
    String data = '{"action": "GET ROOMS"}';
    widget.channel.sink.add(data);
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
          titleText: "Rooms",
        ),
        backgroundColor: colorTheme,
      ),
      body: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String jsonDataString = snapshot.data.toString();
              var jsonData = jsonDecode(jsonDataString);
              var rooms = jsonData['rooms'];
              var robos = jsonData['robos'];

              for (int i = 0; i < rooms.length; i++) {
                Room r = new Room(rooms[i]['room_id'], rooms[i]['robo_id'],
                    rooms[i]['title']);
                items.add(r);
              }
              for (int i = 0; i < robos.length; i++) {
                Robo r = new Robo(
                    robos[i]['robo_id'], robos[i]['name'], robos[i]['ip']);
                roboItems.add(r);
              }

              return AnimatedList(
                key: key,
                initialItemCount: items.length,
                itemBuilder: (context, index, animation) {
                  return buildItem(items[index], animation, index);
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
          _RoomsController addItemCon = _RoomsController(colorTheme);
          addItemCon.addItemDialog(context, roboItems);
        },
      ),
    );
  }

  Widget buildItem(Room item, Animation animation, int index) {
    String roboName = '';
    for (int i = 0; i < roboItems.length; i++) {
      if (item.roboID == roboItems[i].id) {
        roboName = roboItems[i].name;
      }
    }

    Icon _selected =
        (true) ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank);

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
                    child: _selected,
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
                        _RoomsController updateItemCon = _RoomsController(colorTheme);
                        updateItemCon.editItemDialog(context, item, roboItems);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool delete = await OnDelete.onDelete(context);
                        if (delete) {
                          _RoomsController deleteItemCon =
                              _RoomsController(colorTheme);
                          deleteItemCon.removeItem(item);
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
              child: Text(roboName != '' ? roboName : 'No Robo selected',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}

class _RoomsController {
  final Color colorTheme;
  WebSocketChannel channel;
  ControllerCustomDropdown dropController = ControllerCustomDropdown<Robo>();

  _RoomsController(this.colorTheme) {
    channel = MyApp.con();
  }

  void removeItem(Room room) {
    int id = room.id;
    String data = '{"action": "DELETE ROOM", "id": "$id"}';
    channel.sink.add(data);
  }

  void addItem(int roboID, String name) {
    String data =
        '{"action": "ADD ROOM", "roboID": "$roboID", "name": "$name"}';
    channel.sink.add(data);
  }

  void updateItem(Room room, Robo robo) {
    String data =
        '{"action": "UPDATE ROBO", "room_id": ${room.id}, "robo_id": ${robo.id}}';
    channel.sink.add(data);
  }

  void editItemDialog(BuildContext context, Room room, List<Robo> roboItems) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          List<Location> selectedLocations = [];
          return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                    child: AlertDialog(
                      title: Text("Update your settings"),
                      content: Column(
                        children: <Widget>[
                          CustomDropdownLabel(
                            label: "Robo",
                            child: CustomDropdownMenu<Robo>(
                                controller: dropController,
                                data: roboItems),
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
                          child: Text("Update"),
                          onPressed: () {
                            if(dropController.getValue() != null) {
                              updateItem(room, dropController.getValue());
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

  void addItemDialog(BuildContext context, List<Robo> roboItems) {
    TextEditingController controller = TextEditingController();
    bool _roomScanned = true;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new Room"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Name"),
              ),
              CustomDropdownLabel(
                label: "Robo",
                child: CustomDropdownMenu<Robo>(
                    controller: dropController, data: roboItems),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("StartRoomScan"),
                  color: colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                title: Text("RoomScanned"),
                value: _roomScanned,
                onChanged: (bool value) {},
              )
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
                if (controller.text.isNotEmpty &&
                    _roomScanned == true &&
                    dropController.getValue() != null) {
                  addItem(dropController.getValue().id, controller.text);
                  RouteGenerator.onTapToRooms(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
