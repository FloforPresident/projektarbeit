import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomColourText extends StatelessWidget {

  Color _backgroundColor;
  final Text _text;
  EdgeInsetsGeometry padding;

  CustomColourText(this._text,[ this._backgroundColor = Colors.white,this.padding = const EdgeInsets.all(15.0)]);

  Widget build(BuildContext context) {
    return Container(child: _text,
      color: _backgroundColor,
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(15.0),);
  }


}