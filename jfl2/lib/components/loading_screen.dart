import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';

import 'custom_alert_box.dart';
import 'loading_indicator.dart';

class LoadingScreen extends StatefulWidget {
  final Future future;
  final Function positiveAction;
  LoadingScreen({required this.future, required this.positiveAction});
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == false) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was a problem completing this operation. Please try again later.")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              } else {
                widget.positiveAction();
              }
              return Container();
            } else {
              return LoadingIndicator();
            }
          } else {
            return LoadingIndicator();
          }
        });
  }
}
