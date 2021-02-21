import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class LoadingInfo extends StatelessWidget {

  final EdgeInsets padding;

  LoadingInfo({this.padding = const EdgeInsets.fromLTRB(30, 40, 30, 0)});

  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: Duration(seconds: 2),
      child: Container(
        padding: padding,
        child: Center(
            child: Text(
                "Aktuelle Werte werden aus der Datenbank geladen, falls dies sehr lange dauert überprüfe am besten in Home die angegebene IP-Adresse",
                textAlign: TextAlign.justify

            )),
      ),
    );
  }
}
