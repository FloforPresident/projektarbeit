import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/user.dart';
import 'package:turtlebot/services/routing.dart';

class Login extends StatelessWidget {
  double _leftStart = 40;
  double _rightEnd = 40;
  double _topSpace = 20;
  Color colorTheme = Colors.green;
  Color secondaryTheme = Colors.white;
  _LoginController controller;

  Login() {
    controller = _LoginController(colorTheme);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme,
        title: Center(
          child: Text(
            "Design the Future in Turtleworld",
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
              StreamBuilder(
                stream: MyApp.channels[RouteGenerator.RouteLogin].stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Icon(Icons.adb, color: Colors.green, size: 60),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(_leftStart, 20, _rightEnd, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: colorTheme,
                      )),
                  maxLength: 20,
                  maxLines: null,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(_leftStart, _topSpace, _rightEnd, 40),
                child: TextFormField(
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
                color: Colors.grey,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: secondaryTheme,
                  ),
                ),
                onPressed: () {
                  RouteGenerator.onTapToHome(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: colorTheme,
        onPressed: () {
          controller.addItemDialog(context);
        },
      ),
    );
  }

  static void addUser(_name, _password) {
    String data =
        '{"action": "ADD USER", "name": $_name, "password": $_password}';
    Map<String, dynamic> user = jsonDecode(data);

    MyApp.channels[RouteGenerator.RouteLogin].sink.add(user);
  }
}

class _LoginController {
  Color _colorTheme;
  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  _LoginController(Color colorTheme) {
    _colorTheme = colorTheme;
  }

  Future<bool> addItemDialog(BuildContext context) async {
    bool _uploadedImage = true;

    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new User"),
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
                  color: _colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                  title: Text("Picture uploaded"),
                  value: _uploadedImage,
                  onChanged: (bool value) {
                    setState() {
                      _uploadedImage = value;
                    }
                  }),
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
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                if (_name.text.isNotEmpty &&
                    _password.text.isNotEmpty &&
                    _uploadedImage == true) {
                  //Login.addUser(_name.text, _password.text);
                  Navigator.of(context).pop();
                  RouteGenerator.onTapToHome(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
