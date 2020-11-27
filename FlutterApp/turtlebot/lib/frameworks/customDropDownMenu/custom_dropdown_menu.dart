import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

class CustomDropdownMenu<T extends DatabaseObject> extends StatefulWidget {
  final double fontSize;
  final ControllerCustomDropdown<T> controller;

  CustomDropdownMenu(
      {int startValueId,
      @required this.controller,
      this.fontSize = 18,
      List<T> data,
      Function onChanged}) {
    controller.initialize(startValueId, onChanged, data);
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
          Expanded(
            flex: 3,
            child: DropdownButton(
                isExpanded: true,
                value: widget.controller.startValueId,
                items: widget.controller
                    ._createDropdownMenuItem(widget.controller.data),
                onChanged: (value) {
                  setState(() {
                    widget.controller.currentIndexValue = value;
                    widget.controller.resetState(value);
                    (widget.controller.onChanged != null)
                        ? widget.controller.onChanged()
                        : null;
                  });
                }),
          ),
          Spacer(
            flex: 2,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class ControllerCustomDropdown<T extends DatabaseObject> {
  T _value;
  int _startValueId;
  int _currentIndexValue;

  int get currentIndexValue => _currentIndexValue;

  int getCurrentIndex()
  {
    if(currentIndexValue == null)
      return null;
    else
      return currentIndexValue;
  }

  set currentIndexValue(int value) {
    _currentIndexValue = value;
  }

  set startValueId(int value) {
    _startValueId = value;
  }

  int get startValueId => _startValueId;
  List<DatabaseObject> data;
  Function onChanged;

  initialize(int startValueId, Function onChanged, List<DatabaseObject> data) {
    this.startValueId = startValueId;
    currentIndexValue = startValueId;
    this.onChanged = onChanged;
    this.data = data;
  }

  void setValue(T value) {
    _value = value;
  }

  T getValue() {
    if (_value != null)
      return _value;
    else
      return null;
  }

  List<DropdownMenuItem> _createDropdownMenuItem(List<DatabaseObject> objects) {
    int counter = 0;
    return objects.map((item) {
      return DropdownMenuItem(
        value: counter++,
        child: Text(item.name),
      );
    }).toList();
  }

  void resetState(int value) {
    startValueId = value;
    this._value = data[value];
  }
}

class CustomDropdownLabel extends StatelessWidget {
  final CustomDropdownMenu child;
  final double fontSize;
  final double leftStart;
  final String label;
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
              child: Text(label + ":", style: TextStyle(fontSize: fontSize)),
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
