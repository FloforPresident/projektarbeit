import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Robos extends StatelessWidget {
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
          controller.addItem(context);
        },
      ),
    );
  }
}

class _RobosController {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme;
  List<List> _items;

  _RobosController(this._colorTheme) {
    this._items = _getData();
  }

  List<List> _getData() {
    return [
      ["Robob", "192.185.2.26"],
      ["Number 5", "192.185.2.55"],
      ["Robobross", "192.185.2.234"],
      ["McFlurryMachine", "192.185.2.26"],
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
      BuildContext context, List _item, Animation animation, int index) {
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
                    Text(_item[0] + " "),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Text(_item[1] + " "),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check_box_outline_blank),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool delete = await OnDelete.onDelete(context);
                        (delete) ? removeItem(index) : delete;
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

  void removeItem(int index) {
    List removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(context, removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void addItem(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new User"),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Firstname"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Lastname"),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("Add Faceembedding"),
                  color: _colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                title: Text("Faceembedding uploaded"),
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
            FlatButton(child: Text("Yes")),
          ],
        ),
      ),
    );
  }
}
