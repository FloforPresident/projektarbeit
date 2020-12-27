import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/frameworks/no_data_entered.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Login extends StatefulWidget {
  final LoginController controller = new LoginController();

  static List<Room> roomItems = [];
  static List<Location> locationItems = [];

  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  double _leftStart = 40;
  double _rightEnd = 40;
  Color colorTheme = Colors.blueGrey;
  Color secondaryTheme = Colors.white;

  TextEditingController _name = new TextEditingController();
  ControllerCustomDropdown roomDropController = ControllerCustomDropdown<Room>();
  ControllerCustomDropdown locationDropController = ControllerCustomDropdown<Location>();

  // Camera stuff
  File imageFile;

  void _openCamera() async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    this.setState(() {
      imageFile = File(picture.path);
    });
  }


  @override
  void initState() {
    super.initState();

    widget.controller.getData();
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme,
          title: Center(
            child: Text(
              "TurtleBot Control Application",
              style: TextStyle(
                color: secondaryTheme,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Icon(Icons.adb, color: Colors.blueGrey, size: 60),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(_leftStart, 20, _rightEnd, 0),
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(
                        color: colorTheme,
                      )
                    ),
                    maxLength: 20,
                    maxLines: null,
                  )
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  child: Text(
                    "Anmelden",
                    style: TextStyle(
                      color: secondaryTheme,
                    ),
                  ),
                  onPressed: () async {
                    if(_name.text.isNotEmpty) {
                      widget.controller.loginUser(context, _name.text);
                    }
                    else
                      {
                        NoDataDialog.noLoginData(context);
                      }
                  },
                ),
                RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    "Registrieren",
                    style: TextStyle(
                      color: secondaryTheme,
                    ),
                  ),
                  onPressed: () {
                    signupDialog(context);
                  },
                )
              ]
            )
          )
        )
      ),
    );
  }

  void signupDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
            BorderRadius.all(
              Radius.circular(10.0))),
        title: Text("Registrieren"),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              child: TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _name,
                maxLines: null,
                maxLength: 20,
              ),
            );
          }
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen",
                style: TextStyle(color: secondaryTheme)
            ),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Weiter",
                style: TextStyle(color: secondaryTheme)
            ),
            color: Colors.blueGrey,
            onPressed: () {
              if (_name.text.isNotEmpty) {
                pictureDialog(context);
              }
              else
                {
                  NoDataDialog.noLoginData(context);
                }
            },
          ),
        ],
      ),
    );
  }

  void pictureDialog(BuildContext context) {
    bool _uploadedImage = true;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
        title: Text("Registrieren"),
        content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height,
                width: width,
                child: Column(
                  children: <Widget>[
                    Text("Wir brauchen ein frontales Bild von dir, damit die Roboter dich automatisch wiedererkennen"),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: RaisedButton(
                        child: Text("Kamera"),
                        color: colorTheme,
                        textColor: Colors.white,
                        onPressed: () {
                          _openCamera();
                        },
                      ),
                    ),
                  // imageFile != null ? Image.file(imageFile, width: 400, height: 400): Text(''),
                  ],
                ),
              );
            }
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen",
                style: TextStyle(color: secondaryTheme)
            ),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Weiter",
                style: TextStyle(color: secondaryTheme)
            ),
            color: Colors.blueGrey,
            onPressed: () {
              if (imageFile != null) {
                editItemDialog(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void editItemDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        List<Location> selectedLocations = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
              title: Text("Registrieren"),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Text("Hier kannst du den Raum und deinen Platz auswählen, in dem man dich in der Regel findet.\n\nDiese Einstellung kannst du auch später nochmal aktualisieren oder einen neuen Platz hinzufügen."),
                        CustomDropdownLabel(
                          label: Text("Raum:"),
                          child: CustomDropdownMenu<Room>(
                            onChanged: () {
                              List<Location> buffer = [];
                              for(int i = 0; i < Login.locationItems.length; i++) {
                                if(Login.locationItems[i].roomId == roomDropController.getValue().id) {
                                  buffer.add(Login.locationItems[i]);
                                }
                              }
                              setState(() {
                                selectedLocations = [];
                                selectedLocations.addAll(buffer);
                              }
                              );
                            },
                            controller: roomDropController, data: Login.roomItems),
                        ),
                        CustomDropdownLabel(
                          label: Text("Platz"),
                          child: CustomDropdownMenu<Location>(
                              controller: locationDropController,
                              data: selectedLocations),
                        ),
                      ],
                    ),
                  );
                }
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Schließen",
                      style: TextStyle(color: secondaryTheme)
                  ),
                  color: Colors.grey,
                  onPressed: () {
                    RouteGenerator.onTapToLogin(context);
                  },
                ),
                FlatButton(
                  child: Text("Registrieren",
                      style: TextStyle(color: secondaryTheme)
                  ),
                  color: Colors.blueGrey,
                  onPressed: () async {
                    if (locationDropController.getValue() != null) {
                      widget.controller.addUser(context, _name.text, locationDropController.getValue().id, imageFile);
                    }
                    else {
                      widget.controller.addUser(context, _name.text, null, imageFile);
                    }
                  },
                ),
              ],
            );
          }
        );
      }
    );
  }
}

class LoginController {

  void getData() {
    Login.locationItems = [];
    Login.roomItems = [];

    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "GET FRIENDS"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();

        var jsonData = jsonDecode(jsonDataString);
        var locations = jsonData['locations'];
        var rooms = jsonData['rooms'];
        print(rooms);

        for (int i = 0; i < locations.length; i++) {
          Location l = new Location(
              locations[i]['id'],
              locations[i]['room_id'],
              locations[i]['name'],
              locations[i]['x'],
              locations[i]['y']);
          Login.locationItems.add(l);
        }
        for (int i = 0; i < rooms.length; i++) {
          Room r = new Room(rooms[i]['id'], rooms[i]['robo_id'],
              rooms[i]['name'], rooms[i]['scanned']);
          Login.roomItems.add(r);
        }
      }
    });
  }

  void addUser(BuildContext context, String name, int locationID, File imageFile) {

    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "ADD USER", "name": "$name", "location_id": $locationID, "image": "$base64Image"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();

        loginHelper(context, jsonDataString);
      }
      else {
        RouteGenerator.onTapToLogin(context);
      }
    });
  }

  void loginUser(BuildContext context, String name) {
    WebSocketChannel channel = MyApp.con();
    String data =
        '{"action": "LOGIN USER", "name": "$name"}';
    channel.sink.add(data);

    channel.stream.listen((json) async {
      if (json != '') {
        String jsonDataString = json.toString();

        loginHelper(context, jsonDataString);
      }
      else {
        RouteGenerator.onTapToLogin(context);
      }
    });
  }

  void loginHelper(BuildContext context, String jsonDataString) {
    final jsonData = jsonDecode(jsonDataString);

    User sessionUser = new User(jsonData['id'],
        jsonData['location_id'], jsonData['name']);

    RouteGenerator.onTapToHome(context, sessionUser: sessionUser);
  }
}