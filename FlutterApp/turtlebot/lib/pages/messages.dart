import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';

class Messages extends StatefulWidget {
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
    return _MessagesState();
  }
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Send Message"),
          backgroundColor: widget.controller.colorTheme,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomDropdownLabel(
                  label: "Recipient",
                  child: CustomDropdownMenu(
                    controller: widget.controller.dropController,
                    data: <User>[
                      User(1, "Hans", "living-room"),
                      User(2, "Verena", "dining-room")
                    ],
                  ),
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
                      maxLines: null,
                      maxLength: 300,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, widget.topSpace, 0, 0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Send Message"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class ControllerMessages {
  Color _colorTheme;
  ControllerCustomDropdown dropController = ControllerCustomDropdown<User>();

  Messages view;

  ControllerMessages(this.view, this._colorTheme);

  get colorTheme {
    return Color(_colorTheme.value);
  }
}
