import 'package:flutter/material.dart';

class BasicAlertDialog
{
  static void basicAlertDialog(
      {@required BuildContext context,
        @required Text title,
        @required List<Widget> content,
        @required List<Widget> actions }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: title,
              content: Builder(
                builder: (context) {
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: content,
                      ),
                    ),
                  );
                },
              ),
              actions: actions);
        });
  }
}