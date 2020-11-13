class DatabaseObject {
  int _id;
  String _name;

  get id {
    return _id;
  }

  get name {
    return _name;
  }

  DatabaseObject(this._id, this._name);
}

class Robo implements DatabaseObject {
  int _id;
  String _name;
  String _iP;

  Robo(this._id, this._name, this._iP);

  @override
  get id => _id;

  @override
  get name => _name;

  get iP => _iP;
}

class Room implements DatabaseObject {
  int _id;
  int _roboID;
  String _name;
//  List<Robo> _whoHasThisMap; //

  Room(this._id, this._roboID, this._name);

  @override
  get id => _id;

  get roboID => _roboID;

  get name => _name;
}

class User implements DatabaseObject {
  int _id;
  int _locationID;
  String _name;
  // ByteData image; Hier noch File Upload implementieren

  User(this._id, this._locationID, this._name);

  @override
  get id => _id;

  get locationID => _locationID;

  @override
  get name => _name;

  // void set activeLocation(String locationID) {
  //   _activeLocation = locationID;
  // }
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
