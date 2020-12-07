import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

class CustomDropdownMenu<T extends DatabaseObject> extends StatefulWidget {
  final double fontSize;
  final ControllerCustomDropdown<T> controller;
  final double dropButtonSize;
  final TextStyle itemTextStyle;
  final Color focusColorItem;
  final TextStyle  selectedItemTextStyle;

  CustomDropdownMenu(
      {int startValueId,
      @required this.controller,
      this.fontSize = 18,
        this.dropButtonSize = 130,
      List<T> data,
      Function onChanged,
      this.itemTextStyle,
      this.focusColorItem,
      this.selectedItemTextStyle}) {
    controller.initialize(startValueId, onChanged, data, this);

  }

  State<StatefulWidget> createState() {
    return _StateCustomDropdownMenu();
  }
}

class _StateCustomDropdownMenu extends State<CustomDropdownMenu> {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: widget.dropButtonSize,
            child: DropdownButton(
              focusColor: widget.focusColorItem,
                isExpanded: true,
                value: widget.controller.startValueId,
                items: widget.controller
                    ._createDropdownMenuItem(widget.controller.data),

                onChanged: (value) {
                  setState(() {
                    widget.controller.currentIndexValue = value;
                    widget.controller.resetState(value);
                    if(widget.controller.onChanged != null)
                      {
                        widget.controller.onChanged();
                      }

                  });
                }),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
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
    TextStyle currentTextStyle;
    return objects.map((item) {
      currentTextStyle = (counter == startValueId) ? _widget.selectedItemTextStyle : _widget.itemTextStyle;
      return DropdownMenuItem(
        value: counter++,
        child: Container(child:  Text(item.name, style: _widget.itemTextStyle,)),
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
  final double leftStart;
  final Text label;
  final double labelRightSpace;
  final double topSpace;

  CustomDropdownLabel(
      {@required this.child,
      this.fontSize = 18,
      this.leftStart = 30,
      @required this.label,
      this.labelRightSpace = 20,
      this.topSpace = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, topSpace, 0, 0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: label,
              margin: EdgeInsets.fromLTRB(leftStart, 0, labelRightSpace, 0),
            ),
          ),
          Expanded(
            flex: 5,
            child: child,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
