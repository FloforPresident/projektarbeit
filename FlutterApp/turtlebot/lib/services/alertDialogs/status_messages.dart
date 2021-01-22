import 'package:flutter/material.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/alertDialogs/basic_alert_dialog.dart';
import 'package:turtlebot/services/routing.dart';

class StatusMessages {
  static const double _fontsize = 18.0;
  static const Color _generalHeadlineColor = Colors.green;

  static void hostAdressChanged(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Ip-Adresse wurde geändert",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Die IP-Addresse wurde erfolgreich geändert",
              style: TextStyle(fontSize: _fontsize))
        ],
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Schließen"))
        ]);
  }

  static Future<bool> exitApp(BuildContext context) {
    return BasicAlertDialog.basicAlertDialogReturnFutureBool(
        context: context,
        title: Text("App verlassen",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Bist du sicher das du diese App verlassen willst?",
              style: TextStyle(fontSize: _fontsize))
        ],
        actions: [
          FlatButton(
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
              child: Text("Nein")),
          FlatButton(
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
              child: Text("Ja"))
        ]);
  }

  static Future<bool> onDelete(BuildContext context) async {
    return await BasicAlertDialog.basicAlertDialogReturnFutureBool(
      context: context,
      content: [Text("")],
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
    );
  }

  static void sendMessage(BuildContext context, User user, String subject) {
    return BasicAlertDialog.basicAlertDialog(
      context: context,
      content: [
        Text("Du hast den Auftrag für ${user.name} gestartet:\n\n${subject}")
      ],
      title: Text("Auftrag verschickt !"),
      actions: <Widget>[
        FlatButton(
            child: Text("Zurück"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
