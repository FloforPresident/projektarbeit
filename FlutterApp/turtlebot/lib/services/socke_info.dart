import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class SocketInfo {


  //insert your current IP in 'hostAdress' and get controller on same IP running
  static String hostAdress = '192.168.2.102';
  static const String port = ':8765';


  static Future<String> getLocalIP  () async
  {
    WifiInfo wifi = WifiInfo();
    return await wifi.getWifiIP();
  }

  static setHostAdress() async
  {
    hostAdress = await getLocalIP();
  }
}
