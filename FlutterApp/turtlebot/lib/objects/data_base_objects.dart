import 'package:password/password.dart';
import 'package:turtlebot/pages/robos.dart';

class DatabaseObject {
  String _name;
  int _id;

  get name {
    return _name;
  }

  get id {
    return _id;
  }

  DatabaseObject(this._name, this._id);
}



class Robo implements DatabaseObject {
  int _id;
  String _name;
  String _iP;
  Room _activeRoom;

  Robo(this._name, this._iP, this._id, [this._activeRoom = null]);

  @override
  // TODO: implement iD
  get id => _id;

  @override
  // TODO: implement name
  get name => _name;

  get activeRoom => _activeRoom;

  get iP => _iP;
}

class Room implements DatabaseObject {
  int _id;
  String _name;
//  List<Robo> _whoHasThisMap; //

  Room(this._id, this._name);

  @override
  // TODO: implement iD
  get id => _id;

  get name => _name;
}

class User implements DatabaseObject {
  int _id;
  String _name;
  String _activeLocation; //Will be Location ID as type for now it is only an int todo Change in set Method aswell

  User(this._id, this._name, this._activeLocation);

  @override
  // TODO: implement id
  get id => _id;

  @override
  // TODO: implement name
  get name => _name;

  get activeLocation => _activeLocation;

  void set activeLocation(String locationID) {
    _activeLocation = locationID;
  }
}

class LocationID implements DatabaseObject {
  int _id;
  int _roomID;
  String _name;

  LocationID(this._id, this._roomID, this._name);

  get id => _id;

  get name => _name;

  get roomId => _roomID;
}

class Message {
  int id;
  User recipient;
  User sender;
  String content;
  DateTime dateTime;

  Message(this.id, this.recipient, this.sender, this.content, this.dateTime);
}
