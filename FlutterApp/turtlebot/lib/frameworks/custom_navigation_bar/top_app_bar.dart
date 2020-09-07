import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_bar_image_icon.dart';
import 'package:turtlebot/services/routing.dart';

/*_navigationFields
* The First Element in the second array hast to be either a Image ( Image.asset(path)) or a Icon (Icon.whatever)
* The Second Element hast to be a Function, usually the routing function */

class TopAppBar extends StatefulWidget {
  @override

  final List<Widget> _navigationFields;
  final String titleText;

  TopAppBar(this._navigationFields, this.titleText);


  State<StatefulWidget> createState() {
    return _TopAppBar();
  }

//  List<Widget> _generateNavFields()
//  {
//    List<Widget> widgets = new List();
//
//
//    for(int i = 0; i < _navigationFields.length; i++)
//      {
//        widgets.add(TopBarImageIcon(_navigationFields[i][0], _navigationFields[i][1]));
//      }
//
//    return widgets;
//  }
}

class _TopAppBar extends State<TopAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Align(
          child: Text(widget.titleText),
          alignment: Alignment.centerLeft,
        ),
        Spacer(),
        Row(
          children: widget._navigationFields,
        )
      ],
    );
  }
}
