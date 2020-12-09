import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/no_data_entered.dart';
import 'package:turtlebot/frameworks/top_app_bar_logout.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Messages extends StatefulWidget {
  final MessageController controller = new MessageController();
  final User selectedUser;

  static Location activeLocation;
  static Room activeRoom;

  static List<User> items = [];

  Messages(this.selectedUser, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MessageState();
  }
}

class _MessageState extends State<Messages> {
  final channel = MyApp.con();

  TextEditingController _subject = new TextEditingController();
  TextEditingController _message = new TextEditingController();

  ControllerCustomDropdown dropController = ControllerCustomDropdown<User>();

  final colorTheme = Colors.orange;

  double _fontsize = 18;
  double _leftStart = 40;
  double _topSpace = 15;
  double _spaceRightLabel = 20;

  get spaceRightLabel {
    return _spaceRightLabel;
  }

  get topSpace {
    return _topSpace;
  }

  get fontsize {
    return _fontsize;
  }

  get leftStart {
    return _leftStart;
  }

  @override
  void initState() {
    super.initState();

    widget.controller.getData(channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBarLogout(
            colorTheme: colorTheme,
            page: "Home"
        ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: BoxDecoration(
                    color: colorTheme.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(4, 7),
                        spreadRadius: 1,
                        blurRadius: 8,
                      )
                    ]),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Aktuelle Location",
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                      elevation: 2,
                      child: ListTile(
                        title: Container(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  Messages.activeLocation != null
                                  ? Messages.activeLocation.name
                                  : "Keine aktive Location ausgewählt"
                              )
                          ),
                        ),
                        subtitle: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                                Messages.activeRoom != null
                                ? Messages.activeRoom.name
                                : '',
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
                margin: EdgeInsets.fromLTRB(25, 15, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Nachricht",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
              ),
              StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {

                    widget.controller.setData(snapshot.data);

                    // Logic for Send Message directly Button on Friends Page
                    int startValueIndex;
                    if(widget.selectedUser != null) {
                      for(int i = 0; i < Messages.items.length; i++) {
                        if(widget.selectedUser.id == Messages.items[i].id) {
                          dropController.setValue(widget.selectedUser);
                          startValueIndex = i;
                        }
                      }
                    }

                    return CustomDropdownLabel(
                      label: Text("Empfänger:"),
                      child: CustomDropdownMenu<User>(
                        controller: dropController,
                        data: Messages.items,
                        startValueId: startValueIndex,
                      ),
                    );
                  }
              ),
              Container(
                margin: EdgeInsets.fromLTRB(leftStart, 15, 20, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                          child: Text(
                        "Betreff:",
                        style: TextStyle(fontSize: fontsize),
                      )),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _subject,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(),
                        maxLength: 25,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.fromLTRB(
                        leftStart, topSpace, 0, 0),
                    child: Text("Nachricht: ",
                        style: TextStyle(fontSize: fontsize))),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    leftStart, topSpace, leftStart, 0),
                child: TextFormField(
                  controller: _message,
                  maxLines: null,
                  maxLength: 300,
                )),
              Container(
                margin: EdgeInsets.fromLTRB(0, topSpace, 0, 0),
                child: RaisedButton(
                  onPressed: () {

                    if(dropController.getValue() != null && _subject.text.isNotEmpty && _message.text.isNotEmpty) {
                      widget.controller.sendMessage(dropController.getValue(), _subject.text, _message.text);
                      _showAlertDialog();
                    }
                    else {
                      NoDataDialog.noLoginData(context);
                    }
                  },
                  child: Text("Auftrag starten"),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Geklappt!'),
          content: Text(
              'Du hast den Auftrag für ${dropController.getValue().name} gestartet:\n\n${_message.text}'
          ),
          actions: <Widget> [
              FlatButton(
                onPressed: (){
                  _subject.text = '';
                  _message.text = '';
                  Navigator.of(context).pop();
                },
                child: Text('Weiter'))
          ]
        );
      }
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class MessageController {

  void getData(WebSocketChannel channel) {
    String data = '{"action": "GET USERS"}';
    channel.sink.add(data);
  }

  void setData(json) {
    Messages.items = [];
    Messages.activeRoom = null;
    Messages.activeLocation = null;

    String jsonDataString = json.toString();
    var jsonData = jsonDecode(jsonDataString);
    var users = jsonData['users'];
    var locations = jsonData['locations'];
    var rooms = jsonData['rooms'];

    User user;

    for (int i = 0; i < users.length; i++) {
      User u = new User(
          users[i]['id'], users[i]['location_id'],
          users[i]['name']);
      Messages.items.add(u);

      if(u.id == MyApp.id) { user = u; }
    }

    for (int i = 0; i < locations.length; i++) {
      Location l = new Location(locations[i]['id'], locations[i]['room_id'],
          locations[i]['name'], locations[i]['x'], locations[i]['y']);
      if(user.locationID == l.id){
        Messages.activeLocation = l;
        for (int i = 0; i < rooms.length; i++) {
          Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'], rooms[i]['name'],
              rooms[i]['scanned']);
          if(Messages.activeLocation.roomId == r.id){
            Messages.activeRoom = r;
          }
        }
      }
    }
  }

  void sendMessage(User user, String subject, String message) {
    WebSocketChannel channel = MyApp.con();

    String data = '{"action": "SEND MESSAGE", "from_user": ${MyApp.id}, "to_user": ${user.id}, "subject": "$subject", "message": "$message"}';
    channel.sink.add(data);
  }
}
