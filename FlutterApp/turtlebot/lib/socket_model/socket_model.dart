import 'dart:io';

import 'package:turtlebot/databaseObjects/data_base_objects.dart';
import 'package:turtlebot/pages/rooms.dart';

class  SocketModel
{
  List<User> userData;
  List<Room> roomData;
  List<LocationID> locationData;
  List<Robo> roboData;

  static final SocketModel _instance = SocketModel._internal();

  SocketModel socket = SocketModel();


  factory SocketModel()
  {
    return _instance;
  }

  SocketModel._internal()
  {
    userData = getUsers();
    roomData = getRooms();
    locationData = getLocationsID();
    roboData = getRobos();
  }



  List<User> getUsers()
  {

  }

  List<Room> getRooms()
  {

  }

  List<LocationID> getLocationsID()
  {

  }

  List<Robo> getRobos()
  {

  }
}