import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/square_button.dart';

class WorkoutTimer extends StatefulWidget {
  final int maxtime;
  ValueNotifier<int> _timeleft = ValueNotifier<int>(0);

  WorkoutTimer({required this.maxtime});

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  late Timer _timerobj;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget._timeleft.value = 0;
        print(widget.maxtime);
       _timerobj = Timer.periodic(new Duration(seconds: 1), (timer) {
          widget._timeleft.value++;
          print(widget._timeleft);
          if (widget._timeleft.value == widget.maxtime) {
            timer.cancel();
          }
        });
        var box = CustomAlertBox(
            backgroundcolor: Colors.transparent,
            infolist: <Widget>[
              Center(
                  child: ValueListenableBuilder(
                valueListenable: widget._timeleft,
                builder: (context, value, child) {
                  return Container(
                      child: widget._timeleft.value != widget.maxtime
                          ? Text(
                              "${value}",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text("Time's Up!",
                              style: TextStyle(color: Colors.white)));
                },
              )),
              SquareButton(
                  color: Colors.red,
                  pressed: () {
                    Navigator.pop(context);
                  },
                  butContent: Text("End Timer"),
                  buttonwidth: 30.0)
            ]);
         showDialog(
            barrierColor: Colors.black,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  child: box,
                  onWillPop: () async {
                    return false;
                  });
            });
      },
      child: Container(
        height: 25.0,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Expanded(
                    child: Text(
              "Start rest timer",
              style: TextStyle(color: Colors.white),
            )))
          ],
        ),
      ),
    );
  }
}
