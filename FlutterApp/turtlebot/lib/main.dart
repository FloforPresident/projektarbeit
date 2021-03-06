import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/frameworks/page_frame.dart';
import 'package:turtlebot/pages/friends.dart';
import 'package:turtlebot/pages/home/home.dart';
import 'package:turtlebot/pages/controls.dart';
import 'package:turtlebot/pages/maps/maps.dart';
import 'package:turtlebot/pages/robos.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/io.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

void main()
{

  runApp(MyApp());
  //Receives current IP-Adress
  SocketInfo.initializeHostAdressFromShared();
}

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
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: TextTheme(
                bodyText2: TextStyle(fontSize: 18),
                headline1: TextStyle(fontSize: 32, color: Colors.white))),
        initialRoute: RouteGenerator.RouteHome,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }


}


class Home extends StatefulWidget {

  //sessionUser is newly created user via Login.dart creating a new account
  final User sessionUser;

  Home(this.sessionUser);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}


class _HomeState extends State<Home> {
  @override
  int _selectedIndex = 0;

  initState() {
    super.initState();

    if (widget.sessionUser != null) {
      login();
    } else {
      autoLogin();
    }
  }

  //Shared Preferences
  Future<Null> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userID = prefs.getInt('id');
    final String userName = prefs.getString('name');

    if (userID != null && SocketInfo.hostAdress != "0.0.0.0") {
        MyApp.id = userID;
        MyApp.name = userName;
    } else {
      RouteGenerator.onTapToLogin(context);
    }
  }

  Future<Null> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', widget.sessionUser.id);
    prefs.setString('name', widget.sessionUser.name);
    MyApp.id = widget.sessionUser.id;
    MyApp.name = widget.sessionUser.name;

  }

  Widget choosePageAndColor(int Index) {
    List<Widget> pages = [HomeScreen(), Maps(), Robos(), Friends(), Controls()];

    switch (Index) {
    //HomeScreen
      case 0:
        return PageFrame(
          colorTheme: HomeScreen.colorTheme,
          page: pages[0],
        );
      case 1:
        return PageFrame(
          colorTheme: Maps.colorTheme,
          page: pages[1],
        );
      case 2:
        return PageFrame(
          colorTheme: Robos.colorTheme,
          page: pages[2],
        );
      case 3:
        return PageFrame(
          colorTheme: Friends.colorTheme,
          page: pages[3],
        );
      case 4:
        return PageFrame(
          colorTheme: Controls.colorTheme,
          page: pages[4],
        );
    }
  }

  //If you change order of BottomNavigationBar you also have to change the order in choosePageAndColor Function
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return StatusMessages.exitApp(context);
      },
      child: Scaffold(
          body: Container(

            child: MyApp.id == null
                ? FutureBuilder(
                future: autoLogin(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('');
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return choosePageAndColor(_selectedIndex);
                  }
                })
                : choosePageAndColor(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'Maps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mood),
                label: 'Robos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_contact_calendar),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Controls',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey[900],
            iconSize: 30,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          )),
    );
  }
}
