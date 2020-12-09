import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/routing.dart';

class TopAppBarLogout extends StatefulWidget implements PreferredSizeWidget {
  final colorTheme;
  final String page;

  TopAppBarLogout({Key key, this.colorTheme, this.page}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;

  @override
  _TopAppBarLogout createState() {
    return _TopAppBarLogout();
  }
}

class _TopAppBarLogout extends State<TopAppBarLogout> {

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', null);
    prefs.setString('name', null);

    setState(() {
      MyApp.id = null;
      MyApp.name = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.page, style: TextStyle(
          color: Colors.white
      )),
      backgroundColor: widget.colorTheme,
      actions: <Widget>[
        RaisedButton(
            color: widget.colorTheme[900],
            child: Text("Abmelden",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              logout();
              RouteGenerator.onTapToLogin(context);
            }
        )
      ],
      automaticallyImplyLeading: false,
    );
  }
}