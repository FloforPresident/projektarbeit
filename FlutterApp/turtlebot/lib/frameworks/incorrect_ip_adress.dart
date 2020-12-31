import 'package:flutter/material.dart';

class IncorrectIP extends StatelessWidget {

  final EdgeInsets padding;

  IncorrectIP({this.padding = const EdgeInsets.fromLTRB(30, 40, 30, 0)});

  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Center(
          child: Text(
              'Diese IP-Adresse führt leider nicht zu einem angemeldet ROS-Laptop, bitte probiere eine andere IP-Adresse',
      textAlign: TextAlign.justify

      )),
    );
  }
}
