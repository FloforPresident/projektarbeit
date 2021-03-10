import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/incorrect_ip_adress.dart';
import 'package:turtlebot/frameworks/page_frame.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:web_socket_channel/io.dart';

class FullScreenMapImage extends StatelessWidget {
  final Room room;
  final IOWebSocketChannel channel = MyApp.con();


  FullScreenMapImage({@required this.room})
  {
    get_map_base64();
  }

  void get_map_base64()  {
     String data =
         '{"action": "GET ROOM PICTURE"}';
    channel.sink.add(data);
  }

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
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot)
            {
              if(snapshot.hasData)
                {
                  if(snapshot.data == "\"\"")
                    {
                      return Container(
                        child: Text("Keine Daten von Websocket erhalten"),
                      );
                    }
                  return  Container(
                    child: Image.memory(base64Decode(receiveBase64ImageString(snapshot.data))),

                  );
                }
              else if(snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              else
                {
                  return IncorrectIP();
                }
            }

        ),
      ),
    );
  }

  String receiveBase64ImageString(String snapshotData)
  {
    var json = jsonDecode(snapshotData);
    return json["picture_base64"];
  }
}
