import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turtlebot/frameworks/custom_dropdown_menu.dart';
import 'package:turtlebot/main.dart';
import 'package:turtlebot/objects/data_base_objects.dart';
import 'package:turtlebot/services/alertDialogs/error_messages.dart';
import 'package:turtlebot/services/alertDialogs/status_messages.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:turtlebot/services/socke_info.dart';

class Login extends StatefulWidget {
  LoginController controller;

  static List<Room> roomItems = [];
  static List<Location> locationItems = [];
  static Color colorTheme = Colors.blueGrey;
  Color secondaryTheme = Colors.white;
  GlobalKey<StateCustomDropdownMenu> locationWidgetKey =
      GlobalKey<StateCustomDropdownMenu>();
  int currentvalueRoom;
  TextEditingController name = new TextEditingController();
  TextEditingController ip = new TextEditingController();
  double leftStart = 40;
  double rightEnd = 40;

  Login({Key key}) : super(key: key) {
    this.controller = LoginController(this);
  }

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {


  @override
  void initState() {
    super.initState();
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
      child: WillPopScope(
        onWillPop: () {
          return StatusMessages.exitApp(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(color: Colors.white, width: 3.0))),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          "Servebot,",
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline1.fontSize,
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
                        ),
                      ),
                      Container(
                          child: Text("zu ihren Diensten",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Icon(Icons.adb, color: Colors.white, size: 60),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(widget.leftStart, 20, widget.rightEnd, 0),
                    child: TextField(
                      style: TextStyle(),
                      controller: widget.name,
                      decoration: InputDecoration(
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide()),
                        labelText: "Name",
                        labelStyle: TextStyle(),
                      ),
                      maxLength: 20,
                      maxLines: null,
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(widget.leftStart, 20, widget.rightEnd, 0),
                    child: TextField(
                      style: TextStyle(),
                      controller: widget.ip,
                      decoration: InputDecoration(
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide()),
                        labelText: "IP-Adresse",
                        labelStyle: TextStyle(),
                      ),
                      maxLength: 15,
                      maxLines: null,
                    )),
                RaisedButton(
                  color: Colors.blueGrey,
                  child: Text(
                    "Anmelden",
                    style: TextStyle(
                      color: widget.secondaryTheme,
                    ),
                  ),
                  onPressed: () async {
                    if (widget.name.text.isNotEmpty &&
                        widget.ip.text.isNotEmpty) {
                      SocketInfo.setHostAdress(widget.ip.text);
                      widget.controller.getData();
                      widget.controller.loginUser(context, widget.name.text);
                    } else {
                      ErrorMessages.noDataEntered(context);
                    }
                  },
                ),
                RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    "Registrieren",
                    style: TextStyle(
                      color: widget.secondaryTheme,
                    ),
                  ),
                  onPressed: () {
                    if (widget.ip.text.isNotEmpty) {
                      SocketInfo.setHostAdress(widget.ip.text);
                      widget.controller.signupDialog(context);
                    } else {
                      ErrorMessages.noIpAdress(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetState() {
    setState(() {});
  }
}

class LoginController {
  final Login connectedWidget;

  LoginController(this.connectedWidget);

  // Camera stuff
  File imageFile;

  void _openCamera() async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    imageFile = File(picture.path);
  }

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
          Location l = new Location(locations[i]['id'], locations[i]['room_id'],
              locations[i]['name'], locations[i]['x'], locations[i]['y']);
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

  void addUser(
      BuildContext context, String name, int locationID, File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    try {
      WebSocketChannel channel = MyApp.con();
      String data =
          '{"action": "ADD USER", "name": "$name", "location_id": $locationID, "image": "$base64Image"}';
      channel.sink.add(data);
      channel.stream.listen(
          (json) async {
            if (json != '') {
              String jsonDataString = json.toString();

              loginHelper(context, jsonDataString);
            } else {
              RouteGenerator.onTapToLogin(context);
            }
          },
          cancelOnError: false,
          onError: (Object e) {
            ErrorMessages.wrongIpAdress(context);
          });
    } catch (exception) {
      ErrorMessages.wrongIpAdress(context);
    }
  }

  void loginUser(BuildContext context, String name) {
    WebSocketChannel channel = MyApp.con();
    String data = '{"action": "LOGIN USER", "name": "$name"}';
    channel.sink.add(data);

    channel.stream.listen(
        (json) async {
          if (json != '') {
            String jsonDataString = json.toString();

            try {
              loginHelper(context, jsonDataString);
            } catch (exception) {
              ErrorMessages.wrongUserName(context);
            }
          } else {
            RouteGenerator.onTapToLogin(context);
          }
        },
        cancelOnError: false,
        //onError hast to remain set otherwise Exception will not be caught
        onError: (Object e) {
          ErrorMessages.wrongIpAdress(context);
        });
  }

  void loginHelper(BuildContext context, String jsonDataString) {
    final jsonData = jsonDecode(jsonDataString);

    User sessionUser =
        new User(jsonData['id'], jsonData['location_id'], jsonData['name']);

    RouteGenerator.onTapToHome(context, sessionUser: sessionUser);
  }

  void signupDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text("Registrieren"),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            child: TextField(
              decoration: InputDecoration(labelText: "Name"),
              controller: connectedWidget.name,
              maxLines: null,
              maxLength: 20,
            ),
          );
        }),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen",
                style: TextStyle(color: connectedWidget.secondaryTheme)),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Weiter",
                style: TextStyle(color: connectedWidget.secondaryTheme)),
            color: Colors.blueGrey,
            onPressed: () {
              if (connectedWidget.name.text.isNotEmpty) {
                pictureDialog(context);
              } else {
                ErrorMessages.noDataEntered(context);
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
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text("Registrieren"),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height,
            width: width,
            child: Column(
              children: <Widget>[
                Text(
                    "Wir brauchen ein frontales Bild von dir, damit die Roboter dich automatisch wiedererkennen"),
                Container(
                  margin: EdgeInsets.all(15),
                  child: RaisedButton(
                    child: Text("Kamera"),
                    color: Login.colorTheme,
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
        }),
        actions: <Widget>[
          FlatButton(
            child: Text("Schließen",
                style: TextStyle(color: connectedWidget.secondaryTheme)),
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Weiter",
                style: TextStyle(color: connectedWidget.secondaryTheme)),
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
    ControllerCustomDropdown roomDropController =
        ControllerCustomDropdown<Room>();
    ControllerCustomDropdown locationDropController =
        ControllerCustomDropdown<Location>();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        List<Location> selectedLocations = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text("Registrieren"),
              content: Builder(builder: (context) {
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;

                return Container(
                  height: height,
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Text(
                          "Hier kannst du die Area und deine Location auswählen, in dem man dich in der Regel findet.\n\nDiese Einstellung kannst du auch später nochmal aktualisieren oder einen neuen Platz hinzufügen."),
                      CustomDropdownLabel(
                        label: Text("Area:"),
                        child: CustomDropdownMenu<Room>(
                            onChanged: (value) {
                              List<Location> buffer = [];
                              for (int i = 0;
                                  i < Login.locationItems.length;
                                  i++) {
                                if (Login.locationItems[i].roomId ==
                                    roomDropController.getValue().id) {
                                  buffer.add(Login.locationItems[i]);
                                }
                              }
                              setState(() {
                                selectedLocations = [];
                                selectedLocations.addAll(buffer);
                                connectedWidget.currentvalueRoom = value;
                              });
                            },
                            startValueId: connectedWidget.currentvalueRoom,
                            controller: roomDropController,
                            data: Login.roomItems),
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
              }),
              actions: <Widget>[
                FlatButton(
                  child: Text("Schließen",
                      style: TextStyle(color: connectedWidget.secondaryTheme)),
                  color: Colors.grey,
                  onPressed: () {
                    RouteGenerator.onTapToLogin(context);
                  },
                ),
                FlatButton(
                  child: Text("Registrieren",
                      style: TextStyle(color: connectedWidget.secondaryTheme)),
                  color: Colors.blueGrey,
                  onPressed: () async {
                    if (locationDropController.getValue() != null) {
                      addUser(context, connectedWidget.name.text,
                          locationDropController.getValue().id, imageFile);
                    } else {
                      addUser(
                          context, connectedWidget.name.text, null, imageFile);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
