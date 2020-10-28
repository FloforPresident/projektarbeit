import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:turtlebot/services/socke_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final IOWebSocketChannel channel = IOWebSocketChannel.connect(
      'ws://' + SocketInfo.hostAdress + SocketInfo.port);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TurtleBot',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class Home extends StatefulWidget {
  final WebSocketChannel channel;

  Home({Key key, @required this.channel}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Turtlebot Control App")),
        backgroundColor: Colors.grey,
      ),
      body: AppNavBarController(),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
