import 'package:flutter/material.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/services/navigation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:turtlebot/services/socke_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Websocket connection logic
  static Map<String, IOWebSocketChannel> channels = Map();

  static IOWebSocketChannel addChannel(routeName) {
    return channels[routeName] = IOWebSocketChannel.connect(
        'ws://' + SocketInfo.hostAdress + SocketInfo.port);
    // return channels[routeName] = channel.stream.asBroadcastStream();
  }

  static deleteChannel(routeName) {
    channels[routeName].sink.close(0, "Closed by the client");
    channels.removeWhere((name, channel) => name == routeName);
  }
  //

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
  Home({Key key}) : super(key: key);

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
}
