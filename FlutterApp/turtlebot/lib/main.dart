import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:turtlebot/pages/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  static int id;
  static String name;

  static IOWebSocketChannel con() {
    return new IOWebSocketChannel.connect(
        'ws://' + SocketInfo.hostAdress + SocketInfo.port);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TurtleBot',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: id != null ? '/' : '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(MyApp.name != ''
            ? (MyApp.name)
            : ''
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            RaisedButton(
                color: Colors.grey,
                child: Text("Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  LoginController.logout();
                  RouteGenerator.onTapToLogin(context);
                })
          ],
        ),
        body: AppNavBarController()
    );
  }
}

