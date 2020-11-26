import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Messages extends StatefulWidget {
  final channel = MyApp.con();

  Messages({Key key}) : super(key: key) {
    controller = ControllerMessages(this, Colors.orange);
  }

  ControllerMessages controller;
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
  State<StatefulWidget> createState() {
    return _MessageState();
  }
}

class _MessageState extends State<Messages> {
  List<User> items = [];
  TextEditingController _subject = new TextEditingController();
  TextEditingController _message = new TextEditingController();


  @override
  void initState() {
    super.initState();

    getUsers();
  }

  void getUsers() {
    String data = '{"action": "GET USERS"}';
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
          title: Text("Send Message"),
          backgroundColor: widget.controller.colorTheme,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                    stream: widget.channel.stream,
                    builder: (context, snapshot) {
                      String jsonDataString = snapshot.data.toString();
                      var users = jsonDecode(jsonDataString);

                      for (int i = 0; i < users.length; i++) {
                        User u = new User(
                            users[i]['user_id'], users[i]['location_id'],
                            users[i]['username']);
                        items.add(u);
                      }

                      return CustomDropdownLabel(
                        label: "Recipient",
                        child: CustomDropdownMenu<User>(
                          controller: widget.controller.dropController,
                          data: items
                        ),
                      );
                    }
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(widget.leftStart, 15, 20, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                            child: Text(
                          "Subject:",
                          style: TextStyle(fontSize: widget.fontsize),
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
                          widget.leftStart, widget.topSpace, 0, 0),
                      child: Text("Message: ",
                          style: TextStyle(fontSize: widget.fontsize))),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(
                        widget.leftStart, widget.topSpace, widget.leftStart, 0),
                    child: TextFormField(
                      controller: _message,
                      maxLines: null,
                      maxLength: 300,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, widget.topSpace, 0, 0),
                  child: RaisedButton(
                    onPressed: () {

                      if(widget.controller.dropController.getValue() != null && _subject.text.isNotEmpty && _message.text.isNotEmpty) {
                        widget.controller.sendMessage(widget.controller.dropController.getValue(), _subject.text, _message.text);
                        _showAlertDialog(true);
                      }
                      else {
                        _showAlertDialog(false);
                      }
                    },
                    child: Text("Send Message"),
                  ),
                )
              ],
            ),
          ),
        ));
  }


  void _showAlertDialog(bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: success ? Text('Success'): Text('Error'),
          content: success ? Text(
              'You started a Job for ${widget.controller.dropController.getValue().name}: \n\n  ${_message.text}'
          ) : Text('Fill in all Fields'),
          actions: <Widget> [
              FlatButton(
                onPressed: (){
                  if(success) {
                    RouteGenerator.onTapToMessages(context);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Ok'))
          ]
        );
      }
    );
  }
}

class ControllerMessages {
  Color _colorTheme;
  ControllerCustomDropdown dropController = ControllerCustomDropdown<User>();

  Messages view;

  sendMessage(User user, String subject, String message) {
    WebSocketChannel channel = MyApp.con();

    String data = '{"action": "SEND MESSAGE", "from_user": ${MyApp.id}, "to_user": ${user.id}, "subject": "$subject", "message": "$message"}';
    channel.sink.add(data);
  }

  ControllerMessages(this.view, this._colorTheme);

  get colorTheme {
    return Color(_colorTheme.value);
  }
}
