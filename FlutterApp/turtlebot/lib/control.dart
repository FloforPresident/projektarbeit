import 'package:flutter/material.dart';

import 'navigation.dart';

class Control extends StatelessWidget {
  const Control({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robo Control"),
      ),
    );
  }
}
