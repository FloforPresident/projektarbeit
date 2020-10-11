import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
      () {
       FocusScopeNode currentFocus = FocusScope.of(context);
       if(!currentFocus.hasPrimaryFocus)
         {
           currentFocus.unfocus();
         }

      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TurtleBot',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Turtlebot Control App")),
        backgroundColor: Colors.grey,
      ),
      body: AppNavBarController(),
    );
  }
}
