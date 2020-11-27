import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {

  double _leftStart = 40;
  double _rightEnd = 40;
  double _topSpace = 20;
  Color colorTheme = Colors.cyan;
  Color secondaryTheme = Colors.white;

  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();

    LoginController.autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme,
        title: Center(
          child: Text(
            "TurtleBot Control Application",
            style: TextStyle(
              color: secondaryTheme,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Icon(Icons.adb, color: Colors.green, size: 60),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(_leftStart, 20, _rightEnd, 0),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: colorTheme,
                    )
                  ),
                  maxLength: 20,
                  maxLines: null,
                )
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(_leftStart, _topSpace, _rightEnd, 40),
                child: TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: colorTheme,
                      )),
                  maxLength: 20,
                  maxLines: null,
                ),
              ),
              RaisedButton(
                color: Colors.blueGrey,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: secondaryTheme,
                  ),
                ),
                onPressed: () {
                  if(_name.text.isNotEmpty && _password.text.isNotEmpty) {
                    LoginController.loginUser(context, _name.text, _password.text);
                  }
                },
              ),
              RaisedButton(
                color: Colors.grey,
                child: Text(
                  "Signup",
                  style: TextStyle(
                    color: secondaryTheme,
                  ),
                ),
                onPressed: () {
                  signupDialog(context);
                },
              ),
            ]
          )
        )
      )
    );
  }

  void signupDialog(BuildContext context) {
    bool _uploadedImage = true;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("SignUp"),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _name,
                maxLines: null,
                maxLength: 20,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("Picture Upload"),
                  color: colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                title: Text("Picture uploaded"),
                value: _uploadedImage,
                onChanged: (bool value) {},
              ),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                controller: _password,
                maxLines: null,
                maxLength: 20,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Exit"),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("SignUp",
              style: TextStyle(color: secondaryTheme)
              ),
              color: Colors.blueGrey,
              onPressed: () {
                if (_name.text.isNotEmpty &&
                    _password.text.isNotEmpty &&
                    _uploadedImage == true) {
                  LoginController.addUser(context, _name.text, _password.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginController {

  //Shared Preferences
  static void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userID = prefs.getInt('id');
    final String userName = prefs.getString('name');

    if (userID != null) {
      MyApp.id = userID;
      MyApp.name = userName;
    }
  }

  static Future<Null> login(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', user.id);
    prefs.setString('name', user.name);
    MyApp.id = user.id;
    MyApp.name = user.name;
  }

  static Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', null);
    prefs.setString('name', null);
    MyApp.id = null;
    MyApp.name = null;
  }

  // Login Controller Action
  static void addUser(BuildContext context, String name, String password) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "ADD USER", "name": "$name", "password": "$password"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();

        loginHelper(jsonDataString);

        RouteGenerator.onTapToLocations(context);
      }
      else {
        RouteGenerator.onTapToLogin(context);
      }
    });
  }

  static void loginUser(BuildContext context, String name, String password) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "LOGIN USER", "name": "$name", "password": "$password"}';
    channel.sink.add(data);


    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();

        loginHelper(jsonDataString);

        RouteGenerator.onTapToHome(context);
      }
      else {
        RouteGenerator.onTapToLogin(context);
      }
    });
  }

  static void loginHelper(String jsonDataString) {
    final jsonData = jsonDecode(jsonDataString);

    User user = new User(jsonData['user_id'],
        jsonData['location_id'], jsonData['username']);

    login(user);
  }
}