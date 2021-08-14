import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget{
  final color;
  final pressed;
  final butContent;
  final buttonwidth;
  final height;
  final padding;
  final elevation;
  SquareButton({@required this.color,@required this.pressed,@required this.butContent, @required this.buttonwidth,this.height,this.padding,this.elevation});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: padding == null ? EdgeInsets.only(top:10.0) : padding,
      child:Material(
        elevation: elevation != null ? elevation:5.0,
        color:color,
        child: Container(
          width: buttonwidth,
          height: height == null ? 45.0 : height ,
          child: MaterialButton(
              onPressed:pressed,
            // child:Text(
            //   butContent,
            //   style: TextStyle(
            //     color:textColor
            //   ),
            // )
            child: butContent,
          ),
        ),
      )
    );
  }
}