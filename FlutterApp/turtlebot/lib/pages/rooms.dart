import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
    String data = '{"action": "GET ROOMS", "userID": $userID}';
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

              for (int i = 0; i < jsonData.length; i++) {
                Room r = new Room(jsonData[i]['room_id'], jsonData[i]['title']);
                items.add(r);
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
          _ControllerRooms addItemCon = _ControllerRooms(colorTheme);
          addItemCon.addItemDialog(context);
        },
      ),
    );
  }

  Widget buildItem(Room item, Animation animation, int index) {
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _ControllerRooms deleteItemCon =
                            _ControllerRooms(colorTheme);
                        deleteItemCon.removeItem(item);
                        RouteGenerator.onTapToRooms(context);
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

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}

class _ControllerRooms {
  final Color colorTheme;
  WebSocketChannel channel;

  _ControllerRooms(this.colorTheme) {
    channel = MyApp.con();
  }

  void removeItem(Room room) {
    int id = room.id;
    String data = '{"action": "DELETE ROOM", "id": "$id"}';
    channel.sink.add(data);
  }

  void addItem(String name) {
    String data = '{"action": "ADD ROOM", "name": "$name"}';
    channel.sink.add(data);
  }

  void addItemDialog(BuildContext context) {
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
                if (controller.text.isNotEmpty && _roomScanned == true) {
                  addItem(controller.text);
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
