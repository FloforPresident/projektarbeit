import 'package:turtlebot/pages/robos.dart';

class DatabaseObject
{
  String _name;
  int _id;

   get name
   {return _name;}

   get id
   {return _id;}

  DatabaseObject(this._name,this._id);
}

class Robo implements DatabaseObject {
  int _id;
  String _name;
  String iP;


  Robo(this._name, this.iP, this._id);

  @override
  // TODO: implement iD
  get id => _id;

  @override
  // TODO: implement name
  get name => _name;

}

class Room implements DatabaseObject
{


  int _id;
  String _name;
//  List<Robo> _whoHasThisMap; //

  Room(this._id, this._name);

  @override
  // TODO: implement iD
  get id => _id;

  get name => _name;

//  get whoHasThisMap
//  {
//    List<Robo> result;
//
//    for (int i = 0; i < _whoHasThisMap.length; i++)
//      {
//        result.add(_whoHasThisMap[i]);
//      }
//
//    return result;
//  }
//
//  void set whoHasThisMap(List<Robo> robos)
//  {
//    _whoHasThisMap = robos;
//  }

}

class User implements DatabaseObject
{
  int _id;
  String _name;
  int _activeLocation; //Will be Location ID as type for now it is only an int todo Change in set Method aswell

  User(this._id,this._name,this._activeLocation);

  @override
  // TODO: implement id
  get id => _id;

  @override
  // TODO: implement name
  get name => _name;

  get activeLocation => _activeLocation;

  void set activeLocation(int locationID)
  {
    _activeLocation = locationID;
  }
}

class LocationID implements DatabaseObject
{
  int _id;
  int _userId;
  int _roomID;
  String _name;

  LocationID(this._id,this._userId,this._roomID,this._name);

  get id => _id;

  get name => _name;

  get userId => _userId;

  get roomId => _roomID;
}

class Message
{
  int id;
  User recipient;
  User sender;
  String content;
  DateTime dateTime;

  Message(this.id,this.recipient,this.sender,this.content,this.dateTime);
}