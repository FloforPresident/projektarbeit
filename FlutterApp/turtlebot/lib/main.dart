import 'package:flutter/material.dart';

import 'navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bottom NavBar Demo', home: AppNavBarController()
        // initialRoute: '/',
        // onGenerateRoute: RouteGenerator.generateRoute,
        );
  }
}
