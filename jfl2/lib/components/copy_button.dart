import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_alert_box.dart';


class CopyButton extends StatelessWidget {
  final request;
  final completemessage;
  final icon;
  CopyButton({@required this.request,@required this.completemessage,@required this.icon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async{
          var result = await request;
          var baseDialog;
          if (result != true) {
            baseDialog = CustomAlertBox(
              infolist: <Widget>[
                Text(
                    "There was an error completing this operation. Please try again later."),
              ],
              actionlist: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                    // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                    // Navigator.pop(context);
                  },
                ),
              ],
            );
          }
          else{
            baseDialog = CustomAlertBox(
              infolist: <Widget>[
                Text("${completemessage}"),
              ],
              actionlist: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                ),
              ],
            );
          }
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        },
        child: icon);
  }
}