import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jfl2/Screens/students/workout_review.dart';
import 'package:jfl2/components/amount_ticker.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/dialog_timer.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/workout_timer.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/components/rep_cell.dart';
import 'package:jfl2/main.dart';
import 'package:marquee/marquee.dart';
import '../../components/footer_button.dart';

class WorkoutStart extends StatefulWidget {
  final String? name;
  WorkoutStart({@required this.name});
  static String id = "WorkoutStart";

  @override
  _WorkoutStart createState() => _WorkoutStart();
}

class _WorkoutStart extends State<WorkoutStart>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  Duration time = Duration(seconds: 1);
  late TabController controller;
  int hours = 00;
  int minutes = 00;
  int seconds = 00;
  @override
  void initState() {
    timer = Timer.periodic(time, (timer) async{
      setState(() {
        seconds++;
        if (seconds == 60) {
          seconds = 0;
          minutes++;
        }
        if (minutes == 60) {
          minutes = 0;
          hours++;
        }
      });
      _showNotificationWithNoSound("$hours:$minutes:$seconds",0,Priority.max,Importance.max);
      // await flutterLocalNotificationsPlugin.show(
      //     1, '<b>silent</b> Workout Duration:','<b>silent</b> $hours:$minutes:$seconds', platformChannelSpecifics,
      //     );
    });
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final TextEditingController placeholder = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            var baseDialog = CustomAlertBox(
              infolist: <Widget>[
                Text(
                    "Are you sure you want to quit now? If you do, all of your previously inputted data will be lost."),
              ],
              actionlist: <Widget>[
                FlatButton(
                  child: Text("Keep on Pushing!"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                ),
                FlatButton(
                  child: Text("Give Up!"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => baseDialog);
          },
        ),
        actions: <Widget>[],
        title: Text('${widget.name}'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(
              child: Text("Your Workout"),
            ),
            Tab(
              child: Text("Trainer Expectations"),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.black,
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/no_pic.png",
                                image:
                                    "https://firebasestorage.googleapis.com/v0/b/juicefitlife.appspot.com/o/folderName%2Fimage_cropper_1627588001935.jpg?alt=media&token=a3e639ce-55d6-4efe-9071-3d766cf6b55f",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            width: 100.0,
                            child: Marquee(
                              text:
                                  'There once was a boy who told this story about a boy',
                              pauseAfterRound: Duration(seconds: 2),
                              blankSpace: 12.0,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Hold down to view",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 200.0,
                        child: Column(
                          children: List.generate(1, (index) {
                            int test = 0;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                color: Theme.of(context).cardColor,
                                width: MediaQuery.of(context).size.width,
                                height: 100.0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "Set ${index + 1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                      Expanded(
                                        child: test == 1
                                            ? AmountTicker(
                                                inputFormatters: [
                                                  CurrencyTextInputFormatter(
                                                    locale: 'ko',
                                                    decimalDigits: 0,
                                                    symbol: '',
                                                  )
                                                ],
                                                enabled: true,
                                                controller: placeholder,
                                                label: "Reps",
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    highlightColor: Colors
                                                        .grey[850]
                                                        ?.withOpacity(0.3),
                                                    onTap: () {},
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10.0),
                                                              child:
                                                                  Text("0:0"),
                                                            ),
                                                            Icon(
                                                              Icons.timer,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10.0),
                                                              child: Text(
                                                                  "Start Timer"),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                      Expanded(
                                        child: AmountTicker(
                                          inputFormatters: [
                                            CurrencyTextInputFormatter(
                                              locale: 'ko',
                                              decimalDigits: 0,
                                              symbol: '',
                                            )
                                          ],
                                          enabled: true,
                                          controller: placeholder,
                                          label: "Weight",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        )),
                    Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: GestureDetector(
                        onLongPress: () async{
                          final DialogTimer timeDialog= new DialogTimer();
                          Duration time = Duration(seconds: 1);
                          timeDialog.sec = 0;
                          timeDialog.min = 0;
                          timeDialog.hour = 0;
                          Timer restTimer = Timer.periodic(time, (timer) async{
                            if(timeDialog.setStateFromOutside != null){
                              timeDialog.setStateFromOutside!((){
                                setState(() {
                                  timeDialog.sec++;
                                  print(timeDialog.sec);
                                  if (timeDialog.sec == 60) {
                                    timeDialog.sec  = 0;
                                    timeDialog.min++;
                                  }
                                  if (timeDialog.min == 60) {
                                    timeDialog.min = 0;
                                    timeDialog.hour++;
                                  }
                                });
                              });
                            }
                            _showNotificationWithNoSound("${timeDialog.sec}:${timeDialog.min}:${timeDialog.hour}",1,Priority.high,Importance.low);
                            // await flutterLocalNotificationsPlugin.show(
                            //     1, '<b>silent</b> Workout Duration:','<b>silent</b> $hours:$minutes:$seconds', platformChannelSpecifics,
                            //     );
                          });

                          await timeDialog.OpenTimerDialog(context);
                          restTimer.cancel();
                        },
                        child: Padding(

                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text("Hold to Start Rest Timer",style: Theme.of(context).textTheme.headline1,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.timer,
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            //     child: ListView.builder(
            //   itemCount: 10,
            //   itemBuilder: (context, index) {
            //     return Column(
            //       children: [
            //         RepCell(),
            //         WorkoutTimer(
            //           maxtime: 20,
            //         ),
            //         RepCell(),
            //         WorkoutTimer(
            //           maxtime: 20,
            //         ),
            //         RepCell(),
            //         WorkoutTimer(
            //           maxtime: 20,
            //         ),
            //         SizedBox(
            //           height: 20.0,
            //         ),
            //       ],
            //     );
            //   },
            // )
          ),
          Container()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          highlightColor: Colors.green,
          onLongPress: () {
            print("test");
          },
          onTap: () {},
          child: Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                    Text(
                                      "Time Elapsed",
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  "$hours:$minutes:$seconds",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(fontSize: 25.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("Long press to end workout"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _showNotificationWithNoSound(String time,int channel, Priority priority,Importance importance) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('silent channel id', 'silent channel name',
        'silent channel description',
        playSound: false,
        priority: priority,
        importance: importance,
        enableVibration: false,
        styleInformation: DefaultStyleInformation(true, true));
    IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    MacOSNotificationDetails macOSPlatformChannelSpecifics =
    MacOSNotificationDetails(presentSound: false);
     NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(channel, 'Workout Duration',
        '$time', platformChannelSpecifics);
  }
}
