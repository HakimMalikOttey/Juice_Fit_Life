import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:provider/provider.dart';

class LogOutBox extends StatelessWidget {
  final pressed;
  LogOutBox({@required this.pressed});
  @override
  Widget build(BuildContext context) {
    return CustomAlertBox(
      infolist: <Widget>[
        Text("Do you want to sign out?"),
      ],
      actionlist: <Widget>[
        FlatButton(child: Text("Yes"), onPressed: pressed),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        )
      ],
    );
    // return showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
