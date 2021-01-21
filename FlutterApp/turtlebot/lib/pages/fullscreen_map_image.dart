import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/page_frame.dart';
import 'package:turtlebot/objects/data_base_objects.dart';

class FullScreenMapImage extends StatelessWidget {
  final Room room;

  FullScreenMapImage({this.room});

  Widget build(BuildContext context) {
    return PageFrame(
      padding: EdgeInsets.all(0.0),
      colorTheme: Colors.black,
      page: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            room.name,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: Image.asset(
            'images/TestBild.jpg',
          ),
        ),
      ),
    );
  }
}
