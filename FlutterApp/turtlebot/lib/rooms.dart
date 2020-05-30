import 'package:flutter/material.dart';

import 'navigation.dart';

class Rooms extends StatelessWidget {
  const Rooms({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room Register"),
      ),
    );
  }
}
