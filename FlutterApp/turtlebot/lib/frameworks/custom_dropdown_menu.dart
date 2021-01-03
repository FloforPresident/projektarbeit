import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

class CustomDropdownMenu<T extends DatabaseObject> extends StatefulWidget {
  final double fontSize;
  final ControllerCustomDropdown<T> controller;
  final double dropButtonSize;
  final TextStyle itemTextStyle;
  final Color focusColorItem;
  final TextStyle  selectedItemTextStyle;
  final Color dropdowncolor;
  final Key key;

  CustomDropdownMenu(
      {this.key,
        int startValueId,
      @required this.controller,
      this.fontSize = 18,
        this.dropButtonSize = 130,
      List<T> data,
      Function onChanged,
      this.itemTextStyle = const TextStyle(color: Colors.black),
      this.focusColorItem,
      this.selectedItemTextStyle,
      this.dropdowncolor}) {
    controller.initialize(startValueId, onChanged, data, this);

  }

  State<StatefulWidget> createState() {
    return StateCustomDropdownMenu();
  }
}

class StateCustomDropdownMenu extends State<CustomDropdownMenu> {
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropButtonSize,
      child: DropdownButton(
        style: widget.itemTextStyle,
        isExpanded: true,
        dropdownColor: widget.dropdowncolor,
        focusColor: widget.focusColorItem,
          value: widget.controller.startValueId,
          items: widget.controller
              ._createDropdownMenuItem(widget.controller.data),

          onChanged: (value) {
            setState(() {
              widget.controller.currentIndexValue = value;
              widget.controller.resetState(value);
              if(widget.controller.onChanged != null)
                {
                  widget.controller.onChanged(value);
                }

            });
          }),
    );
  }

  rebuildState()
  {
    setState(() {

    });
  }
}

class ControllerCustomDropdown<T extends DatabaseObject> {
  T value;
  int startValueId;
  int currentIndexValue;
  CustomDropdownMenu _widget;

  int getCurrentIndex()
  {
    if(currentIndexValue == null)
      return null;
    else
      return currentIndexValue;
  }

  List<DatabaseObject> data;
  Function onChanged;

  initialize(int startValueId, Function onChanged, List<DatabaseObject> data, CustomDropdownMenu widget) {
    this.startValueId = startValueId;
    currentIndexValue = startValueId;
    this.onChanged = onChanged;
    this.data = data;
    this._widget = widget;
  }

  void setValue(T value) {
    this.value = value;
  }

  T getValue() {
    if (value != null)
      return value;
    else
      return null;
  }

  List<DropdownMenuItem> _createDropdownMenuItem(List<DatabaseObject> objects) {
    int counter = 0;
    return objects.map((item) {
      return DropdownMenuItem(
        value: counter++,
        child: Container(child:  Text(item.name)),
      );
    }).toList();
  }

  void resetState(int value) {
    startValueId = value;
    this.value = data[value];
  }
}

class CustomDropdownLabel extends StatelessWidget {
  final CustomDropdownMenu child;
  final double fontSize;
  final Text label;
  final double labelRightSpace;

  CustomDropdownLabel(
      {@required this.child,
      this.fontSize = 18,
      @required this.label,
      this.labelRightSpace = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: label,
            margin: EdgeInsets.fromLTRB(0, 0, labelRightSpace, 0),
          ),
          Container(child: child),
        ],

      ),
    );
  }
}
