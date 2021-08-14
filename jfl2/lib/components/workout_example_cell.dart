import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/workout_segment_cell_data.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'action_buttons.dart';
import 'confirm_load.dart';
import 'loading_indicator.dart';
import 'meal_copy.dart';
import 'batch_delete.dart';

class WorkoutExampleCell extends StatefulWidget {
  final List? Media;
  final String name;
  final String workoutId;
  final bool mainMenu;
  final bool? added;
  final bool? view;
  final FutureOr Function(dynamic value)? reset;
  WorkoutExampleCell(
      {
      required this.mainMenu,
      required this.reset,
      this.added,
      this.view,
        this.Media,
      required this.name,
      required this.workoutId});

  @override
  _WorkoutExampleCellState createState() => _WorkoutExampleCellState();
}

class _WorkoutExampleCellState extends State<WorkoutExampleCell> {
  var sets;

  late List decodedworkout;

  @override
  void initState() {
    if (widget.mainMenu == false && widget.added == true) {
      Provider.of<UserData>(context, listen: false).BatchOperation.value =
          false;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlanSegmentCell(
        added: widget.added,
        name: Text("${widget.name}",
            style: Theme.of(context).textTheme.headline6),
        id: "${widget.workoutId}",
        onLongPressActive: () {},
        onTapActive: () {
          setState(() {
            if (Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .contains("${widget.workoutId}")) {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .removeWhere(
                      (element) => element == "${widget.workoutId}");
            } else {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .add("${widget.workoutId}");
            }
            Provider.of<UserData>(context, listen: false).QueryIdsLength.value =
                Provider.of<UserData>(context, listen: false)
                    .QueryIds
                    .value
                    .isNotEmpty;
          });
        },
        onLongPressInactive: widget.mainMenu == true
            ? () {
                setState(() {
                  Provider.of<UserData>(context, listen: false)
                      .BatchOperation
                      .value = true;
                });
              }
            : () {},
        onTapInactive: () {
          showDialog(
              context: context,
              builder: (context) => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PlanMakerPopUp(
                    name: "${widget.name}",
                    listview: [
                      Expanded(
                        // child: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: QuillEditor.basic(
                        //     controller: _controller,
                        //     readOnly: true,
                        //   ),
                        // ),
                        child: Container(),
                      ),
                    ],
                    remove: widget.mainMenu == false &&
                            widget.added == true &&
                            widget.view != false
                        ? () {
                            Provider.of<TrainerDayMakerData>(context,
                                    listen: false)
                                .removeWorkout(widget.workoutId);
                            Navigator.pop(context);
                          }
                        : null,
                    add: widget.mainMenu == false && widget.added != true
                        ? () {
                            Provider.of<TrainerDayMakerData>(context,
                                    listen: false)
                                .appendWorkout(
                                    widget.name,
                                    widget.workoutId,
                                    WorkoutSegmentCellData
                                        .daySegmentTypeList[0]);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null,
                    view: widget.mainMenu == false
                        ? () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerWorkoutMakerStraight.id,
                                    arguments: {
                                  "workoutid": widget.workoutId,
                                  "name": widget.name,
                                  "media": [],
                                  "workout": decodedworkout,
                                  "type": 2
                                }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                          }
                        : null,
                    delete: widget.mainMenu == true
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmLoad(
                                    request:
                                        "This will permanently delete this workout: ${widget.name}. Are you sure?",
                                    confirm: () {
                                      Navigator.pop(context);
                                     showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              BatchDelete(
                                                successMessage:
                                                    "Workout has been deleted!",
                                                failedMessage:
                                                    "There was an error while deleting your workout. Please try again later.",
                                                errorMessage:
                                                    "There was a major error while deleting your workout. Please try again later.",
                                                deleteRequest: Provider.of<
                                                            TrainerWorkoutEditorData>(
                                                        context)
                                                    .deleteworkout(
                                                        Provider.of<UserData>(
                                                                context)
                                                            .id as String,
                                                        {
                                                      'workoutIDs': [
                                                        "${widget.workoutId}"
                                                      ]
                                                    }),
                                              ));
                                    },
                                    deny: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(true);
                                    }));
                          }
                        : null,
                    copy: widget.mainMenu == true
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmLoad(
                                    request:
                                        "Do you want to copy this workout: ${widget.name}?",
                                    confirm: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              BatchDelete(
                                                  deleteRequest: Provider.of<
                                                              TrainerWorkoutEditorData>(
                                                          context)
                                                      .copyWorkout(
                                                          Provider.of<UserData>(
                                                                  context)
                                                              .id as String,
                                                          {
                                                        'workoutIDs': [
                                                          "${widget.workoutId}"
                                                        ]
                                                      }),
                                                  errorMessage:
                                                      "There was a major error while saving your workout. Please try again later.",
                                                  failedMessage:
                                                      "There was an error while saving your workout. Please try again later.",
                                                  successMessage:
                                                      "Workout has been sucessfully saved."));
                                    },
                                    deny: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(true);
                                    }));
                          }
                        : null,
                    edit: widget.mainMenu == true
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerWorkoutMakerStraight.id,
                                    arguments: {
                                  "workoutid": widget.workoutId,
                                  "name": widget.name,
                                  "workout": decodedworkout,
                                  "type": 0
                                }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                          }
                        : null,
                  )));
        });
  }
}
