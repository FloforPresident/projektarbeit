import 'package:flutter/material.dart';
import 'package:turtlebot/databaseObjects/data_base_objects.dart';

class CustomDropdownMenu extends StatefulWidget
{
  @override
  int value;
  double fontSize;
  double leftStart;
  String label;
  double labelRightSpace;
  double topSpace;
  List<DatabaseObject> data;

  CustomDropdownMenu({this.value, this.fontSize = 18, this.leftStart = 40, @required this.label,this.labelRightSpace = 20, this.topSpace = 15,@required this.data});


  State<StatefulWidget> createState() {

    return _StateCustomDropdownMenu();
  }

}

class _StateCustomDropdownMenu extends State<CustomDropdownMenu>
{
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(0, widget.topSpace, 0, 0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child:
              Text(widget.label + ":", style: TextStyle(fontSize: widget.fontSize)),
              margin: EdgeInsets.fromLTRB(
                  widget.leftStart, 0, widget.labelRightSpace, 0),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton(
              isExpanded: true,
              value: widget.value,
              hint: Text(widget.label),
              items: _createDropdownMenuItem(widget.data),
              onChanged: (value) {

                setState(() {
                  widget.value = value;
                });
              },
            ),
          ),
          Spacer(
            flex: 2,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }


  List<DropdownMenuItem> _createDropdownMenuItem(List<DatabaseObject> objects) {
    return objects.map((row) {
      return DropdownMenuItem(
        value: row.id,
        child: Text(row.name),
      );
    }).toList();
  }

}