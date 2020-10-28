import 'package:flutter/material.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Login extends StatelessWidget {
  double _leftStart = 40;
  double _rightEnd = 40;
  double _topSpace = 20;
  Color colorTheme = Colors.green;
  Color secondaryTheme = Colors.white;

  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final WebSocketChannel channel;
  _LoginController controller;

  Login({Key key, @required this.channel}) : super(key: key) {
    this.controller = _LoginController(colorTheme);
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
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Icon(Icons.adb, color: Colors.green, size: 60),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(_leftStart, 20, _rightEnd, 0),
                child: TextFormField(
                  controller: name,
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
                  controller: password,
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
                  if (name.text.isNotEmpty && password.text.isNotEmpty) {
                    userAction("LOGIN USER", name.text, password.text);
                    channel.stream.listen((data) {
                      if (data == 'success') {
                        RouteGenerator.onTapToHome(context);
                      }
                    });
                  }
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
          _LoginController(colorTheme).addItemDialog(context);
        },
      ),
    );
  }

  void userAction(String action, [String name, String password]) {
    String data;

    if (name.isNotEmpty && password.isNotEmpty) {
      data = '{"action": "$action", "name": "$name", "password": "$password"}';
    } else {
      data = '{"action": "$action"}';
    }

    channel.sink.add(data);
  }

  @override
  void dispose() {
    channel.sink.close();
    dispose();
  }
}

class _LoginController extends Login {
  Color _colorTheme;
  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();

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
                controller: name,
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
                controller: password,
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
                if (name.text.isNotEmpty &&
                    password.text.isNotEmpty &&
                    _uploadedImage == true) {
                  //Not working cause i need access to Login widget.channel out of class _LoginController.
                  //How is this possible? Until then no signUp possible
                  userAction("ADD USER", name.text, password.text);
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
