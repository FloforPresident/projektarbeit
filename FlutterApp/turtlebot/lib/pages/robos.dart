import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Robos extends StatefulWidget {
  final channel = MyApp.con();

  Robos({Key key}) : super(key: key);

  @override
  _RoboState createState() {
    return _RoboState();
  }
}

class _RoboState extends State<Robos> {
  List<Robo> items = [];
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final colorTheme = Colors.blue;

  @override
  void initState() {
    super.initState();
    getRobos();
  }

  void getRobos() {
    int userID = MyApp.id;
    String data = '{"action": "GET ROBOS", "userID": $userID}';
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
        title: Text("Connected Robos"),
        backgroundColor: colorTheme,
      ),
      body: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String jsonDataString = snapshot.data.toString();
              var jsonData = jsonDecode(jsonDataString);

              for (int i = 0; i < jsonData.length; i++) {
                Robo r = new Robo(jsonData[i]['robo_id'], jsonData[i]['name'],
                    jsonData[i]['ip']);
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
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: colorTheme,
        onPressed: () {
          _RobosController addItemCon = _RobosController(colorTheme);
          addItemCon.addItemDialog(context);
        },
      ),
    );
  }

  Widget buildItem(Robo item, Animation animation, int index) {
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
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Text(item.iP),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _RobosController deleteItemCon =
                            _RobosController(colorTheme);
                        deleteItemCon.removeItem(item);
                        RouteGenerator.onTapToRobos(context);
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

class _RobosController {
  final Color colorTheme;
  WebSocketChannel channel;

  _RobosController(this.colorTheme) {
    channel = MyApp.con();
  }

  void removeItem(Robo robo) {
    int id = robo.id;
    String data = '{"action": "DELETE ROBO", "id": "$id"}';
    channel.sink.add(data);
  }

  void addItem(String name, String ip) {
    String data = '{"action": "ADD ROBO", "name": "$name", "ip": "$ip"}';
    channel.sink.add(data);
  }

  void addItemDialog(BuildContext context) {
    TextEditingController _name = TextEditingController();
    TextEditingController _ip = TextEditingController();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new Robo"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: "Name"),
                maxLines: null,
                maxLength: 20,
              ),
              TextField(
                controller: _ip,
                decoration: InputDecoration(labelText: "IP-Address"),
                maxLines: null,
                maxLength: 20,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                if (_name.text.isNotEmpty && _ip.text.isNotEmpty) {
                  addItem(_name.text, _ip.text);
                  RouteGenerator.onTapToRobos(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
