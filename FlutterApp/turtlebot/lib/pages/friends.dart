import 'package:flutter/material.dart';

class Friends extends StatelessWidget {


   Color _colorTheme;
  _ControllerFriends controller;
  List<List> _items;
  GlobalKey<AnimatedListState> _key;



  Friends({Key key}) : super(key: key)
  {
    this.controller = _ControllerFriends();
    this._items = controller.items;
    this._key = controller._key;
    this._colorTheme = controller._colorTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robo Friends"),
        backgroundColor: _colorTheme,
      ),
      body: AnimatedList(
        key: _key,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return controller.buildItem(_items[index],animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: _colorTheme,
        onPressed: () {
         controller.addItem(context);
        },
      ),
    );
  }

}

class _ControllerFriends
{
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme = Colors.red;
  List<List> _items;

  _ControllerFriends()
  {
    this._items = _getData();
  }

  List<List> _getData()
  {
    return [
      ["Sabrina", "Wiena", true],
      ["Sebastian", "Schwarzer", false],
      ["Elisabeth", "Schneider", true],
      ["Mark", "Aurelius", false]
    ];
  }

  get colorTheme
  {
    return Color(_colorTheme.value);
  }

  get items
  {
    return _getData();
  }

  get key
  {
    return _key;
  }

  Widget buildItem(List _item,Animation animation, int index) {
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
