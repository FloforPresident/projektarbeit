import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/databaseObjects/data_base_objects.dart';

class Locations extends StatefulWidget {
  final LocationsController controller = LocationsController(Colors.pink);
  final ControllerCustomDropdown<Room> dropdownCon = ControllerCustomDropdown();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LocationsState();
  }
}

class _LocationsState extends State<Locations> {
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
        backgroundColor: widget.controller.colorTheme,
        title: TopAppBar(
          navigationFields: <Widget>[
            TopBarImageIcon(
                Icon(Icons.map, size: 30), RouteGenerator.onTapToRooms),
            TopBarImageIcon(
                Icon(Icons.room, color: Colors.white, size: 30), (context) {}),
          ],
          titleText: "Locations",
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: CustomDropdownMenu<Room>(
              label: "Room",
              controller: widget.dropdownCon,
              data: widget.controller._getRoomData(),
            ),
          ),
          Flexible(
            child: AnimatedList(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              key: widget.controller.key,
              initialItemCount: widget.controller.items.length,
              itemBuilder: (context,index,animation)
                {
                  return widget.controller._buildItem(
                    widget.controller.items[index], animation,index);
                },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.controller.colorTheme,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class LocationsController {
  Color _colorTheme;
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<Room> _items;


  List<Room> get items => _items;

  GlobalKey<AnimatedListState> get key => _key;

  Color get colorTheme => _colorTheme;

  LocationsController(this._colorTheme)
  {
    _items = _getRoomData();
  }

  List<Room> _getRoomData() {
    return [
      Room(1, "living-room"),
      Room(2, "dining-room"),
      Room(3, "study-room"),
      Room(4, "basement"),
      Room(5, "hiaf"),
      Room(6, "dfasf"),
      Room(7, "dafsdf"),
      Room(8, "dafsd"),
      Room(5, "hiaf"),
      Room(6, "dfasf"),
      Room(7, "dafsdf"),
      Room(8, "dafsd"),
    ];
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

  void _addItem(Room room)
  {
    int end = _items.length;
    _items.add(room);
    AnimatedListItemBuilder build = (context,index,animation)
    {
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
                _addItem(Room(items.length+1,controller.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
