import 'dart:io';

import 'package:turtlebot/databaseObjects/data_base_objects.dart';
import 'package:turtlebot/pages/rooms.dart';

class  SocketModel
{

  static final SocketModel _instance = SocketModel._internal();

  factory SocketModel()
  {
    return _instance;
  }

  SocketModel._internal();



  List<User> getUsers(Robo robo)
  {

  }

  List<Room> getRooms(Robo robo)
  {

  }

  List<LocationID> getLocationsID(Room room)
  {

  }

  List<Robo> getRobos()
  {

  }
}