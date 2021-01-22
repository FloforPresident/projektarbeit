import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtlebot/frameworks/top_app_bar_logout.dart';
import 'package:turtlebot/pages/maps/locations.dart';
import 'package:turtlebot/pages/maps/rooms.dart';

import '../friends.dart';
import '../robos.dart';

class Maps extends StatefulWidget {
  static final colorTheme = Colors.purple;

  @override
  _MapsState createState() {
    return _MapsState();
  }
}

class _MapsState extends State<Maps> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Karten",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.headline1.fontSize,
                        fontWeight: FontWeight.normal))),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25.0),
              alignment: Alignment.center,
              child: ToggleButtons(
                fillColor: Maps.colorTheme,
                disabledColor: Colors.white,
                color: Colors.white,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                borderWidth: 3,
                borderColor: Maps.colorTheme,
                selectedBorderColor: Maps.colorTheme,
                children: [
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          alignment: Alignment.center, child: Text('Areas')),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          alignment: Alignment.center,
                          child: Text('Locations')),
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    if (index == 0) {
                      isSelected[0] = true;
                      isSelected[1] = false;
                    } else {
                      isSelected[1] = true;
                      isSelected[0] = false;
                    }
                  });
                },
                isSelected: isSelected,
              )),
          Container(
              margin: EdgeInsets.only(top: 30.0),
              child: isSelected[0] ? Rooms() : Locations()),
        ],
      ),
    );
  }
}
