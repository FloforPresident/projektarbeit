import 'package:flutter/material.dart';

class Rooms extends StatelessWidget {
  Rooms({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room Register"),
        backgroundColor: Colors.green,
      ),
      body: AnimatedList(
        key: _key,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation, index);
        },
      ),
    );
  }

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  Color _colorTheme = Colors.orange;

  List _items = [
    "Living-Room",
    "Dining-Room",
    "Office",
    "Studyroom",
  ];


  Widget _buildItem(String item, Animation animation, int index) {
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
                    Text(item),
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
    String removeItem = _items.removeAt(index);
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
