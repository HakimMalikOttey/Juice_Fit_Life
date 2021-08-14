import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/stretch_editor.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/Screens/trainers/workout_editor_launch.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/add_button.dart';
import 'package:jfl2/components/amount_ticker_sideways.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_textfield.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/goal_list.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/mini_plan_view.dart';
import 'package:jfl2/components/rest_container.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/stretch_list.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/components/workout_list.dart';
import 'package:jfl2/components/workout_selector.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/workout_data.dart';
import 'package:jfl2/data/workout_segment_cell_data.dart';
import 'package:provider/provider.dart';

class TrainerDayMaker extends StatefulWidget {
  static String id = "TrainerDayMaker";

  //0 - edit, 1 - create, 2 - view
  final int? type;
  final String? dayId;
  TrainerDayMaker({this.type, this.dayId});

  _TrainerDayMaker createState() => _TrainerDayMaker();
}

class _TrainerDayMaker extends State<TrainerDayMaker> {
  bool didchange = false;
  ScrollController _myController = ScrollController();
  @override
  void initState() {
    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                  future:
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .retrieveDayData(widget.dayId as String),
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
                    Provider.of<TrainerDayMakerData>(context).id = widget.dayId;
                    final Map queryData = jsonDecode(data.data);
                    final List queryDay = queryData["day"];
                    Provider.of<TrainerDayMakerData>(context, listen: false)
                        .dayname
                        .text = queryData["name"];
                    Provider.of<TrainerDayMakerData>(context, listen: false)
                        .description
                        .text = queryData["description"];
                    for (int i = 0; i < queryDay.length; i++) {
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .dayworkouts
                          .add(WorkoutSegmentCellData(
                              type: queryDay[i]["segmentType"] ==
                                      WorkoutSegmentCellData
                                          .daySegmentTypeList[1]
                                  ? WorkoutSegmentCellData.daySegmentTypeList[1]
                                  : WorkoutSegmentCellData
                                      .daySegmentTypeList[0],
                              name: "${queryDay[i]["name"]}",
                              id: "${queryDay[i]["id"]}",
                              timeCieling: new TextEditingController(),
                              timeType: queryDay[i]["timeType"] ==
                                      WorkoutSegmentCellData.timeTypeList[0]
                                  ? WorkoutSegmentCellData.timeTypeList[0]
                                  : WorkoutSegmentCellData.timeTypeList[1]));
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .dayworkouts[i]
                          .timeCieling
                          ?.text = queryDay[i]["time"];
                    }
                    return WidgetsBinding.instance?.addPostFrameCallback((_) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  },
                ));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
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
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .cleardata();
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .dayname
                          .clear();
                      Provider.of<TrainerDayMakerData>(context, listen: false)
                          .description
                          .clear();
                      Provider.of<UserData>(context, listen: false)
                          .BatchOperation
                          .value = false;
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
          title: Text('Day Editor'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Consumer<TrainerDayMakerData>(builder: (context, data, child) {
                return Container(
                  // height: 220.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: CustomTextBox(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9 ]'))
                          ],
                          active: widget.type != 2 ? true : false,
                          controller: data.dayname,
                          labelText: 'Your Day Name...(Required)',
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxlength: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomTextBox(
                        keyboardType: TextInputType.multiline,
                        controller: data.description,
                        active: widget.type != 2 ? true : false,
                        labelText: "Workout Description (Required)",
                        onChanged: (text) {
                          // data.refresh();
                        },
                        lines: 3,
                        // maxlength: 150,
                      ),
                      Container(
                        child: widget.type != 2
                            ? Row(
                                children: [
                                  Expanded(
                                    child: SquareButton(
                                      padding: EdgeInsets.only(top: 0),
                                      color: Colors.orange,
                                      pressed: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) => MiniPlanView(
                                                  windowName:
                                                      'Select a Workout',
                                                  dataWindow:
                                                      WorkoutEditorLaunch(
                                                    menuType: false,
                                                  ),
                                                ));
                                        // showModalBottomSheet(
                                        //     isScrollControlled: true,
                                        //     context: context,
                                        //     builder: (context) =>
                                        //         WorkoutList());
                                      },
                                      butContent: Text(
                                        "Insert a Workout",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                        textAlign: TextAlign.center,
                                      ),
                                      buttonwidth:
                                          MediaQuery.of(context).size.width,
                                      height: 50.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: SquareButton(
                                      padding: EdgeInsets.only(top: 0),
                                      color: Colors.black,
                                      pressed: () {
                                        data.appendWorkout(
                                          "","",
                                            WorkoutSegmentCellData
                                                .daySegmentTypeList[1]);
                                        // print(data.dayworkouts);
                                      },
                                      butContent: Text("Insert a Rest",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1,
                                          textAlign: TextAlign.center),
                                      buttonwidth:
                                          MediaQuery.of(context).size.width,
                                      height: 50.0,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<TrainerDayMakerData>(
                          builder: (context, data, child) {
                        return ReorderableListView(
                            scrollController: _myController,
                            children: <Widget>[
                              for (int index = 0;
                                  index < data.dayworkouts.length;
                                  index++)
                                Padding(
                                  key: Key('$index'),
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Builder(builder: (context) {
                                    final String type =
                                        data.dayworkouts[index].type;
                                    if (type ==
                                        WorkoutSegmentCellData
                                            .daySegmentTypeList[0]) {
                                      // var test = jsonDecode(data
                                      //     .dayworkouts[index]["workout"]);
                                      return WorkoutExampleCell(
                                        name: data.dayworkouts[index].name,
                                        workoutId: data.dayworkouts[index].id,
                                        reset: null,
                                        mainMenu: false,
                                        added: true,
                                        view: widget.type != 2 ? true : false,
                                      );
                                    } else {
                                      return RestContainer(
                                          timeTypeList: WorkoutSegmentCellData
                                              .timeTypeList,
                                          index: index,
                                          changeTimeType: data.changeTimeType,
                                          timeType:
                                              data.dayworkouts[index].timeType as String,
                                          active:
                                              widget.type != 2 ? true : false,
                                          controller: data
                                              .dayworkouts[index].timeCieling as TextEditingController,
                                          delete: () {
                                            data.removeRest(index);
                                          });
                                    }
                                  }),
                                )
                            ],
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final item =
                                    data.dayworkouts.removeAt(oldIndex);
                                data.dayworkouts.insert(newIndex, item);
                                print(data.dayworkouts);
                              });
                            });
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Provider.of<TrainerDayMakerData>(context).dayname.text != "" &&
                  Provider.of<TrainerDayMakerData>(context)
                          .dayworkouts
                          .length !=
                      0 &&
                  widget.type != 2 &&
                  !Provider.of<TrainerDayMakerData>(context, listen: false)
                      .dayworkouts
                      .toString()
                      .contains("[]")
              ? Row(
                  children: [
                    Expanded(
                      child: FooterButton(
                          color: Colors.green,
                          text: Text(
                              widget.type != 0 ? "Submit Day" : "Edit Day",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0)),
                          action: () {
                            Provider.of<TrainerDayMakerData>(context,
                                    listen: false)
                                .DayValidator(context, widget.type as int);
                          }),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: FooterButton(
                        color: Colors.grey,
                        text: Text("Submit Day",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                        action: () {},
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
