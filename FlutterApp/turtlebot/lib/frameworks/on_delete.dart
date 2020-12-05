import 'package:flutter/material.dart';

class OnDelete {
  OnDelete._();

  static Future<bool> onDelete(BuildContext context) async {
     return await showDialog(
       context: context,
      builder: (context) => AlertDialog(
        title: Text("Bist du sicher?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Nein"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
              child: Text("Löschen"),
              onPressed: () => Navigator.of(context).pop(true))
        ],
      ),
    );
  }
}
