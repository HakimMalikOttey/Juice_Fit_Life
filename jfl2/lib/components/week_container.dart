import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/week_editor.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'batch_delete.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class WeekContainer extends StatefulWidget {
  final Map? elements;
  final String? name;
  final String? weekId;
  final bool? mainMenu;
  final bool? added;
  final Widget? other;
  int? index;
  final bool? view;
  final FutureOr Function(dynamic value)? reset;
  WeekContainer(
      {@required this.elements,
      @required this.mainMenu,
      @required this.weekId,
      @required this.reset,
      @required this.name,
      this.index,
      this.other,
      this.added,
      this.view});

  @override
  _WeekContainerState createState() => _WeekContainerState();
}

class _WeekContainerState extends State<WeekContainer> {
  @override
  final List dayLetters = ["Mun", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  @override
  void initState() {
    if (widget.mainMenu == false && widget.added == true) {
      Provider.of<UserData>(context, listen: false).BatchOperation.value =
          false;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return PlanSegmentCell(
        added: widget.added,
        name: Text("${widget.name}",
            style: Theme.of(context).textTheme.headline6),
        id: widget.weekId as String,
        onLongPressActive: () {
          setState(() {
            Provider.of<UserData>(context, listen: false).BatchOperation.value =
                true;
          });
        },
        onTapActive: () {
          setState(() {
            if (Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .contains("${widget.weekId}")) {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .removeWhere((element) => element == "${widget.weekId}");
            } else {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .add("${widget.weekId}");
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
          print("test");
          showDialog(
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PlanMakerPopUp(
                        name: widget.name as String,
                        listview: [Expanded(child: Container())],
                        remove: widget.mainMenu == false &&
                                widget.added == true &&
                                widget.view != false
                            ? () {
                                Provider.of<TrainerLevelEditorData>(context,
                                        listen: false)
                                    .removepart(widget.index as int);
                                Navigator.pop(context);
                                // Provider.of<TrainerDayMakerData>(context,
                                //         listen: false)
                                //     .removeWorkout(widget.workoutId);
                                // Navigator.pop(context);
                              }
                            : null,
                        add: widget.mainMenu == false && widget.added != true
                            ? () {
                                Provider.of<TrainerLevelEditorData>(context,
                                        listen: false)
                                    .appendpart(widget.weekId as String, widget.name as String);
                                // Provider.of<TrainerDayMakerData>(context,
                                //         listen: false)
                                //     .appendWorkout(
                                //         widget.elements,
                                //         WorkoutSegmentCellData
                                //             .daySegmentTypeList[0]);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            : null,
                        view: widget.mainMenu == false
                            ? () {
                                // Navigator.of(context, rootNavigator: true)
                                //     .pushNamed(TrainerWeekEditor.id, arguments: {
                                //   "dayId": widget.dayId,
                                //   "name": widget.name,
                                //   "media": [],
                                //   "workout": [],
                                //   "type": 0
                                // }).then(widget.reset);
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(TrainerWeekEditor.id,
                                        arguments: {
                                      "weekid": widget.weekId,
                                      "type": 2,
                                    }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                              }
                            : null,
                        delete: widget.mainMenu == true
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (context) => ConfirmLoad(
                                        request:
                                            "This will permanently delete this week: ${widget.name}. Are you sure?",
                                        confirm: () {
                                          Navigator.pop(context);
                                           showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Week has been deleted!",
                                                    failedMessage:
                                                        "There was an error while deleting your week. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while deleting your week. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                TrainerWeekEditorData>(
                                                            context)
                                                        .deleteWeek(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'weekIDs': [
                                                            "${widget.elements!["_id"]}"
                                                          ]
                                                        }),
                                                  ));
                                        },
                                        deny: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
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
                                            "Do you want to copy this week: ${widget.name}?",
                                        confirm: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Week has been copied!",
                                                    failedMessage:
                                                        "There was an error while copying your week. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while copying your week. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                TrainerWeekEditorData>(
                                                            context)
                                                        .copyWeek(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'weekIDs': [
                                                            "${widget.elements!["_id"]}"
                                                          ]
                                                        }),
                                                  ));
                                        },
                                        deny: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                        }));
                              }
                            : null,
                        edit: widget.mainMenu == true
                            ? () {
                                Navigator.pop(context);
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(TrainerWeekEditor.id,
                                        arguments: {
                                      "weekid": widget.weekId,
                                      "type": 0
                                    }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                              }
                            : null),
                  ));
        });
    // return Padding(
    //   padding: const EdgeInsets.only(top: 20.0),
    //   child: Container(
    //     color: Theme.of(context).cardColor,
    //     height: 110.0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Text(
    //                       "${elements["name"]}",
    //                       style: Theme.of(context).textTheme.headline6,
    //                     ),
    //                     Builder(builder: (context) {
    //                       if (checkEmpty == false) {
    //                         return Icon(
    //                           Icons.warning,
    //                           color: Colors.red,
    //                         );
    //                       } else {
    //                         return Container();
    //                       }
    //                     })
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 15.0,
    //                 ),
    //                 Wrap(
    //                   alignment: WrapAlignment.spaceEvenly,
    //                   children: elements["week"].length != 0
    //                       ? List.generate(7, (index) {
    //                           if (elements["week"][index]["type"] == "rest") {
    //                             if (index == dayLetters.length - 1) {
    //                               return Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Text("${dayLetters[index]}: Rest"),
    //                                 ],
    //                               );
    //                             } else {
    //                               return Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Text("${dayLetters[index]}: Rest"),
    //                                   Icon(
    //                                     Icons.arrow_forward_ios,
    //                                     size: 13.0,
    //                                     color: Theme.of(context).accentColor,
    //                                   )
    //                                 ],
    //                               );
    //                             }
    //                           } else {
    //                             if (index == dayLetters.length - 1) {
    //                               return Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Text(
    //                                       "${dayLetters[index]}: ${elements["week"][index]["name"]}"),
    //                                 ],
    //                               );
    //                             } else {
    //                               return Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Text(
    //                                       "${dayLetters[index]}: ${elements["week"][index]["name"]}"),
    //                                   Icon(
    //                                     Icons.arrow_forward_ios,
    //                                     size: 13.0,
    //                                     color: Theme.of(context).accentColor,
    //                                   )
    //                                 ],
    //                               );
    //                             }
    //                           }
    //                         })
    //                       : [],
    //                 )
    //               ],
    //             ),
    //           ),
    //           Container(
    //             child: mainMenu == true
    //                 ? ActionButtons(
    //                     validData: checkEmpty,
    //                     delete: () {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) => ConfirmLoad(
    //                               request:
    //                                   "This will permanently delete this week: ${elements["name"]}. Are you sure?",
    //                               confirm: () {
    //                                 showDialog(
    //                                     barrierDismissible: false,
    //                                     context: context,
    //                                     builder: (BuildContext context) =>
    //                                         LoadingDialog(
    //                                           // future: Provider.of<
    //                                           //             TrainerWeekEditorData>(
    //                                           //         context,
    //                                           //         listen: false)
    //                                           //     .deleteWeek(elements["_id"]),
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error deleting your week. Try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                           errorRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error deleting your week. Try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                           successRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "Week has been successfully deleted.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                         ));
    //                               },
    //                               deny: () {
    //                                 Navigator.of(context, rootNavigator: true)
    //                                     .pop(true);
    //                               }));
    //                     },
    //                     copy: () {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) => ConfirmLoad(
    //                               request:
    //                                   "Do you want to copy this week: ${elements["name"]}",
    //                               confirm: () {
    //                                 List convert = [];
    //                                 convert.addAll(elements["week"]);
    //                                 for (int i = 0;
    //                                     i < convert.length ?? 0;
    //                                     i++) {
    //                                   Map day;
    //                                   if (convert[i]["type"] == "day") {
    //                                     day = {
    //                                       "type": convert[i]["type"],
    //                                       "id": convert[i]["_id"]
    //                                     };
    //                                   } else {
    //                                     day = {
    //                                       "type": convert[i]["type"],
    //                                     };
    //                                   }
    //                                   convert.removeAt(i);
    //                                   convert.insert(i, day);
    //                                 }
    //                                 showDialog(
    //                                     barrierDismissible: false,
    //                                     context: context,
    //                                     builder: (BuildContext context) =>
    //                                         LoadingDialog(
    //                                           future: Provider.of<
    //                                                       TrainerWeekEditorData>(
    //                                                   context,
    //                                                   listen: false)
    //                                               .createWeek(
    //                                             Provider.of<TrainerSignUpData>(
    //                                                     context,
    //                                                     listen: false)
    //                                                 .trainerData
    //                                                 .data["_id"],
    //                                             {
    //                                               "type": "week",
    //                                               "data": convert,
    //                                               "name": elements["name"],
    //                                               "date":
    //                                                   DateTime.now().toString()
    //                                             },
    //                                           ),
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error saving this week. Please try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                           errorRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was a major error saving this week. Please try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                           successRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text("Week has been saved")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (_) {
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       });
    //                                                       Navigator.pop(
    //                                                           context);
    //                                                     },
    //                                                     child: Text("Ok"))
    //                                               ],
    //                                             );
    //                                           },
    //                                         ));
    //                               },
    //                               deny: () {
    //                                 Navigator.of(context, rootNavigator: true)
    //                                     .pop(true);
    //                               }));
    //                       // showDialog(
    //                       //     context: context,
    //                       //     builder: (context) =>CustomAlertBox(
    //                       //       infolist: <Widget>[
    //                       //         Text("Do you want to copy this workout?")
    //                       //       ],
    //                       //       actionlist: <Widget>[
    //                       //         TextButton(
    //                       //             child: Text("Yes"),
    //                       //             onPressed: (){
    //                       //               showDialog(context: context, builder: (context) => LoadingDialog(
    //                       //                   future: Provider.of<TrainerWeekEditorData>(
    //                       //                       context,
    //                       //                       listen: false)
    //                       //                       .createWeek(
    //                       //                     Provider.of<TrainerSignUpData>(context,listen: false)
    //                       //                         .trainerData
    //                       //                         .data["_id"],
    //                       //                     {
    //                       //                       "type": "week",
    //                       //                       "data": convert,
    //                       //                       "name":elements["name"],
    //                       //                       "date": DateTime.now().toString()
    //                       //                     },
    //                       //                   ),
    //                       //                   errorMessage: "There was an error saving this week. Try again later",
    //                       //                   successRoutine: (){
    //                       //                     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //                       //                       Navigator.pop(context);
    //                       //                     });
    //                       //                     Navigator.pop(context);
    //                       //                   },
    //                       //                   errorRoutine: (){
    //                       //                     WidgetsBinding.instance.addPostFrameCallback((_) {
    //                       //                       Navigator.pop(context);
    //                       //                     });
    //                       //                     Navigator.pop(context);
    //                       //                   },
    //                       //                   successMessage: "Week has been saved"));
    //                       //             }),
    //                       //         TextButton(
    //                       //             child: Text("No"),
    //                       //             onPressed: (){
    //                       //               Navigator.of(context,
    //                       //                   rootNavigator:
    //                       //                   true)
    //                       //                   .pop(true);
    //                       //             })
    //                       //       ],
    //                       //     ));
    //                     },
    //                     edit: () {
    //                       Navigator.of(context, rootNavigator: true)
    //                           .pushNamed(TrainerWeekEditor.id, arguments: {
    //                         "parts": elements["week"],
    //                         "name": elements["name"],
    //                         "weekid": elements["_id"],
    //                         "type": 0,
    //                       });
    //                     })
    //                 : Container(),
    //           ),
    //           Container(
    //             child: other,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
