import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/routing.dart';



class Logout
{

  //if implemented has to be invoked in a setState Function otherwise changes will be not be active
  static Future<Null> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', null);
    prefs.setString('name', null);

    MyApp.id = null;
    MyApp.name = null;
    RouteGenerator.onTapToLogin(context);
  }
}