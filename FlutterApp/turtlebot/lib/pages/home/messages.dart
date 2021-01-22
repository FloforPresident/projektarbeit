import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:turtlebot/services/alertDialogs/error_messages.dart';
import 'package:turtlebot/frameworks/incorrect_ip_adress.dart';

class Messages extends StatefulWidget {
  final MessageController controller = new MessageController();
  final User selectedUser;
  final colorTheme = Colors.orange;

  double _fontsize = 18;
  double _leftStart = 40;
  double _topSpace = 5;
  double _spaceRightLabel = 20;
  Color textColor = Colors.black;

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

            // Logic for Send Message directly Button on Friends Page
            int startValueIndex;
            if (widget.selectedUser != null) {
              for (int i = 0; i < Messages.items.length; i++) {
                if (widget.selectedUser.id == Messages.items[i].id) {
                  dropController.setValue(widget.selectedUser);
                  startValueIndex = i;
                }
              }
            }

            return Container(
              child: Column(
                children: [
                  CustomDropdownLabel(
                    label: Text("Empfänger:", style: TextStyle(
                        color: widget.textColor
                    )),
                    child: CustomDropdownMenu<User>(
                      itemTextStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize, color: Colors.black),
                      dropButtonSize: 130,
                      controller: dropController,
                      data: Messages.items,
                      startValueId: startValueIndex,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text("Betreff:", style: TextStyle(
                            color: widget.textColor
                          ),),
                        ),
                        Container(
                          width: 130,
                          child: TextFormField(
                            cursorColor: widget.textColor,
                            controller: _subject,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              helperStyle: TextStyle(color: widget.textColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: widget.textColor, width: 0.25)
                              )
                            ),
                            maxLength: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, widget.topSpace, 0, 0),
                        child: Text("Nachricht: ", style: TextStyle(
                            color: widget.textColor
                        ))),
                  ),
                  Container(
                      child: TextFormField(
                    controller: _message,
                    maxLines: null,
                    maxLength: 300,
                        decoration: InputDecoration(
                            helperStyle: TextStyle(color: widget.textColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: widget.textColor, width: 0.5)
                            )
                        ),
                  )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, widget.topSpace, 0, 0),
                    child: RaisedButton(
                      onPressed: () {
                        if (dropController.getValue() != null &&
                            _subject.text.isNotEmpty &&
                            _message.text.isNotEmpty) {
                          widget.controller.sendMessage(
                              dropController.getValue(),
                              _subject.text,
                              _message.text);
                          StatusMessages.sendMessage(context, dropController.getValue(), _subject.text);
                          widget.controller.resetSubjectMessagesRecipient(_subject, _message, dropController);
                        } else {
                          ErrorMessages.fieldsNotFilled(context);
                        }
                      },
                      child: Text("Auftrag starten"),
                    ),
                  )
                ],
              ),
            );
          }          else if(snapshot.connectionState == ConnectionState.waiting){
            return Text("");
          } else {
            return IncorrectIP(padding: EdgeInsets.all(0));
          }
        });
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

  void resetSubjectMessagesRecipient(TextEditingController subject, TextEditingController message, ControllerCustomDropdown user)
  {
    subject.text = "";
    message.text = "";
    user.currentIndexValue = 0;
  }

  void setData(json) {
    Messages.items = [];

    String jsonDataString = json.toString();
    var users = jsonDecode(jsonDataString);

    for (int i = 0; i < users.length; i++) {
      User u =
          new User(users[i]['id'], users[i]['location_id'], users[i]['name']);
      Messages.items.add(u);
    }
  }

  void sendMessage(User user, String subject, String message) {
    WebSocketChannel channel = MyApp.con();

    String data =
        '{"action": "SEND MESSAGE", "from_user": ${MyApp.id}, "to_user": ${user.id}, "subject": "$subject", "message": "$message"}';
    channel.sink.add(data);
  }
}
