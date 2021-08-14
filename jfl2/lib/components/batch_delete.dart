import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class BatchDelete extends StatelessWidget {
  final Future deleteRequest;
  final String errorMessage;
  final String failedMessage;
  final String successMessage;
  BatchDelete(
      {required this.deleteRequest,
      required this.errorMessage,
      required this.failedMessage,
      required this.successMessage});
  @override
  Widget build(BuildContext context) {
    return LoadingDialog(
      future: deleteRequest,
      failedRoutine: (data) {
        return CustomAlertBox(
          infolist: <Widget>[Text("$failedMessage")],
          actionlist: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        );
      },
      errorRoutine: (data) {
        return CustomAlertBox(
          infolist: <Widget>[Text("$errorMessage")],
          actionlist: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        );
      },
      successRoutine: (data) {
        return WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
              context: context,
              builder: (context) => CustomAlertBox(
                    infolist: <Widget>[Text("$successMessage")],
                    actionlist: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            Provider.of<UserData>(context, listen: false)
                                .QueryIds
                                .value
                                .clear();
                            Provider.of<UserData>(context, listen: false)
                                .queryReload = true;
                            return WidgetsBinding.instance
                                ?.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  ));
        });
      },
    );
  }
}
