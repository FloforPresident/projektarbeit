import 'package:flutter/material.dart';

class Rooms extends StatelessWidget {
  _ControllerRooms controller;



  Rooms({Key key}) : super(key: key)
  {
    this.controller = _ControllerRooms(Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room Register"),
        backgroundColor: controller.colorTheme,
      ),
      body: AnimatedList(
        key: controller.key,
        initialItemCount: controller.items.length,
        itemBuilder: (context, index, animation) {
          return controller._buildItem(controller.items[index], animation, index);
        },
      ),
    );
  }


}

class _ControllerRooms
{
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final Color _colorTheme;
  List<List> _items;

  _ControllerRooms(this._colorTheme)
  {
    _items = _getData();
  }

  List<List> _getData()
  {
    return
    [
      ["Living-Room"],
      ["Dining-Room"],
      ["Office"],
      ["Studyroom"],
    ];
  }

  get colorTheme
  {
    return Color(_colorTheme.value);
  }

  get items
  {
    return _items;
  }

  get key
  {
    return _key;
  }


  Widget _buildItem(List item, Animation animation, int index) {
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
                    Text(item[0]),
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
    List removeItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder build = (context, animation) {
      return _buildItem(removeItem, animation, index);
    };

    _key.currentState.removeItem(index, build);
  }

  void _addItem(BuildContext context) {
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
