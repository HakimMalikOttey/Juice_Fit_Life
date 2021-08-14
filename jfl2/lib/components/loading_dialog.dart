import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';

import 'custom_alert_box.dart';
import 'loading_indicator.dart';

class LoadingDialog extends StatefulWidget {
  final Future future;
  // final String errorMessage;
  // final String successMessage;
  //Use if you are passing parameter
  final Function(AsyncSnapshot<dynamic> data) successRoutine;
  //Use if not passing parameter
  // final Function(AsyncSnapshot<dynamic> data) successOnTap;
  final Function(AsyncSnapshot<dynamic> data) failedRoutine;
  final Function(Object data) errorRoutine;
  LoadingDialog(
      {required this.future,
      required this.successRoutine,
      required this.failedRoutine,
      required this.errorRoutine});
  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == "") {
                // print("----test-----");
                return widget.failedRoutine(snapshot);
              } else {
                return widget.successRoutine(snapshot);
              }
            } else if (snapshot.hasError) {
              return widget.errorRoutine(snapshot.error as Object);
            } else {
              return LoadingIndicator();
            }
          } else {
            return LoadingIndicator();
          }
        });
  }
}
