import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class FooterButton extends StatelessWidget{
  final Widget text;
  final action;
  final cont;
  final color;
  FooterButton({required this.text,required this.color,this.action,this.cont});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      color: color,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: cont != null ? 20.0: 0,
              child: cont != null ? cont :SizedBox(),
            ),
            Container(
              child: text != null ? text: SizedBox()
            )
            // Text(text, style: TextStyle(color: Colors.white,fontSize: 11.0)),
          ],
        ),
        onPressed: action,
      ),
    );
  }
}