import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turtlebot/pages/home/active_location.dart';
import 'package:turtlebot/pages/home/messages.dart';
import 'package:flutter/services.dart';
import 'package:turtlebot/frameworks/logout.dart';


class HomeScreen extends StatefulWidget{

  static Color colorTheme = Colors.orange;
  TextEditingController ipController = new TextEditingController();

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    return
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child:
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Home", style: TextStyle(fontSize: Theme.of(context).textTheme.headline1.fontSize, color: Colors.white),
                      ),
                    ),),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, )
                    ),
                    child: Align(
                    alignment: Alignment.topRight,
                      child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            Logout.logout(context);
                          });
                        },
                        child: Text("Abmelden", style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w400),),
                      ),
                    ),
                  )
                ],
              ),
              ActiveLocation(),
              Container(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ROS-IP"),
                      Container(
                        width: 130,
                        child: TextField(
                          controller: widget.ipController,
                          maxLines: null,
                          maxLength: 15,
                        ),
                      )
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 10, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Nachricht",
                    style: TextStyle(
                      fontSize: 22.0,
                      )),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
                  child: Messages(null))
            ],
          )
      );
  }
}
