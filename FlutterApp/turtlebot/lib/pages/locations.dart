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
                onChanged: () {
                  widget.controller.updateLocations(
                      widget.controller.dropdownCon.getValue().id);
                },
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
              initialItemCount: widget.controller.currentLocations.length,
              itemBuilder: (context, index, animation) {
                return widget.controller._buildItem(
                    widget.controller.currentLocations[index],
                    animation,
                    index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.controller.addItemDialog(context);
        },
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

  //_locations should be exchanged with fixed List of available Locations from Database
  List<LocationID> _locations;
  List<LocationID> _currentLocations;

  List<LocationID> get currentLocations => _currentLocations;

  set locations(List<LocationID> value) {
    _locations = value;
  }

  List<LocationID> get locations => _locations;

  GlobalKey<AnimatedListState> get key => _key;

  Color get colorTheme => _colorTheme;

  LocationsController(this._colorTheme) {
    _locations = _getLocationData();
    _currentLocations = _getLocationData();
  }

  updateLocations(int roomId) {
    List<LocationID> result = List<LocationID>();
    bool notInserted = true;
    int indexRemoveableItem = 0;

    for (int i = 0; i < locations.length; i++) {
      for (int y = 0; y < currentLocations.length; y++) {
        if (locations[i].id == currentLocations[y].id) {
          notInserted = false;
          indexRemoveableItem = y;
        }
      }
      if (locations[i].roomId == roomId && notInserted) {
        _addItem(locations[i]);
      } else if (!notInserted && locations[i].roomId != roomId) {
        _removeItem(indexRemoveableItem);
      }
      notInserted = true;
    }
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
    LocationID removeItem = currentLocations.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return _buildItem(removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void _addItem(LocationID location) {
    int end = currentLocations.length;
    currentLocations.add(location);
    AnimatedListItemBuilder build = (context, index, animation) {
      return _buildItem(currentLocations[index], animation, index);
    };

    _key.currentState.insertItem(end);
  }

  void addItemDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController xController = TextEditingController();
    TextEditingController yController = TextEditingController();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new Location"),
          content: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: xController,
                decoration: InputDecoration(labelText: "X-Coordinate"),
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(labelText: "Y-Coordinate"),
              ),
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
                LocationID newLoc = LocationID(locations.length + 1,
                    dropdownCon.getValue().id, nameController.text);
                _addItem(newLoc);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Room> _getRoomData() {
    return [
      Room(1, 1, "basement"),
      Room(2, 2, "1.floor"),
      Room(3, 3, "2.floor"),
      Room(4, 4, "basement"),
      Room(5, 5, "hiaf"),
      Room(6, 6, "dfasf"),
      Room(7, 7, "dafsdf"),
      Room(8, 8, "dafsd"),
      Room(9, 9, "hiaf"),
      Room(10, 1, "dfasf"),
      Room(11, 1, "dafsdf"),
      Room(12, 1, "dafsd"),
    ];
  }

  List<LocationID> _getLocationData() {
    return [
      LocationID(1, 1, "Kitchen"),
      LocationID(2, 1, "Office"),
      LocationID(3, 1, "Bathroom"),
      LocationID(4, 2, "Bedroom"),
      LocationID(5, 2, "Bathroom"),
      LocationID(6, 2, "MomsOffice"),
      LocationID(7, 3, "bigshelf"),
      LocationID(8, 3, "tabletennis"),
      LocationID(9, 3, "chest"),
    ];
  }
}
