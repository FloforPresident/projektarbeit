import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:turtlebot/services/socke_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // static final IOWebSocketChannel channel = IOWebSocketChannel.connect(
  //     'ws://' + SocketInfo.hostAdress + SocketInfo.port);

  static int id;

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
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class Home extends StatefulWidget {
  final channel = MyApp.con();

  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Stream broadcast;

  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();

    broadcast = widget.channel.stream.asBroadcastStream();

    autoLogIn();
  }

  bool isLoggedIn = false;

  User sessionUser;

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userID = prefs.getInt('id');

    if (userID != null) {
      setState(() {
        isLoggedIn = true;
        MyApp.id = userID;
      });
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', null);

    setState(() {
      MyApp.id = null;
      isLoggedIn = false;
    });
  }

  Future<Null> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', sessionUser.id);

    setState(() {
      MyApp.id = sessionUser.id;
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(isLoggedIn
                  ? (MyApp.id.toString() + ' Turtle-Bot Control App')
                  : 'Turtle-Bot Control App')),
          backgroundColor: Colors.white,
          actions: <Widget>[
            RaisedButton(
                color: Colors.grey,
                child: Text(
                  isLoggedIn ? "LogOut" : "LogIn",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  isLoggedIn ? logout() : loginDialog(context);
                })
          ],
        ),
        body: isLoggedIn
            ? AppNavBarController()
            : ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('LogIn first',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    loginDialog(context);
                  },
                ),
              ));
  }

  ////LOGIN////
  ///
  Color colorTheme = Colors.green;
  Color secondaryTheme = Colors.white;

  //Anmelden
  Future<bool> loginDialog(BuildContext context) async {
    bool _uploadedImage = true;

    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("LogIn"),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _name,
                maxLines: null,
                maxLength: 20,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                controller: _password,
                maxLines: null,
                maxLength: 20,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("SignUp"),
              onPressed: () {
                signupDialog(context);
              },
            ),
            FlatButton(
              child: Text("Exit"),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("LogIn"),
              color: colorTheme,
              onPressed: () {
                if (_name.text.isNotEmpty && _password.text.isNotEmpty) {
                  loginUser(_name.text, _password.text);
                  broadcast.listen((json) {
                    if (json != '') {
                      String jsonDataString = json.toString();
                      final jsonData = jsonDecode(jsonDataString);

                      sessionUser = new User(
                          jsonData['user_id'],
                          jsonData['username'],
                          jsonData['location_id'].toString());

                      login();
                    }
                    RouteGenerator.onTapToHome(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //Registrieren
  Future<bool> signupDialog(BuildContext context) async {
    bool _uploadedImage = true;

    return await showDialog(
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
                // onChanged: (bool value) {
                //   setState() {
                //     _uploadedImage = value;
                //   }
                // }
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
              child: Text("SignUp"),
              color: colorTheme,
              onPressed: () {
                if (_name.text.isNotEmpty &&
                    _password.text.isNotEmpty &&
                    _uploadedImage == true) {
                  addUser(1, _name.text, _password.text);
                  RouteGenerator.onTapToHome(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void addUser(int location, String name, String password) {
    String data =
        '{"action": "ADD USER", "location": "$location", "name": "$name", "password": "$password"}';
    widget.channel.sink.add(data);
  }

  void loginUser(String name, String password) {
    String data =
        '{"action": "LOGIN USER", "name": "$name", "password": "$password"}';
    widget.channel.sink.add(data);
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
