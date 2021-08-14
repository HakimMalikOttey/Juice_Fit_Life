import 'package:flutter/cupertino.dart';

class CustomStackScaffold extends StatefulWidget{
  final List<Widget> widgets;
  CustomStackScaffold({required this.widgets});
  @override
  _CustomStackScaffoldState createState() => _CustomStackScaffoldState();
}

class _CustomStackScaffoldState extends State<CustomStackScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Stack(
         children: widget.widgets,
       ),
    );
  }
}