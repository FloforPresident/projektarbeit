import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**_navigationFields
* The First Element in the second array hast to be either a Image ( Image.asset(path)) or a Icon (Icon.whatever)
* The Second Element hast to be a Function, usually the routing function **/

class TopAppBar extends StatefulWidget {
  @override

  final List<Widget> navigationFields;
  final String titleText;

  TopAppBar({@required this.navigationFields,@required this.titleText});


  State<StatefulWidget> createState() {
    return _TopAppBar();
  }
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
          children: widget.navigationFields,
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ],
    );
  }
}


/// In _image hast to be either a Icon (Icon.whatever) or a Image(Image.asset(path))

class TopBarImageIcon extends StatefulWidget {
  final Widget _image;
  final Function _routing;
  final double leftSpace;


  TopBarImageIcon(this._image, this._routing, {this.leftSpace = 15});

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
          margin: EdgeInsets.fromLTRB(widget.leftSpace, 0, 0, 0),
          child: widget._image,
          width: 30,
          height: 30,
        )
    );
  }

}
