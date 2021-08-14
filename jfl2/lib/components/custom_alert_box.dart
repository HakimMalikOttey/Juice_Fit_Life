
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomAlertBox extends StatelessWidget{

  final infolist;
  final actionlist;
  final backgroundcolor;
  CustomAlertBox({@required this.infolist,this.actionlist,this.backgroundcolor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:backgroundcolor,
      content: SingleChildScrollView(
        child: ListBody(
          children: infolist,
          // <Widget>[
          //   Text("If you quit signing up, all previously inputted data will be lost! Continue?"),
          // ],
        ),
      ),
      actions: actionlist,
      // <Widget>[
      //   FlatButton(
      //     child: Text("Yes"),
      //     onPressed: pressed
      //     //     (){
      //     //   Navigator.of(context,rootNavigator: true).pop(true);
      //     //   Provider .of<TrainerSignUpData>(
      //     //       context, listen: false).resetData();
      //     //   // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
      //     //   Navigator.pop(context);
      //     // },
      //   ),
      //   FlatButton(
      //     child: Text("No"),
      //     onPressed: (){
      //       Navigator.of(context,rootNavigator: true).pop(false);
      //     },
      //   )
      // ],
    );
  }
}