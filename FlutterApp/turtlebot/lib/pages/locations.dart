import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/customDropDownMenu/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

class Locations extends StatefulWidget {
  final LocationsController controller = LocationsController(Colors.pink);


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
            child: CustomDropdownLabel(
              label: "Rooms",
              child: CustomDropdownMenu<Room>(
                onChanged: () {widget.controller.updateLocations(widget.controller.dropdownCon.getValue().id);},
                startValueId: 1,
                controller: widget.controller.dropdownCon,
                data: widget.controller._getRoomData(),
              ),
            ),
          ),
          Flexible(
            child: AnimatedList(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              key: widget.controller.key,
              initialItemCount: widget.controller.locations.length,
              itemBuilder: (context, index, animation) {
                return widget.controller._buildItem(
                    widget.controller.locations[index], animation, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: widget.controller.colorTheme,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class LocationsController {
  final ControllerCustomDropdown<Room> dropdownCon = ControllerCustomDropdown();
  Color _colorTheme;
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<Room> _rooms;
  List<LocationID> _locations;

  set locations(List<LocationID> value) {
    _locations = value;
  }

  List<LocationID> get locations => _locations;

  List<Room> get rooms => _rooms;

  GlobalKey<AnimatedListState> get key => _key;

  Color get colorTheme => _colorTheme;

  LocationsController(this._colorTheme) {
    _rooms = _getRoomData();
    _locations = _getLocationData();
  }

  List<Room> _getRoomData() {
    return [
      Room(1, "basement"),
      Room(2, "1.floor"),
      Room(3, "2.floor"),
      Room(4, "basement"),
      Room(5, "hiaf"),
      Room(6, "dfasf"),
      Room(7, "dafsdf"),
      Room(8, "dafsd"),
      Room(9, "hiaf"),
      Room(10, "dfasf"),
      Room(11, "dafsdf"),
      Room(12, "dafsd"),
    ];
  }

  List<LocationID> _getLocationData() {
    return [
      LocationID(1, 1,"Kitchen"),
    LocationID(2,1,"Office"),
    LocationID(3,1,"Bathroom"),
    LocationID(4,2,"Bedroom"),
    LocationID(5,2,"Bathroom"),
    LocationID(6,2,"MomsOffice"),
    LocationID(7,3,"bigshelf"),
    LocationID(8,3,"tabletennis"),
    LocationID(9,3,"chest"),
    ];
  }

  updateLocations(int roomId)
  {
    List<LocationID> result = List<LocationID>();

    locations.forEach((location)
    {
      if(location.roomId == roomId)
        result.add(location);
    });

    locations = result;
  }

  Widget _buildItem(LocationID item, Animation animation, int index) {


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
    LocationID removeItem = _locations.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return _buildItem(removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void _addItem(LocationID location) {
    int end = _locations.length;
    _locations.add(location);
    AnimatedListItemBuilder build = (context, index, animation) {
      return _buildItem(_locations[index], animation, index);
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
                onChanged: (bool) {},
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
                _addItem(LocationID(rooms.length + 1, dropdownCon.getValue().id, "test"));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
