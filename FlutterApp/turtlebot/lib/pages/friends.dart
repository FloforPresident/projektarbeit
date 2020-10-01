import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  _ControllerFriends controller;

  Friends({Key key}) : super(key: key) {
    this.controller = _ControllerFriends(Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robo Friends"),
        backgroundColor: controller.colorTheme,
      ),
      body: AnimatedList(
        key: controller.key,
        initialItemCount: controller.items.length,
        itemBuilder: (context, index, animation) {
          return controller.buildItem(
              controller.items[index], animation, index);
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

class _ControllerFriends {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme;
  List<List> _items;

  _ControllerFriends(this._colorTheme) {
    this._items = _getData();
  }

  List<List> _getData() {
    return [
      [1, "Sabrina", "1.floor", "living-room"],
      [2, "Sebastian", "2.floor", "Sebastians-room"],
      [3, "Elisabeth", "1.floor", "kitchen"],
      [4, "Mark", "Basement", "Storage"]
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

  Widget buildItem(List _item, Animation animation, int index) {
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
                    Text(_item[1] + " "),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.email),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeItem(index);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          subtitle: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                  children: <Widget>[Text(_item[2] + " - ", style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  )), Text(_item[3])])),
        ),
      ),
    );
  }

  void removeItem(int index) {
    List removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return buildItem(removeItem, animation, index);
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
