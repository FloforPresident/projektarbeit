import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/pages/friends.dart';
import 'package:turtlebot/pages/home/home.dart';
import 'package:turtlebot/pages/controls.dart';
import 'package:turtlebot/pages/maps/maps.dart';
import 'package:turtlebot/pages/robos.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/io.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:turtlebot/objects/data_base_objects.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  static int id;
  static String name;

  static IOWebSocketChannel con() {

    // SocketInfo.setHostAdress();
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

class Home extends StatefulWidget{
  final User sessionUser;

  Home(this.sessionUser);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

    if(widget.sessionUser != null) {
      login();
    }
    else {
      autoLogin();
    }
  }

  //Shared Preferences
  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userID = prefs.getInt('id');
    final String userName = prefs.getString('name');

    if (userID != null) {
      setState(() {
        MyApp.id = userID;
        MyApp.name = userName;
      });
    } else{
      RouteGenerator.onTapToLogin(context);
    }
  }

  // Shared Preference
  Future<Null> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', widget.sessionUser.id);
    prefs.setString('name', widget.sessionUser.name);

    setState(() {
      MyApp.id = widget.sessionUser.id;
      MyApp.name = widget.sessionUser.name;
    });
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', null);
    prefs.setString('name', null);

    setState(() {
      MyApp.id = null;
      MyApp.name = null;
    });
  }

  int _selectedIndex = 0;

  static List<Widget> pages = [
    HomeScreen(),
    Maps(),
    Robos(),
    Friends(),
    Controls()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'Home',
                backgroundColor: Colors.orange
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'Maps',
                backgroundColor: Colors.purple
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mood),
                label: 'Robos',
                backgroundColor: Colors.blue
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_contact_calendar),
                label: 'Friends',
                backgroundColor: Colors.red
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Controls',
                backgroundColor: Colors.green
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey[900],
            iconSize: 30  ,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },

        )
    );
  }
}

