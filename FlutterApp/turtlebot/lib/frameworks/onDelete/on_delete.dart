import 'package:flutter/material.dart';

class OnDelete {
  OnDelete._();

  static Future<bool> onDelete(BuildContext context) async {
     return await showDialog(
       context: context,
      builder: (context) => AlertDialog(
        title: Text("Sure to delete ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
              child: Text("Yes"),
              onPressed: () => Navigator.of(context).pop(true))
        ],
      ),
    );
  }
}
