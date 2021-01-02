import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:turtlebot/services/alertDialogs/basic_alert_dialog.dart';



class ErrorMessages {
  static const double _fontsize = 18.0;
  static const Color _generalHeadlineColor = Colors.green;




  static void fieldsNotFilled(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text(
          "Felder unausgefüllt",
          style: TextStyle(color: _generalHeadlineColor),
        ),
        content: [
          Container(
            child: Text(
              "Es wurden nicht alle Felder ausgefüllt.",
              style: TextStyle(
                fontSize: _fontsize,
              ),
            ),
          )
        ],
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Schließen"))
        ]);
  }

  static void formWrongType(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text(
          "Falscher Typ in Feld",
          style: TextStyle(color: _generalHeadlineColor),
        ),
        content: [
          Text(
            "Es wurde ein falscher Typ, zum Beispiel anstatt ein reiner Zahlenwert, oder eine IP-Addresse, eine Zeichenkombination eingefügt.",
            style: TextStyle(fontSize: _fontsize),
          ),
        ],
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Schließen"))
        ]);
  }

  static void noAccount(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("User nicht vorhanden",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Der angegebene Username existiert nicht.",
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

  static void userNameAlreadyExists(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("User bereits vorhanden",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Bitte ändere deinen Usernamen, dieser ist bereits belegt.",
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

  static void noWebSocketConnection(BuildContext context) {
    TextEditingController ipController = TextEditingController();
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Keine Verbindung zum ROS-Laptop",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text(
              "Leider konnte keine Verbindung zum Ros-Laptop erzeugt werden, entweder ist die IP-Adresse nicht die korrekte oder der Docker-Container ist noch nicht gestartet.",
              style: TextStyle(fontSize: _fontsize)),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(hintText: "IP-Adresse"),
                    maxLength: 15,
                    maxLines: null,
                    controller: ipController,
                  ),
                ),
              )
            ],
          )
        ],
        actions: [
          FlatButton(
              onPressed: () {
                SocketInfo.setHostAdress(ipController.text);
                Navigator.of(context).pop();
                RouteGenerator.onTapToHome(context);
              },
              child: Text("Einsetzen"))
        ]);
  }

  static void pictureNotUploadedYet(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Kein Bild hochgeladen",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text(
              "Bitte lade bei Gelegenheit ein Bild von dir hoch, sonst kann man dir keine Nachrichten senden.",
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

  static void noActiveLocation(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Keine Location hinterlegt",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text(
              "Du hast keine Location hinterlegt. So können dir deine Freunde keine Nachrichten senden. Im Home-Screen kannst du sie einstellen.",
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

  static void noIpAdress(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Keine IP-Adresse gesetzt",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Bitte setzen sie eine IP-Adresse, sonst können die Daten nicht eingeholt werden",
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

  static void wrongIpAdress(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Keine Verbindung unter dieser IP-Adresse",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Die angegebene IP-Adresse führt zu keinem ROS-Laptop, bitte prüfe ob der Docker Container läuft, und ob du die richtige IP-Adresse angegeben hast.",
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

  static void noDataEntered(BuildContext context) {
    BasicAlertDialog.basicAlertDialog(
        context: context,
        title: Text("Es wurden nicht alle Felder ausgefüllt",
            style: TextStyle(color: _generalHeadlineColor)),
        content: [
          Text("Bitte fülle alle Felder, sonst würde ich abstürzen wenn ich dich weiterleite",
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
}
