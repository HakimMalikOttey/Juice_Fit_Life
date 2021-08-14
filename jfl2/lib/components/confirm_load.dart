import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_alert_box.dart';

class ConfirmLoad extends StatelessWidget{
  final String request;
  final VoidCallback? confirm;
  final VoidCallback? deny;

  ConfirmLoad({required this.request,required this.confirm,required this.deny});
  @override
  Widget build(BuildContext context) {
    return CustomAlertBox(
        infolist: <Widget>[
          Text("$request")
        ],
      actionlist: <Widget>[
        TextButton(
            onPressed: confirm,
            child: Text("Yes",style: Theme.of(context).textTheme.headline1)),
        TextButton(
            onPressed: deny,
            child: Text("No",style: Theme.of(context).textTheme.headline1,)),
      ],
    );
  }
}