import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:turtlebot/services/socke_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // static final IOWebSocketChannel channel = IOWebSocketChannel.connect(
  //     'ws://' + SocketInfo.hostAdress + SocketInfo.port);

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
  // final WebSocketChannel channel;
  // final streamController = StreamController.broadcast();

  Home({Key key}) : super(key: key) {
    // streamController.addStream(this.channel.stream);
  }

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  WebSocketChannel channel;
  StreamController broadcast = StreamController.broadcast();

  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    channel = MyApp.con();
    broadcast.addStream(channel.stream);
    autoLogIn();
    // streamController.addStream(widget.channel.stream);
  }

  // streamController.addStream(widget.streamController.stream)

  bool isLoggedIn = false;
  static String name = '';

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('username');

    if (userName != null) {
      setState(() {
        isLoggedIn = true;
        name = userName;
      });
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);

    setState(() {
      name = '';
      isLoggedIn = false;
    });
  }

  Future<Null> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _name.text);

    setState(() {
      name = _name.text;
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
                ? (name + '-Bot Control App')
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
      body: AppNavBarController(),
    );
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
                  broadcast.stream.listen((data) {
                    if (data != '') {
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
    channel.sink.add(data);
  }

  void loginUser(String name, String password) {
    String data =
        '{"action": "LOGIN USER", "name": "$name", "password": "$password"}';
    channel.sink.add(data);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
