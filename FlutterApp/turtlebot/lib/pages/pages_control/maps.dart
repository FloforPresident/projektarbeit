import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/top_app_bar_logout.dart';
import 'package:turtlebot/pages/locations.dart';
import 'package:turtlebot/pages/rooms.dart';

import '../friends.dart';
import '../robos.dart';

class Maps extends StatefulWidget{
  @override
  _MapsState createState() {
    return _MapsState();
  }
}

class _MapsState extends State<Maps> {

  final colorTheme = Colors.purple;
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: TopAppBarLogout(
            colorTheme: colorTheme,
            page: "Maps"
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                child: ToggleButtons(
                  fillColor: colorTheme,
                  color: Colors.black,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  borderWidth: 3,
                  borderColor: colorTheme,
                  selectedBorderColor: colorTheme,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text('Rooms')
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text('Locations')
                        ),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      if(index == 0) {
                        isSelected[0] = true;
                        isSelected[1] = false;
                      }
                      else {
                        isSelected[1] = true;
                        isSelected[0] = false;
                      }
                    });
                  },
                  isSelected: isSelected,
                )
              ),
              Padding(padding: const EdgeInsets.all(10.0)),
              isSelected[0] ? Rooms() : Locations(),
            ],
          )
        )
    );
  }
}
