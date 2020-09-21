import 'package:flutter/material.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_app_bar.dart';
import 'package:turtlebot/frameworks/custom_navigation_bar/top_bar_image_icon.dart';
import 'package:turtlebot/services/routing.dart';
import 'package:turtlebot/frameworks/custom_data_table/custom_dataTable.dart';
import 'package:turtlebot/frameworks/custom_data_table/custom_colour_text.dart';
import 'package:turtlebot/frameworks/custom_data_table/custom_column_text.dart';



class RoboStatus extends StatefulWidget {

  final String _titleText = "RoboStatus";


  _RoboStatusState createState() => _RoboStatusState();
}



class _RoboStatusState extends State<RoboStatus>
{
  var ident = [
    ["Status", "Connected"],
    ["RoboName", "Robob"],
    ["IP", "192.168.2.44"],
    ["Controller", "PS4"],
    ["Recipient", "Bastian Brunsch"],
    ["Message", "Hallo"],
    ["Room", "Living Room"],
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () { RouteGenerator.onTapToHome(context);},
          ),
          title: TopAppBar(
              [TopBarImageIcon(Icon(Icons.format_list_bulleted, color: Colors.white),RouteGenerator.onTapToRoboStatus),
                TopBarImageIcon(Icon(Icons.computer),RouteGenerator.onTapToRoboCommands),
                TopBarImageIcon(Icon(Icons.games),RouteGenerator.onTapToRoboManControl)],
              widget._titleText
          ),
          backgroundColor: Colors.purple,

        ),
      body: SizedBox(
        width: double.infinity,
        child:       CustomDataTable(
            columns: [DataColumn(label: CustomColumnText(Text(""))), DataColumn(label: CustomColumnText(Text(""))), ],
            rows: CustomDataTable.generateStatusRows(Colors.blue, ident),

      )


      ),

    );
  }
}
