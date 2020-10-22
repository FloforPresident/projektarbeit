import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';

class Rooms extends StatelessWidget {
  _ControllerRooms controller;

  Rooms({Key key}) : super(key: key) {
    this.controller = _ControllerRooms(Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            RouteGenerator.onTapToHome(context);
          },
        ),
        title: TopAppBar(
          navigationFields: <Widget>[
            TopBarImageIcon(
                Icon(
                  Icons.map,
                  color: Colors.white,
                  size: 30,
                ),
                (context) {}),
            TopBarImageIcon(
                Icon(Icons.room, size: 30), RouteGenerator.onTapToLocations),
          ],
          titleText: "Rooms",
        ),
        backgroundColor: controller.colorTheme,
      ),
      body: AnimatedList(
        key: controller.key,
        initialItemCount: controller.items.length,
        itemBuilder: (context, index, animation) {
          return controller._buildItem(
              controller.items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: controller.colorTheme,
        onPressed: () {
          controller.addItemDialog(context);
        },
      ),
    );
  }
}

class _ControllerRooms {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme;
  List<Room> _items;

  _ControllerRooms(this._colorTheme) {
    _items = _getData();
  }

  List<Room> _getData() {
    return [
      Room(1, "living-room"),
      Room(2, "dining-room"),
      Room(3, "study-room"),
      Room(4, "basement"),
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

  Widget _buildItem(Room item, Animation animation, int index) {
    Icon _selected =
        (true) ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank);

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
                flex: 1,
                child: Align(
                  child: Padding(
                    child: _selected,
                    padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.create),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeItem(index);
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

  void _removeItem(int index) {
    Room removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return _buildItem(removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void _addItem(Room room) {
    int end = _items.length;
    _items.add(room);
    AnimatedListItemBuilder build = (context, index, animation) {
      return _buildItem(_items[index], animation, index);
    };

    _key.currentState.insertItem(end);
  }

  void addItemDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new Room"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Name"),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("StartRoomScan"),
                  color: _colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                title: Text("RoomScanned"),
                value: false,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _addItem(Room(items.length + 1, controller.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
