import 'package:turtlebot/objects/data_base_objects.dart';

class SocketModel {
  List<User> userData;
  List<Room> roomData;
  List<LocationID> locationData;
  List<Robo> roboData;

  static final SocketModel _instance = SocketModel._internal();

  factory SocketModel() {
    return _instance;
  }

  SocketModel._internal() {
    userData = getUsers();
    roomData = getRooms();
    locationData = getLocationsID();
    roboData = getRobos();
  }

  List<User> getUsers() {}

  List<Room> getRooms() {}

  List<LocationID> getLocationsID() {}

  List<Robo> getRobos() {}
}
