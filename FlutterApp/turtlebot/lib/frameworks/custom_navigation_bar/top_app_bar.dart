import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**_navigationFields
* The First Element in the second array hast to be either a Image ( Image.asset(path)) or a Icon (Icon.whatever)
* The Second Element hast to be a Function, usually the routing function **/

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


/// In _image hast to be either a Icon (Icon.whatever) or a Image(Image.asset(path))

class TopBarImageIcon extends StatefulWidget {
  final Widget _image;
  final Function _routing;

  TopBarImageIcon(this._image, this._routing);

  @override
  State<StatefulWidget> createState() {
    return _TopBarImageIcon();
  }

}

class _TopBarImageIcon extends State<TopBarImageIcon> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          widget._routing(context);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: widget._image,
          width: 25,
          height: 25,
        )
    );
  }

}
