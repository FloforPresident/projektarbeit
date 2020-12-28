import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:after_layout/after_layout.dart';
import 'package:turtlebot/services/alertDialogs/error_messages.dart';
import 'package:turtlebot/services/socke_info.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget
{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoadingPageState();
  }

}

class LoadingPageState extends State<LoadingPage> with AfterLayoutMixin<LoadingPage>
{
  

  void initState()
  {
    super.initState();

  }

  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays ([]);
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Icon(Icons.adb_outlined),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("hostAdress");

    SocketInfo.initializeHostAdress(context);
  }


}