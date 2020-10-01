import 'package:flutter/material.dart';
import 'package:turtlebot/socket_model/socket_model.dart';
import 'package:turtlebot/databaseObjects/data_base_objects.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  ControllerMessages controller = ControllerMessages();

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
          backgroundColor: Colors.orange,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.controller.createDropdownMenu(
                  state: this,
                  data: <User>[User(1, "Hans", 1), User(2, "Verena", 2)],
                  label: "Recipient"),
              widget.controller.createDropdownMenu(
                  state: this,
                  data: <Room>[Room(1, "First Floor"), Room(2, "Second Floor")],
                  label: "Rooms"),
              widget.controller.createDropdownMenu(
                  state: this,
                  data: <LocationID>[
                    LocationID(1, 1, 1, "Kitchen"),
                    LocationID(2, 2, 2, "Bath"),
                  ],
                  label: "Location"),
              widget.controller.createDropdownMenu(
                  state: this,
                  data: <Robo>[
                    Robo("Robob", "192.168.2.14", 1),
                    Robo("Volley", "192.168.2.15", 2)
                  ],
                  label: "Robots"),
              Container(
                margin: EdgeInsets.fromLTRB(widget.controller.leftStart,15,20,0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                          child: Text(
                        "Subject:",
                        style: TextStyle(fontSize: widget.controller.fontsize),
                      )),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(),
                      ),
                    ),
                    Spacer(flex: 2,)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void refreshState() {
    setState(() {});
  }
}

class ControllerMessages {
  int _activeUser;
  int _activeLocation;
  int _activeRoom;
  int _activeRobo;
  double _fontsize = 18;
  double _leftStart = 40;

  get fontsize {
    return _fontsize;
  }

  get leftStart
  {
    return _leftStart;
  }

  void set activeUser(int value) {
    this._activeUser = value;
  }

  get activeUser {
    return _activeUser;
  }

  void set activeLocation(int value) {
    this._activeLocation = value;
  }

  get activeLocation {
    return _activeLocation;
  }

  void set activeRoom(int value) {
    this._activeRoom = value;
  }

  get activeRoom {
    return _activeRoom;
  }

  void set activeRobo(int value) {
    this._activeRobo = value;
  }

  get activeRobo {
    return _activeRobo;
  }

  createDropdownMenu<T extends DatabaseObject>(
      {@required _MessagesState state,
      @required List<T> data,
      @required String label}) {
    int value;

    switch (T) {
      case User:
        value = activeUser;
        break;
      case Room:
        value = activeRoom;
        break;
      case LocationID:
        value = activeLocation;
        break;
      case Robo:
        value = activeRobo;
        break;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: Text(label + ":", style: TextStyle(fontSize: _fontsize)),
              margin: EdgeInsets.fromLTRB(leftStart, 0, 20, 0),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton(
              isExpanded: true,
              value: value,
              hint: Text(label),
              items: _createDropdownMenuItem(data),
              onChanged: (value) {
                switch (T) {
                  case User:
                    activeUser = value;
                    break;
                  case Room:
                    activeRoom = value;
                    break;
                  case LocationID:
                    activeLocation = value;
                    break;
                  case Robo:
                    activeRobo = value;
                    break;
                }
                state.refreshState();
              },
            ),
          ),
          Spacer(
            flex: 2,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  List<DropdownMenuItem> _createDropdownMenuItem(List<DatabaseObject> objects) {
    return objects.map((row) {
      return DropdownMenuItem(
        value: row.id,
        child: Text(row.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<T>> produceDropdowMenuItemList<T>(List<List> items) {
    Iterator iterator = items.iterator;
    List<DropdownMenuItem> result;

//    while(iterator.moveNext())
//      {
//        result.add(DropdownMenuItem(child: Text(iterator.moveNext()),))
//      }
  }
}
