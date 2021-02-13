import 'package:shared_preferences/shared_preferences.dart';

class SocketInfo {


  //insert your current IP in 'hostAdress' and get controller on same IP running
  static String hostAdress = "0.0.0.0";
  static const String port = ':8765';



  static setHostAdress(String ipAddres) async
  {
    SocketInfo.hostAdress = ipAddres;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hostAdress", ipAddres);
  }

  static initializeHostAdressFromShared() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("hostAdress") != null)
      {
        hostAdress = prefs.getString("hostAdress");
      }
  }
}
