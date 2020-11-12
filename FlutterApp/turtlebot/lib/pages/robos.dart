import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:turtlebot/socket_model/socket_model.dart';

class Robos extends StatelessWidget
{
  final WebSocketChannel channel;
  _RobosController controller;

  Robos({Key key, @required this.channel}) : super(key: key) {
    this.controller = _RobosController(Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Robos"),
        backgroundColor: controller.colorTheme,
      ),
      body: AnimatedList(
        key: controller._key,
        initialItemCount: controller.items.length,
        itemBuilder: (context, index, animation) {
          return controller.buildItem(
              context, controller.items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: controller.colorTheme,
        onPressed: () {
         controller.addItemDialog(context);
        },
      ),
    );
  }
}

class _RobosController {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme;
  List<Robo> _items;
  String noRoomText = "noRoom";
  TextEditingController nameCon = TextEditingController();
  TextEditingController ipCon = TextEditingController();
  ControllerCustomDropdown dropController = ControllerCustomDropdown<Room>();

  _RobosController(this._colorTheme) {
    this._items = _getData();
  }

  List<Robo> _getData() {
    return [
      Robo("Robob", "192.185.2.26",1,Room(1,"living-room")),
      Robo("Nummer5", "192.185.2.52",2,Room(2,"home")),
      Robo("McSundae", "192.185.2.45",3,Room(3,"burgerkind")),
      Robo("Mcflurry", "192.185.2.33",4,Room(4,"mcdonalds")),
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
      BuildContext context, Robo robo, Animation animation, int index)
  {


    String roomText = (robo.activeRoom == null) ? "no room" : robo.activeRoom.name;
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
                    Text(robo.name + " "),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Text(robo.iP + " "),
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
                      onPressed: () async {
                        if(await OnDelete.onDelete(context))
                          {
                            removeItem(index);
                          }

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
    Robo removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void addItem(Robo newRobo)
  {
    int end = _items.length;
    _items.add(newRobo);
    AnimatedListItemBuilder build = (context,index,animation)
    {
      return buildItem(context, _items[index], animation, index);
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
                child: CustomDropdownMenu<Room>(
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
                addItem(Robo(nameCon.text,ipCon.text, SocketModel.getNewId("Robo"),dropController.getValue()));
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
