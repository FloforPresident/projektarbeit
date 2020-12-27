import 'package:flutter/cupertino.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtlebot/services/error_messages.dart';

class SocketInfo {


  //insert your current IP in 'hostAdress' and get controller on same IP running
  static String hostAdress;
  static const String port = ':8765';



  static setHostAdress(String ipAddres) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hostAdress", ipAddres);
    SocketInfo.hostAdress = ipAddres;
  }

  static initializeHostAdress(BuildContext context) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("hostAdress") != null)
      {
        hostAdress = prefs.getString("hostAdress");
      }
    else
      {
        ErrorMessages.noWebSocketConnection(context);
      }
  }
}
