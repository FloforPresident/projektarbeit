import 'package:flutter/material.dart';

class NoDataDialog{

  static void noLoginData(BuildContext context)
  {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        content: Builder(
            builder: (context) {


              return Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text("Leider hast du vergessen Daten in ein Feld einzutragen, probiere es nochmal"),
              );
            }
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen",
                style: TextStyle(color: Colors.white)
            ),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}