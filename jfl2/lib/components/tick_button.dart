import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TickButton extends StatelessWidget{
  final ontap;
  final widgeticon;
  TickButton({@required this.ontap,@required this.widgeticon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
          color: Colors.white,
          width: 50.0,
          child: Icon(widgeticon)),
    );
  }
}