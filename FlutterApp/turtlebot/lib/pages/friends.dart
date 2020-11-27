import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Friends extends StatefulWidget {
  final channel = MyApp.con();

  Friends({Key key}) : super(key: key);

  @override
  _FriendState createState() {
    return _FriendState();
  }
}

class _FriendState extends State<Friends> {
  List<User> items = [];
  List<Location> locationItems = [];
  List<Room> roomItems = [];

  final GlobalKey<AnimatedListState> key = GlobalKey();
  final colorTheme = Colors.red;

  @override
  void initState() {
    super.initState();
    // broadcast = widget.channel.stream.asBroadcastStream();

    getUsers();
  }

  void getUsers() {
    String data = '{"action": "GET FRIENDS"}';
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
            }),
        title: Text("Robo Friends"),
        backgroundColor: colorTheme,
      ),
      body: StreamBuilder(
        stream: widget.channel.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            String jsonDataString = snapshot.data.toString();
            var jsonData = jsonDecode(jsonDataString);
            var users = jsonData['users'];
            var locations = jsonData['locations'];
            var rooms = jsonData['rooms'];

            for(int i = 0; i < users.length; i++) {
              User u = new User(users[i]['user_id'], users[i]['location_id'],
                  users[i]['username']);
              items.add(u);
            }
            for (int i = 0; i < locations.length; i++) {
              Location l = new Location(
                  locations[i]['location_id'],
                  locations[i]['room_id'],
                  locations[i]['title'],
                  locations[i]['x'],
                  locations[i]['y']);
              locationItems.add(l);
            }
            for (int i = 0; i < rooms.length; i++) {
              Room r = new Room(rooms[i]['room_id'], rooms[i]['robo_id'],
                  rooms[i]['title']);
              roomItems.add(r);
            }

            return AnimatedList(
                shrinkWrap: true,
                key: key,
                initialItemCount: items.length,
                itemBuilder: (context, index, animation) {
                  return buildItem(items[index], animation, index);
                },
              );
          } else {
            return Text('');
          }

        }
      )
    );
  }

  Widget buildItem(User item, Animation animation, int index) {
    String locationName = '';
    String roomName = '';
    for(int i = 0; i < locationItems.length; i++) {
      if(item.locationID == locationItems[i].id) {
        Location location = locationItems[i];
        locationName = location.name;

        for(int y = 0; y < roomItems.length; y++) {
          if(location.roomId == roomItems[y].id) {
            roomName = roomItems[y].name;

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
                  children:
                  MyApp.id != item.id
                  ? <Widget>[
                    IconButton(
                      icon: Icon(Icons.email),
                      onPressed: () {
                        RouteGenerator.onTapToMessages(context, selectedUser: item);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool delete = await OnDelete.onDelete(context);
                        if(delete) {
                          _FriendsController deleteItemCon = _FriendsController(colorTheme);
                          deleteItemCon.removeItem(item);
                          RouteGenerator.onTapToFriends(context);
                        }
                      },
                    )
                  ]
                  : <Widget> [Icon(Icons.assignment_ind_rounded)]
                ),
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
                Text(locationName != '' ? locationName : "No active location set")
              ])),
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

class _FriendsController {
  final Color colorTheme;
  WebSocketChannel channel;

  _FriendsController(this.colorTheme) {
    channel = MyApp.con();
  }

  void removeItem(User user) {
    int id = user.id;
    String data = '{"action": "DELETE FRIEND", "id": "$id"}';
    channel.sink.add(data);
  }
}
