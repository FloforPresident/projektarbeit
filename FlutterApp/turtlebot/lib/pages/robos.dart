import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/onDelete/on_delete.dart';

import 'package:turtlebot/main.dart';

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
