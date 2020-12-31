import 'package:flutter/material.dart';
import 'package:turtlebot/services/alertDialogs/basic_alert_dialog.dart';


class StatusMessages
{
  static void hostAdressChanged(BuildContext context)
  {
    BasicAlertDialog.basicAlertDialog(context: context, title: Text("Ip-Adresse wurde geändert"), content: [Text("Die IP-Addresse wurde erfolgreich geändert")],
        actions:[ FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Schließen"))
        ]);
  }
}