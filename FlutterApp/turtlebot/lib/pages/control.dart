import 'package:flutter/material.dart';

class Control extends StatefulWidget {
  const Control({Key key}) : super(key: key);

  _ControlState createState() => _ControlState();
}



class _ControlState extends State<Control>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robo Control"),
        backgroundColor: Colors.purple,

          )
        
      );
  }
}
