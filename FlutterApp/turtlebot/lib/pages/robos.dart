import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:turtlebot/databaseObjects/data_base_objects.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';

class Robos extends StatefulWidget {
  _RobosController controller;

  Robos({Key key}) : super(key: key) {
    this.controller = _RobosController(Colors.blue);
  }

  @override
  _RobosState createState() {
    return _RobosState();
  }
}

class _RobosState extends State<Robos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Robos"),
        backgroundColor: widget.controller.colorTheme,
      ),
      body: AnimatedList(
        key: widget.controller._key,
        initialItemCount: widget.controller.items.length,
        itemBuilder: (context, index, animation) {
          return widget.controller.buildItem(
              context, widget.controller.items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: widget.controller.colorTheme,
        onPressed: () {
         widget.controller.addItemDialog(context);
        },
      ),
    );
  }
}

class _RobosController {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  Color _colorTheme;
  List<List> _items;
  String noRoomText = "noRoom";
  TextEditingController nameCon = TextEditingController();
  TextEditingController ipCon = TextEditingController();
  ControllerCustomDropdown dropController = ControllerCustomDropdown<Room>();

  _RobosController(this._colorTheme) {
    this._items = _getData();
  }

  List<List> _getData() {
    return [
      ["Robob", "192.185.2.26",Room(1,"living-room")],
      ["Number 5", "192.185.2.55",Room(2,"dining-room")],
      ["Robobross", "192.185.2.234", Room(3,"study-room")],
      ["McFlurryMachine", "192.185.2.26", Room(4, "basement")],
    ];
  }

  get colorTheme {
    return Color(_colorTheme.value);
  }

  get items {
    return _items;
  }

  get key {
    return _key;
  }

  Widget buildItem(
      BuildContext context, List item, Animation animation, int index)
  {
    String roomText = (item[2] == noRoomText) ? "no room" : (item[2] as Room).name;
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
                    Text(item[0] + " "),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Text(item[1] + " "),
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
                      onPressed: ()  {
                        OnDelete.onDelete(context);

                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          subtitle: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(roomText,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      ),
    );
  }

  void removeItem(int index) {
    List removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void addItem(String name, String ip, Room room)
  {
    int end = _items.length;
    var currentRoom = (room == null) ? noRoomText : room;
    _items.add([name,ip,currentRoom]);
    AnimatedListItemBuilder build = (context,index,animation)
    {
      return buildItem(context, _items, animation, index);
    };

    _key.currentState.insertItem(end);
  }

  Future<bool> addItemDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new Robo"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: nameCon,
                decoration: InputDecoration(labelText: "Name"),
                maxLines: null,
                maxLength: 20,
              ),
              TextField(
                controller: ipCon,
                decoration: InputDecoration(labelText: "IP-Address"),
                maxLines: null,
                maxLength: 20,
              ),
              CustomDropdownLabel(
                label: "Position",
                child: CustomDropdownMenu(
                  controller: dropController,
                  data: [Room(1,"living-room"),Room(2, "dining-room")]
                ),
              )
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
                addItem(nameCon.text,ipCon.text,dropController.getValue());
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
