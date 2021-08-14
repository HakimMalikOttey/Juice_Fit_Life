import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'batch_delete.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class PartitionContainer extends StatefulWidget {
  final elements;
  final name;
  final partitionId;
  final bool mainMenu;
  final bool? added;
  final Widget? other;
  int? index;
  final FutureOr Function(dynamic value)? reset;
  PartitionContainer(
      {required this.elements,
      required this.mainMenu,
      required this.partitionId,
      required this.reset,
      required this.name,
      this.other,
      this.added,
      this.index});

  @override
  _PartitionContainerState createState() => _PartitionContainerState();
}

class _PartitionContainerState extends State<PartitionContainer> {
  @override
  Widget build(BuildContext context) {
    return PlanSegmentCell(
        added: widget.added,
        name: Text("${widget.name}",
            style: Theme.of(context).textTheme.headline6),
        id: widget.partitionId,
        onLongPressActive: () {},
        onTapActive: () {
          setState(() {
            if (Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .contains("${widget.partitionId}")) {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .removeWhere((element) => element == "${widget.partitionId}");
            } else {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .add("${widget.partitionId}");
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
                        name: widget.name,
                        listview: [Expanded(child: Container())],
                        remove: widget.mainMenu == false && widget.added == true
                            ? () {
                                Provider.of<PlanEditorData>(context,
                                        listen: false)
                                    .removePartition(widget.index as int);
                                Navigator.pop(context);
                              }
                            : null,
                        add: widget.mainMenu == false && widget.added != true
                            ? () {
                                Provider.of<PlanEditorData>(context,
                                        listen: false)
                                    .addPartition(
                                        widget.name, widget.partitionId);
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
                                    .pushNamed(TrainerPartitionEditor.id,
                                        arguments: {
                                      "type": 2,
                                      "partitionId": widget.partitionId,
                                    }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                              }
                            : null,
                        delete: widget.mainMenu == true
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (context) => ConfirmLoad(
                                        request:
                                            "This will permanently delete this partition: ${widget.name}. Are you sure?",
                                        confirm: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Partition has been deleted",
                                                    failedMessage:
                                                        "There was an error while deleting your partition. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while deleting your partition. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                TrainerPartitionEditorData>(
                                                            context)
                                                        .deletePartition(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'partitionIDs': [
                                                            "${widget.elements["_id"]}"
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
                                            "Do you want to copy this level: ${widget.name}?",
                                        confirm: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Level has been copied!",
                                                    failedMessage:
                                                        "There was an error while copying your level. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while copying your level. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                TrainerPartitionEditorData>(
                                                            context)
                                                        .copyPartition(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'partitionIDs': [
                                                            "${widget.elements["_id"]}"
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
                                // Navigator.of(context, rootNavigator: true)
                                //     .pushNamed(TrainerWeekEditor.id,
                                //         arguments: {
                                //       "dayId": widget.elements["_id"],
                                //       "type": 0
                                //     }).then(widget.reset);
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(TrainerPartitionEditor.id,
                                        arguments: {
                                      "type": 0,
                                      "partitionId": widget.partitionId,
                                    }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                              }
                            : null),
                  ));
        });
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 10.0),
    //   child: Container(
    //     color: Theme.of(context).cardColor,
    //     height: 100.0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //         children: [
    //           Expanded(
    //               child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 children: [
    //                   Text(
    //                     "${elements["name"]}",
    //                     style: Theme.of(context).textTheme.headline6,
    //                   ),
    //                   Builder(builder: (context) {
    //                     // var test = jsonEncode(elements["progression"]).contains("[]");
    //                     // // var test = jsonEncode(elements).contains("[]");
    //                     // print(test);
    //                     if (validate == false) {
    //                       return Icon(
    //                         Icons.warning,
    //                         color: Colors.red,
    //                       );
    //                     } else {
    //                       return Container();
    //                     }
    //                   })
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 5.0,
    //               ),
    //               Wrap(
    //                 children: List.generate(3, (index) {
    //                   if (index == 0 &&
    //                       index == elements["progression"].length - 1) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text(
    //                             "${elements["progression"].length} Level: ${elements["progression"][index]["name"]}"),
    //                       ],
    //                     );
    //                   } else if (index == 0 &&
    //                       elements["progression"].length != 0) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text(
    //                             "${elements["progression"].length} Levels: ${elements["progression"][0]["name"]} "),
    //                         Icon(Icons.arrow_forward_ios,
    //                             size: 13.0,
    //                             color: Theme.of(context).accentColor)
    //                       ],
    //                     );
    //                   } else if (index == elements["progression"].length - 1) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text("${elements["progression"][index]["name"]}"),
    //                       ],
    //                     );
    //                   } else if (index < elements["progression"].length - 1) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text("${elements["progression"][index]["name"]}"),
    //                         Icon(Icons.arrow_forward_ios,
    //                             size: 13.0,
    //                             color: Theme.of(context).accentColor)
    //                       ],
    //                     );
    //                   } else {
    //                     return Container();
    //                   }
    //                 }),
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               Container(
    //                   child: elements["meal"] != ""
    //                       ? Text("Meal Name: ${elements["meal"]["name"]}")
    //                       : Text("")),
    //             ],
    //           )),
    //           Container(
    //             child: mainMenu == true
    //                 ? ActionButtons(
    //                     validData: validate,
    //                     delete: () {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) => ConfirmLoad(
    //                               request:
    //                                   "This will permanently delete this partition: ${elements["name"]}. Are you sure?",
    //                               confirm: () {
    //                                 showDialog(
    //                                     barrierDismissible: false,
    //                                     context: context,
    //                                     builder: (BuildContext context) =>
    //                                         LoadingDialog(
    //                                           future: Provider.of<
    //                                                       TrainerPartitionEditorData>(
    //                                                   context,
    //                                                   listen: false)
    //                                               .deletePartition(
    //                                                   elements["_id"]),
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error deleting your partition. Try again later.")
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
    //                                                     "There was a major error deleting your partition. Try again later.")
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
    //                                                     "Partition has been successfully deleted.")
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
    //                     copy: () async {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) => ConfirmLoad(
    //                               request:
    //                                   "Do you want to copy this week: ${elements["name"]}",
    //                               confirm: () {
    //                                 List data = [];
    //                                 final String mealId =
    //                                     elements["meal"]["_id"];
    //                                 data.addAll(elements["progression"]);
    //                                 for (int i = 0; i < data.length; i++) {
    //                                   Map replace = {
    //                                     "type": "level",
    //                                     "id": data[i]["_id"]
    //                                   };
    //                                   data.removeAt(i);
    //                                   data.insert(i, replace);
    //                                 }
    //                                 showDialog(
    //                                     barrierDismissible: false,
    //                                     context: context,
    //                                     builder: (BuildContext context) =>
    //                                         LoadingDialog(
    //                                           future: Provider.of<
    //                                                       TrainerPartitionEditorData>(
    //                                                   context)
    //                                               .createPartition(
    //                                                   Provider.of<TrainerSignUpData>(
    //                                                           context)
    //                                                       .trainerData
    //                                                       .data["_id"],
    //                                                   {
    //                                                 "type": "partition",
    //                                                 "name": elements["name"],
    //                                                 "explanation":
    //                                                     elements["explanation"],
    //                                                 "progression": data,
    //                                                 "meal": mealId,
    //                                                 "date": DateTime.now()
    //                                                     .toString()
    //                                               }),
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error saving this partition. Please try again later.")
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
    //                                                     "There was a major error saving this partition. Please try again later.")
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
    //                                                     "Partition has been saved.")
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
    //                     edit: () {
    //                       Navigator.of(context, rootNavigator: true)
    //                           .pushNamed(TrainerPartitionEditor.id, arguments: {
    //                         "type": 0,
    //                         "name": elements["name"],
    //                         "explanation": elements["explanation"],
    //                         "partitionId": elements["_id"],
    //                         "levels": elements["progression"],
    //                         "meal":
    //                             elements["meal"] != '' ? elements["meal"] : null
    //                       });
    //                     },
    //                   )
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
