import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomColumnText extends StatelessWidget
{

  Text _textWidget;
  EdgeInsets _padding;
  CustomColumnText(this._textWidget, [this._padding = const EdgeInsets.all(15.0)]);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: _textWidget,
      padding: _padding,
    );
  }

}