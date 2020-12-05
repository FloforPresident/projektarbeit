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
  bool _scanned;
//  List<Robo> _whoHasThisMap; //

  Room(this._id, this._roboID, this._name, this._scanned);

  @override
  get id => _id;

  get roboID => _roboID;

  @override
  get name => _name;

  get scanned => _scanned;
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
}

class Location implements DatabaseObject {
  int _id;
  int _roomID;
  String _name;
  double _x;
  double _y;

  Location(this._id, this._roomID, this._name, this._x, this._y);

  @override
  get id => _id;

  @override
  get name => _name;

  get roomId => _roomID;

  get x => _x;

  get y => _y;
}

class Message {
  int _id;
  User _sender;
  User _recipient;
  String _content;

  Message(this._id, this._sender, this._recipient, this._content);

  get id => _id;

  get sender => _sender;

  get recipient => _recipient;

  get content => _content;


}
