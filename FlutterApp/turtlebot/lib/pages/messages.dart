import 'package:flutter/material.dart';
import 'package:turtlebot/databaseObjects/data_base_objects.dart';
import 'package:turtlebot/socket_model/socket_model.dart';

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
              widget.controller.createRecipientDropdownMenu(this,[1,"hans", 2, "werner"]),
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

  createRecipientDropdownMenu <T extends DatabaseObject> (_MessagesState state, List<T> data ) {

    int value;

    switch(T.runtimeType)
    {
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
          Container(
            child: Text("Recipient: ", style: TextStyle(fontSize: 18)),
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
          ),
          DropdownButton(
            value: value,
            hint: Text("Recipient"),
            items: [
              DropdownMenuItem(
                value: 1,
                child: Text("Hans"),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text("Hans2"),
              )
            ],
            onChanged: (value) {
              switch(T.runtimeType)
              {
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
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  List<DropdownMenuItem> createDropdownMenuItem<T>()
  {

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
