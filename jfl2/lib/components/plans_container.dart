import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/Screens/trainers/upload_preperation.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'action_buttons.dart';
import 'batch_delete.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class PlansContainer extends StatefulWidget {
  final elements;
  final name;
  final weekId;
  final bool mainMenu;
  final bool? added;
  final Widget? other;
  final FutureOr Function(dynamic value) reset;
  PlansContainer({
    required this.elements,
    required this.mainMenu,
    required this.weekId,
    required this.reset,
    required this.name,
    this.other,
    this.added,
  });

  @override
  _PlansContainerState createState() => _PlansContainerState();
}

class _PlansContainerState extends State<PlansContainer> {
  @override
  Widget build(BuildContext context) {
    return PlanSegmentCell(
        name: Text("${widget.name}",
            style: Theme.of(context).textTheme.headline6),
        id: widget.weekId,
        onLongPressActive: () {},
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
          showDialog(
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PlanMakerPopUp(
                        name: widget.name,
                        listview: [Expanded(child: Container())],
                        upload: () {},
                        remove: widget.mainMenu == false && widget.added == true
                            ? () {
                                // Provider.of<TrainerDayMakerData>(context,
                                //         listen: false)
                                //     .removeWorkout(widget.workoutId);
                                // Navigator.pop(context);
                              }
                            : null,
                        add: widget.mainMenu == false && widget.added != true
                            ? () {
                                // Provider.of<TrainerDayMakerData>(context,
                                //         listen: false)
                                //     .appendWorkout(
                                //         widget.elements,
                                //         WorkoutSegmentCellData
                                //             .daySegmentTypeList[0]);
                                // Navigator.pop(context);
                                // Navigator.pop(context);
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
                                    .pushNamed(TrainerPlanEditor.id,
                                        arguments: {
                                      "type": 0,
                                      "planId": widget.weekId,
                                    }).then(widget.reset);
                              }
                            : null,
                        delete: widget.mainMenu == true
                            ? () {
                                FirebaseStorage _storage =
                                    FirebaseStorage.instance;
                                showDialog(
                                    context: context,
                                    builder: (context) => ConfirmLoad(
                                        request:
                                            "This will permanently delete this plan: ${widget.name}. Are you sure?",
                                        confirm: () async {
                                          final List links =
                                              widget.elements["pictures"];
                                          //We must clean the database of any pictures that are not being used by a plan. So we will iterate through
                                          // the list of download links and try to delete the document that those links are associated with
                                          await Future.forEach(links,
                                              (element) async {
                                            if (element != null) {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      LoadingDialog(
                                                          future: _storage
                                                              .refFromURL(
                                                                  element as String)
                                                              .delete()
                                                              .then((value) {
                                                            return "finished";
                                                          }),
                                                          successRoutine:
                                                              (data) {
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          failedRoutine:
                                                              (data) {
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          errorRoutine: (data) {
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }));
                                            }
                                          });
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Plan has been deleted!",
                                                    failedMessage:
                                                        "There was an error while deleting  your plan. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while deleting your plan. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                PlanEditorData>(
                                                            context)
                                                        .deletePlan(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'planIDs': [
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
                            ? () async {
                                FirebaseStorage _storage =
                                    FirebaseStorage.instance;

                                showDialog(
                                    context: context,
                                    builder: (context) => ConfirmLoad(
                                        request:
                                            "Do you want to copy this plan: ${widget.name}?",
                                        confirm: () async {
                                          List newLinks = [];
                                          List links =
                                              widget.elements["pictures"];
                                          await Future.forEach(links,
                                              (element) async {
                                            if (element != null) {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      LoadingDialog(
                                                          future: _storage
                                                              .refFromURL(
                                                                  element as String)
                                                              .getData()
                                                              .then(
                                                                  (value) async {
                                                            Reference
                                                                firebaseStorageRef =
                                                                _storage
                                                                    .ref()
                                                                    .child(
                                                                        "folderName")
                                                                    .child(
                                                                        "${Uuid().v4()}");

                                                            return firebaseStorageRef
                                                                .putData(value as Uint8List)
                                                                .then(
                                                                    (task) async {
                                                              return await task
                                                                  .ref
                                                                  .getDownloadURL();
                                                            });
                                                          }),
                                                          successRoutine:
                                                              (data) {
                                                            newLinks
                                                                .add(data.data);
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          failedRoutine:
                                                              (data) {
                                                            newLinks.add(null);
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          errorRoutine: (data) {
                                                            newLinks.add(null);
                                                            return WidgetsBinding
                                                                .instance
                                                                ?.addPostFrameCallback(
                                                                    (timeStamp) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }));
                                            } else {
                                              newLinks.add(null);
                                            }
                                          });
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Plan has been copied!",
                                                    failedMessage:
                                                        "There was an error while copying your plan. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while copying your plan. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                PlanEditorData>(
                                                            context)
                                                        .copyPlan(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'planIDs': [
                                                            "${widget.elements["_id"]}"
                                                          ],
                                                          'links': newLinks
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
                                    .pushNamed(TrainerPlanEditor.id,
                                        arguments: {
                                      "type": 0,
                                      "planId": widget.weekId,
                                    }).then(widget.reset);
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
    //       padding: const EdgeInsets.only(
    //           top: 8.0, bottom: 8.0, left: 8.0, right: 3.0),
    //       child: Row(
    //         children: [
    //           Expanded(
    //               flex: 2,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text(
    //                         "${elements["name"]}",
    //                         style: Theme.of(context).textTheme.headline6,
    //                       ),
    //                       Builder(builder: (context) {
    //                         // print("!!!!!!!!!!!!!!!!!");
    //                         // print(partitions);
    //                         // print("!!!!!!!!!!!!!!!!!");
    //                         // print(test);
    //                         if (validate == false || emptyValidate == false) {
    //                           return Icon(
    //                             Icons.warning,
    //                             color: Colors.red,
    //                           );
    //                         }
    //                         // else if(test == false){
    //                         //   return Icon(Icons.warning,color: Colors.red,);
    //                         // }
    //                         // else if(elements["week"].indexWhere((element) => element["type"] != "rest" && element["day"] == []) != -1){
    //                         //   return Icon(Icons.warning,color: Colors.red,);
    //                         // }
    //                         else {
    //                           return Container();
    //                         }
    //                       })
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 15.0,
    //                   ),
    //                   Wrap(
    //                     alignment: WrapAlignment.spaceEvenly,
    //                     children: List.generate(3, (index) {
    //                       print(elements["partitions"].length);
    //                       if (elements["partitions"].length != 1) {
    //                         if (index > elements["partitions"].length - 1) {
    //                           return Container();
    //                         } else if (index == 0) {
    //                           return Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   "${elements["partitions"].length} Partitions: ${elements["partitions"][0]["name"]}"),
    //                               Icon(
    //                                 Icons.arrow_forward_ios,
    //                                 size: 13.0,
    //                                 color: Theme.of(context).accentColor,
    //                               )
    //                             ],
    //                           );
    //                         }
    //                         if (index == elements["partitions"].length - 1) {
    //                           return Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   "${elements["partitions"][index]["name"]}"),
    //                             ],
    //                           );
    //                         } else {
    //                           return Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   "${elements["partitions"][index]["name"]}"),
    //                               Icon(
    //                                 Icons.arrow_forward_ios,
    //                                 size: 13.0,
    //                                 color: Theme.of(context).accentColor,
    //                               )
    //                             ],
    //                           );
    //                         }
    //                       } else {
    //                         if (index == elements["partitions"].length - 1) {
    //                           return Row(
    //                             children: [
    //                               Text(
    //                                   "1 Partition: ${elements["partitions"][0]["name"]}"),
    //                             ],
    //                           );
    //                         } else {
    //                           return Container();
    //                         }
    //                       }
    //                     }),
    //                   )
    //                 ],
    //               )),
    //           Expanded(
    //               child: mainMenu == true
    //                   ? Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Expanded(
    //                           child: ActionButtons(
    //                               validData: validate == false ||
    //                                       emptyValidate == false
    //                                   ? false
    //                                   : true,
    //                               upload: () {
    //                                 final String fname =
    //                                     Provider.of<TrainerSignUpData>(context,
    //                                             listen: false)
    //                                         .trainerData
    //                                         .data["fname"];
    //                                 final String lname =
    //                                     Provider.of<TrainerSignUpData>(context,
    //                                             listen: false)
    //                                         .trainerData
    //                                         .data["lname"];
    //                                 Navigator.of(context, rootNavigator: true)
    //                                     .pushNamed(UploadPreperation.id,
    //                                         arguments: {
    //                                       "banner": elements["banner"],
    //                                       "title": elements["name"],
    //                                       "author": "$fname $lname",
    //                                       "hook": elements["hook"]
    //                                     });
    //                               },
    //                               delete: () {
    //                                 showDialog(
    //                                     context: context,
    //                                     builder: (context) => ConfirmLoad(
    //                                         request:
    //                                             "This will permanently delete this plan: ${elements["name"]}. Are you sure? (If you made this plan live, that plan will not be changed)",
    //                                         confirm: () {
    //                                           showDialog(
    //                                               barrierDismissible: false,
    //                                               context: context,
    //                                               builder: (BuildContext
    //                                                       context) =>
    //                                                   LoadingDialog(
    //                                                     // future: Provider.of<
    //                                                     //             PlanEditorData>(
    //                                                     //         context,
    //                                                     //         listen: false)
    //                                                     //     .deletePlan(
    //                                                     //         elements[
    //                                                     //             "_id"]),
    //                                                     failedRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "There was a major error deleting your plan. Try again later.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                     errorRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "There was an error deleting your plan. Try again later.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                     successRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "Plan has been successfully deleted.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                   ));
    //                                         },
    //                                         deny: () {
    //                                           Navigator.of(context,
    //                                                   rootNavigator: true)
    //                                               .pop(true);
    //                                         }));
    //                               },
    //                               copy: () async {
    //                                 showDialog(
    //                                     context: context,
    //                                     builder: (context) => ConfirmLoad(
    //                                         request:
    //                                             "Do you want to copy this plan: ${elements["name"]}",
    //                                         confirm: () {
    //                                           List data = [];
    //                                           data.addAll(
    //                                               elements["partitions"]);
    //                                           for (int i = 0;
    //                                               i < data.length;
    //                                               i++) {
    //                                             Map replace = {
    //                                               "type": "partition",
    //                                               "id": data[i]["_id"]
    //                                             };
    //                                             data.removeAt(i);
    //                                             data.insert(i, replace);
    //                                           }
    //                                           showDialog(
    //                                               barrierDismissible: false,
    //                                               context: context,
    //                                               builder: (BuildContext
    //                                                       context) =>
    //                                                   LoadingDialog(
    //                                                     future: Provider.of<
    //                                                                 PlanEditorData>(
    //                                                             context)
    //                                                         .createPlan(
    //                                                             Provider.of<TrainerSignUpData>(
    //                                                                     context)
    //                                                                 .trainerData
    //                                                                 .data["_id"],
    //                                                             {
    //                                                           "type": "plan",
    //                                                           "name": elements[
    //                                                               "name"],
    //                                                           "explanation":
    //                                                               elements[
    //                                                                   "explanation"],
    //                                                           "banner":
    //                                                               elements[
    //                                                                   "banner"],
    //                                                           "partitions":
    //                                                               data,
    //                                                           "hook": elements[
    //                                                               "hook"],
    //                                                           "date": DateTime
    //                                                                   .now()
    //                                                               .toString()
    //                                                         }),
    //                                                     failedRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "There was an error saving this plan. Please try again later.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                     errorRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "There was a major error saving this plan. Please try again later.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                     successRoutine: (data) {
    //                                                       return CustomAlertBox(
    //                                                         infolist: <Widget>[
    //                                                           Text(
    //                                                               "Plan has been saved.")
    //                                                         ],
    //                                                         actionlist: <
    //                                                             Widget>[
    //                                                           // ignore: deprecated_member_use
    //                                                           FlatButton(
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 WidgetsBinding
    //                                                                     .instance
    //                                                                     .addPostFrameCallback(
    //                                                                         (_) {
    //                                                                   Navigator.pop(
    //                                                                       context);
    //                                                                 });
    //                                                                 Navigator.pop(
    //                                                                     context);
    //                                                               },
    //                                                               child: Text(
    //                                                                   "Ok"))
    //                                                         ],
    //                                                       );
    //                                                     },
    //                                                   ));
    //                                         },
    //                                         deny: () {
    //                                           Navigator.of(context,
    //                                                   rootNavigator: true)
    //                                               .pop(true);
    //                                         }));
    //                               },
    //                               edit: () {
    //                                 Navigator.of(context, rootNavigator: true)
    //                                     .pushNamed(TrainerPlanEditor.id,
    //                                         arguments: {
    //                                       "type": 0,
    //                                       "name": elements["name"],
    //                                       "explanation": myJSON,
    //                                       "planId": elements["_id"],
    //                                       "banner": elements["banner"],
    //                                       "partitions": elements["partitions"],
    //                                       "hook": elements["hook"]
    //                                     });
    //                               }),
    //                         ),
    //                       ],
    //                     )
    //                   : Container())
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
