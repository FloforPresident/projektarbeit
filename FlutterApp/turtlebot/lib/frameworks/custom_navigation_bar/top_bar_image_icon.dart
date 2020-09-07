import 'package:flutter/material.dart';

/* In _image hast to be either a Icon (Icon.whatever) or a Image(Image.asset(path)) */

class TopBarImageIcon extends StatefulWidget {
  final Widget _image;
  final Function _routing;
  final bool _selected;
  Color _selectedBackgroundColor;

  TopBarImageIcon(this._image, this._routing, [this._selected = false])
  {
   _selectedBackgroundColor = (_selected) ? Colors.white : null ;
  }

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