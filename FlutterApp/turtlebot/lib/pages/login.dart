import 'package:flutter/material.dart';
import 'package:turtlebot/pages/messages.dart';
import 'package:turtlebot/services/routing.dart';

class Login extends StatelessWidget {
  double _leftStart = 40;
  double _rightEnd = 40;
  double _topSpace = 20;
  Color colorTheme = Colors.green;
  Color secondaryTheme = Colors.white;
  _LoginController controller;

  Login()
  {
    controller = _LoginController(colorTheme);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme,
        title: Center(child: Text("Design the Future in Turtleworld", style: TextStyle(
          color: secondaryTheme,
        ),),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0,50 , 0, 0),
                child: Icon(Icons.adb, color: Colors.green, size: 60),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(_leftStart, 20, _rightEnd, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Username",labelStyle: TextStyle(
                    color: colorTheme,
                  )),
                  maxLength: 20,
                  maxLines: null,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(_leftStart, _topSpace, _rightEnd, 40),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Password", labelStyle: TextStyle(
                    color: colorTheme,
                  )),
                  maxLength: 20,
                  maxLines: null,
                ),
              ),
              RaisedButton(
                color: Colors.grey,
                child: Text("Login", style:  TextStyle(
                  color: secondaryTheme,
                ),),
                onPressed: () {
                  RouteGenerator.onTapToHome(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white),
        backgroundColor: colorTheme,
        onPressed: ()
        {
          controller.addItemDialog(context);
        }
        ,
      )
      ,
    );
  }

}

class _LoginController
{
  Color _colorTheme;

  _LoginController(Color colorTheme)
  {
    _colorTheme = colorTheme;
  }


  Future<bool> addItemDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Add new User"),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                maxLines: null,
                maxLength: 20,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("Picture Upload"),
                  color: _colorTheme,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
              CheckboxListTile(
                title: Text("Picture uploaded"),
                value: false,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                maxLines: null,
                maxLength: 20,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(child: Text("Yes"),
              onPressed: () {Navigator.of(context).pop(true);},),
          ],
        ),
      ),
    );
  }
}
