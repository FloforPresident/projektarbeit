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

// class User implements DatabaseObject {
//   String name;
//   String password;

//   User(String name, String password) {
//     this.name = name;

//     password = Password.hash(password, new PBKDF2());
//     this.password = password;
//   }

//   static Map<String, dynamic> toJson(String action, User user) =>
//       {'action': action, 'name': user.name, 'password': user.password};

//   @override
//   get id => _id;

//   @override
//   get name => _name;
// }

class Robo implements DatabaseObject {
  int _id;
  String _name;
  String _iP;
  Room _activeRoom;

  Robo(this._name, this._iP, this._id, this._activeRoom);

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
  String
      _activeLocation; //Will be Location ID as type for now it is only an int todo Change in set Method aswell

  User(this._id, this._name, this._activeLocation);

  @override
  get id => _id;

  @override
  get name => _name;

  get activeLocation => _activeLocation;

  void set activeLocation(String locationID) {
    _activeLocation = locationID;
  }
}

class LocationID implements DatabaseObject {
  int _id;
  int _userId;
  int _roomID;
  String _name;

  LocationID(this._id, this._userId, this._roomID, this._name);

  get id => _id;

  get name => _name;

  get userId => _userId;

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
