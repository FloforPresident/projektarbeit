import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';

class AppNavBarController extends StatefulWidget {
  @override
  _AppNavBarControllerState createState() => _AppNavBarControllerState();
  Color iconTextColor = Colors.white;
}

class _AppNavBarControllerState extends State<AppNavBarController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ButtonTheme(
                minWidth: 300,
                height: 100,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.RouteRobos);
                  },
                  icon: Icon(Icons.mood, color: widget.iconTextColor),
                  label: Text('Robos', style: TextStyle(
                    color: widget.iconTextColor,
                  ),),
                  color: Colors.blue,
                ),
              ),
              ButtonTheme(
                minWidth: 300,
                height: 100,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.RouteFriends);
                  },
                  icon: Icon(Icons.perm_contact_calendar, color: widget.iconTextColor),
                  label: Text('Friends', style: TextStyle(
                    color: widget.iconTextColor,
                  ),),
                  color: Colors.red,
                ),
              ),
              ButtonTheme(
                minWidth: 200,
                height: 100,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.RouteRooms);
                  },
                  icon: Icon(Icons.location_on, color: widget.iconTextColor),
                  label: Text('Rooms', style: TextStyle(
                    color: widget.iconTextColor,
                  ),),
                  color: Colors.purple,
                ),
              ),
              ButtonTheme(
                minWidth: 200,
                height: 100,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.RouteMessages);
                  },
                  icon: Icon(Icons.mail, color: widget.iconTextColor),
                  label: Text('Message', style: TextStyle(
                    color: widget.iconTextColor,
                  ),),
                  color: Colors.orange,
                ),
              ),
              ButtonTheme(
                minWidth: 200,
                height: 100,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, RouteGenerator.RouteRoboStatus);
                  },
                  icon: Icon(Icons.videogame_asset, color: widget.iconTextColor),
                  label: Text('Control', style: TextStyle(
                    color: widget.iconTextColor,
                  ),),
                  color: Colors.green,
                ),
              )
            ]));
  }
}
