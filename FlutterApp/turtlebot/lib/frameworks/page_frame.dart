import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageFrame extends StatefulWidget {
  final Color colorTheme;
  final Widget page;
  final EdgeInsets padding;

  PageFrame({@required this.colorTheme,@required this.page, this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0)});

  @override
  State<StatefulWidget> createState() {
    return _PageFrameState();
  }
}

class _PageFrameState extends State<PageFrame> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: widget.colorTheme),
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0.1, 0.1),
                      colors: [widget.colorTheme, Colors.white])),
            ),
            Container(
              padding: widget.padding,
              child: widget.page,
            ),
          ],
        ),
      ),
    );
  }
}
