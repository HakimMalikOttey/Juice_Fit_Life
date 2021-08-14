import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/Screens/trainers/day_editor_launch.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/day_list.dart';
import 'package:jfl2/components/days_container.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/mini_plan_view.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/spawn_days.dart';
import 'package:jfl2/components/fill_in_block.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_screen.dart';
import 'package:jfl2/components/stretch_list.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/week_data.dart';
import 'package:provider/provider.dart';

class TrainerWeekEditor extends StatefulWidget {
  static String id = "TrainerWeekData";
  //0 - edit, 1 - create, 2 - view
  final int? type;
  final String? weekid;
  TrainerWeekEditor({this.type, this.weekid});
  _TrainerWeekEditor createState() => _TrainerWeekEditor();
}

class _TrainerWeekEditor extends State<TrainerWeekEditor> {
  bool didchange = false;
  @override
  void initState() {
    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await showDialog(
              context: context,
              builder: (context) => LoadingDialog(
                  future:
                      Provider.of<TrainerWeekEditorData>(context, listen: false)
                          .retrieveWeekData(widget.weekid as String),
                  errorRoutine: (data) {
                    return CustomAlertBox(
                      infolist: <Widget>[
                        Text(
                            "There was a major error in rendering this page. Please try again later.")
                      ],
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
                  failedRoutine: (data) {
                    return CustomAlertBox(
                      infolist: <Widget>[
                        Text(
                            "We had a problem rendering this page. Please try again later.")
                      ],
                      actionlist: <Widget>[
                        // ignore: deprecated_member_use
                        FlatButton(
                            onPressed: () {
                              WidgetsBinding.instance?.addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Ok"))
                      ],
                    );
                  },
                  successRoutine: (data) {
                    final weekData = jsonDecode(data.data);
                    Provider.of<TrainerWeekEditorData>(context).name.text =
                        weekData["name"];
                    List week = weekData["week"];
                    for (int i = 0; i < week.length; i++) {
                      print(week[i]["type"]);
                      Provider.of<TrainerWeekEditorData>(context)
                              .week[i]
                              .dayElement =
                          new DayData(
                              name: week[i]["name"],
                              id: week[i]["id"],
                              elements: [],
                              type: week[i]["dayType"]);
                    }
                    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  }));
        },
        // ));
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            var baseDialog = CustomAlertBox(
              infolist: <Widget>[
                Text("Do you want to quit out of the Day Editor?"),
              ],
              actionlist: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Provider.of<TrainerWeekEditorData>(context, listen: false)
                        .week
                        .forEach((element) {
                      element.dayElement = null;
                    });
                    Provider.of<UserData>(context, listen: false)
                        .BatchOperation
                        .value = false;
                    // Provider.of<TrainerDayMakerData>(context,listen: false).dayworkouts.clear();
                    // Provider.of<TrainerDayMakerData>(context,listen: false).dayname.clear();
                    // Provider.of<TrainerWorkoutEditorData>(context, listen: false).WorkoutSets.clear();
                    Navigator.of(context, rootNavigator: true).pop(true);
                    // Navigator.pushReplacementNamed(context, Start.id);
                    Navigator.pop(context);
                    // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
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
        title: Text('Week Editor'),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  child: CustomTextBox(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                    ],
                    active: widget.type != 2 ? true : false,
                    controller:
                        Provider.of<TrainerWeekEditorData>(context).name,
                    labelText: 'Your Week Name...(Required)',
                    onChanged: (text) {
                      // Provider.of<TrainerWeekEditorData>(context,listen: false).week.forEach((element) {
                      //   print(element);
                      // });
                      // print(Provider.of<TrainerWeekEditorData>(context,listen: false).week.indexWhere((element) => element["element"][0]["day"].length == 0));
                      setState(() {});
                    },
                    maxlength: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Consumer<TrainerWeekEditorData>(
                        builder: (context, data, child) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: data.week.length,
                            itemBuilder: (context, index) {
                              //If this day within the week has not been turned into a workout day or rest day
                              if (data.week[index].dayElement == null) {
                                return FillInBlock(
                                  day: "${data.week[index].weekday}",
                                  addworkout: () {
                                    data.currentIndex = index;
                                    showDialog(
                                        context: context,
                                        builder: (context) => MiniPlanView(
                                            windowName: 'Select a Day',
                                            dataWindow: DayEditorLaunch(
                                              menuType: false,
                                            )));
                                    // showModalBottomSheet(
                                    //     isScrollControlled: true,
                                    //     context: context,
                                    //     builder: (context) => DayList(
                                    //           dayindex: index,
                                    //         ));
                                  },
                                  addrest: () {
                                    // data.addElement(index, {
                                    //   "type": "rest",
                                    // });
                                  },
                                );
                                //This Day Has been classified as a rest day for the student
                              } else {
                                if (data.week[index].dayElement!.type ==
                                    DayData.dayType[1]) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${data.week[index].weekday}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Container(
                                          height: 60.0,
                                          color: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  "Rest",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 15.0),
                                                  child: widget.type != 2
                                                      ? Row(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  data.currentIndex =
                                                                      index;
                                                                  data.removeElement(
                                                                      index);
                                                                  // data.removeWorkout(index);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        )
                                                      : Container(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                  //This day has been classified as a workout day for the student
                                } else {
                                  // print(weekday);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${data.week[index].weekday}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      DaysContainer(
                                        name: data.week[index].dayElement!.name,
                                        dayId: data.week[index].dayElement!.id,
                                        elements: {},
                                        mainMenu: false,
                                        added: true,
                                        reset: null,
                                        index: index,
                                        view: widget.type != 2 ? true : false,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
                          ));
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Provider.of<TrainerWeekEditorData>(context)
                      .week
                      .indexWhere((element) => element.dayElement == null) ==
                  -1 &&
              Provider.of<TrainerWeekEditorData>(context).name.text != "" &&
              widget.type != 2
          ? BottomAppBar(
              child: Row(
              children: [
                Expanded(
                  child: FooterButton(
                      text: Text(
                        widget.type == 1 ? "Submit Week" : "Edit Week",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      color: Colors.green,
                      action: () {
                        List convert = [];
                        for (int i = 0;
                            i <
                                    Provider.of<TrainerWeekEditorData>(context,
                                            listen: false)
                                        .week
                                        .length ;
                            i++) {
                          Map day;
                          day = {
                            "dayType": Provider.of<TrainerWeekEditorData>(
                                    context,
                                    listen: false)
                                .week[i]
                                .dayElement!
                                .type,
                            "id": Provider.of<TrainerWeekEditorData>(context,
                                    listen: false)
                                .week[i]
                                .dayElement
                                ?.id
                          };
                          convert.add(day);
                          convert.removeAt(i);
                          convert.insert(i, day);
                        }
                        showDialog(
                            context: context,
                            builder: (context) => LoadingDialog(
                                  future: widget.type == 1
                                      ? Provider.of<TrainerWeekEditorData>(
                                              context,
                                              listen: false)
                                          .createWeek(
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .id as String,
                                          {
                                            "week": convert,
                                            "name": Provider.of<
                                                        TrainerWeekEditorData>(
                                                    context,
                                                    listen: false)
                                                .name
                                                .text,
                                          },
                                        )
                                      : Provider.of<TrainerWeekEditorData>(
                                              context,
                                              listen: false)
                                          .editWeek(
                                          widget.weekid as String,
                                          {
                                            "name": Provider.of<
                                                        TrainerWeekEditorData>(
                                                    context)
                                                .name
                                                .text,
                                            "week": convert,
                                          },
                                        ),
                                  successRoutine: (data) {
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text("Week has been saved")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              Provider.of<TrainerWeekEditorData>(
                                                      context,
                                                      listen: false)
                                                  .week
                                                  .forEach((element) {
                                                element.dayElement = null;
                                              });
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback(
                                                      (timeStamp) {
                                                Navigator.pop(context);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                  failedRoutine: (data) {
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text(
                                            "There was an error saving this week. Try again later.")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                  errorRoutine: (data) {
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text(
                                            "There was a major error saving this week. Try again later.")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                ));
                      }),
                ),
              ],
            ))
          : BottomAppBar(
              child: Row(
              children: [
                Expanded(
                  child: FooterButton(
                      text: Text(
                        "Submit Week",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      color: Colors.grey),
                )
              ],
            )),
    );
  }
}
