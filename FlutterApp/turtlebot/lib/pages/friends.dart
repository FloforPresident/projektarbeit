import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  const Friends({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robo Friends"),
        backgroundColor: Colors.red,
      ),
      body: Center(child: Text('Robo Friends')),
    );
  }
}
