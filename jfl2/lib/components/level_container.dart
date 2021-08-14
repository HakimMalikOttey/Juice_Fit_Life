import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/level_editor.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'batch_delete.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class LevelContainer extends StatefulWidget {
  final elements;
  final name;
  final levelId;
  final bool mainMenu;
  final bool? added;
  final Widget? other;
  final int? index;
  final bool? view;
  final FutureOr Function(dynamic value)? reset;
  LevelContainer(
      {required this.elements,
      required this.mainMenu,
      required this.levelId,
      required this.reset,
      required this.name,
      this.other,
      this.added,
      this.index,
      this.view});

  @override
  _LevelContainerState createState() => _LevelContainerState();
}

class _LevelContainerState extends State<LevelContainer> {
  @override
  void initState() {
    if (widget.mainMenu == false && widget.added == true) {
      Provider.of<UserData>(context, listen: false).BatchOperation.value =
          false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlanSegmentCell(
        added: widget.added,
        name: Text("${widget.name}",
            style: Theme.of(context).textTheme.headline6),
        id: widget.levelId,
        onLongPressActive: () {},
        onTapActive: () {
          setState(() {
            if (Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .contains("${widget.levelId}")) {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .removeWhere((element) => element == "${widget.levelId}");
            } else {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .add("${widget.levelId}");
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
            : null,
        onTapInactive: () {
          showDialog(
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PlanMakerPopUp(
                        name: widget.name,
                        listview: [Expanded(child: Container())],
                        remove: widget.mainMenu == false &&
                                widget.added == true &&
                                widget.view != false
                            ? () {
                                Provider.of<TrainerPartitionEditorData>(context,
                                        listen: false)
                                    .removeLevel(widget.index);
                                Navigator.pop(context);
                              }
                            : null,
                        add: widget.mainMenu == false && widget.added != true
                            ? () {
                                Provider.of<TrainerPartitionEditorData>(context,
                                        listen: false)
                                    .appendLevel(widget.name, widget.levelId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            : null,
                        view: widget.mainMenu == false
                            ? () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(TrainerLevelEditor.id,
                                        arguments: {
                                      "levelid": widget.levelId,
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
                                            "This will permanently delete this level: ${widget.name}. Are you sure?",
                                        confirm: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  BatchDelete(
                                                    successMessage:
                                                        "Level has been deleted!",
                                                    failedMessage:
                                                        "There was an error while deleting your level. Please try again later.",
                                                    errorMessage:
                                                        "There was a major error while deleting your level. Please try again later.",
                                                    deleteRequest: Provider.of<
                                                                TrainerLevelEditorData>(
                                                            context)
                                                        .deleteLevel(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'levelIDs': [
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
                                          Navigator.pop(context);
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
                                                                TrainerLevelEditorData>(
                                                            context)
                                                        .copyLevel(
                                                            Provider.of<UserData>(
                                                                    context)
                                                                .id as String,
                                                            {
                                                          'levelIDs': [
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
                                    .pushNamed(TrainerLevelEditor.id,
                                        arguments: {
                                      "levelid": widget.levelId,
                                      "type": 0,
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
    //               child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 children: [
    //                   Text(
    //                     "${elements["name"]}",
    //                     style: Theme.of(context).textTheme.headline6,
    //                   ),
    //                   Builder(builder: (context) {
    //                     if (canCopy == false) {
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
    //                 height: 15.0,
    //               ),
    //               Wrap(
    //                 crossAxisAlignment: WrapCrossAlignment.start,
    //                 alignment: WrapAlignment.spaceEvenly,
    //                 children: List.generate(4, (index) {
    //                   // log(elements["level"].toString());
    //                   if (elements["level"].length == 1) {
    //                     if (index == 0) {
    //                       return Row(
    //                         children: [
    //                           Text("${elements["level"][0]["name"]}"),
    //                         ],
    //                       );
    //                     } else {
    //                       return Container();
    //                     }
    //                   } else if (index == 3 &&
    //                       index < elements["level"].length - 1) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text("${elements["level"][index]["name"]} ..."),
    //                       ],
    //                     );
    //                   } else if (index == elements["level"].length - 1) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text("${elements["level"][index]["name"]}"),
    //                       ],
    //                     );
    //                   } else if (index < elements["level"].length) {
    //                     return Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Text("${elements["level"][index]["name"]}"),
    //                         Icon(
    //                           Icons.arrow_forward_ios,
    //                           size: 13.0,
    //                           color: Theme.of(context).accentColor,
    //                         )
    //                       ],
    //                     );
    //                   } else {
    //                     return Container();
    //                   }
    //                 }),
    //               ),
    //             ],
    //           )),
    //           Container(
    //             child: mainMenu == true
    //                 ? ActionButtons(
    //                     validData: canCopy,
    //                     delete: () {
    //                       showDialog(
    //                           context: context,
    //                           builder: (context) => ConfirmLoad(
    //                               request:
    //                                   "This will permanently delete this level: ${elements["name"]}. Are you sure?",
    //                               confirm: () {
    //                                 showDialog(
    //                                     barrierDismissible: false,
    //                                     context: context,
    //                                     builder: (BuildContext context) =>
    //                                         LoadingDialog(
    //                                           // future: Provider.of<
    //                                           //             TrainerLevelEditorData>(
    //                                           //         context,
    //                                           //         listen: false)
    //                                           //     .deleteLevel(elements["_id"]),
    //                                           errorRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error deleting your level. Try again later.")
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
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was a major error deleting your level. Try again later.")
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
    //                                                     "Level has been successfully deleted.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (timeStamp) {
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
    //                                 List data = [];
    //                                 data.addAll(elements["level"]);

    //                                 for (int i = 0; i < data.length ?? 0; i++) {
    //                                   Map replace = {
    //                                     "type": data[i]["type"],
    //                                     "id": data[i]["_id"],
    //                                     "weekrep": data[i]["weekrep"]
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
    //                                                       TrainerLevelEditorData>(
    //                                                   context)
    //                                               .createLevel(
    //                                                   Provider.of<TrainerSignUpData>(
    //                                                           context)
    //                                                       .trainerData
    //                                                       .data["_id"],
    //                                                   {
    //                                                 "type": "level",
    //                                                 "name": elements["name"],
    //                                                 "level": data,
    //                                                 "repeat":
    //                                                     elements["repeat"],
    //                                                 "date": DateTime.now()
    //                                                     .toString()
    //                                               }),
    //                                           errorRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was an error saving this level. Please try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (timeStamp) {
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
    //                                           failedRoutine: (data) {
    //                                             return CustomAlertBox(
    //                                               infolist: <Widget>[
    //                                                 Text(
    //                                                     "There was a major error saving this level. Please try again later.")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (timeStamp) {
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
    //                                                 Text("Level has been saved")
    //                                               ],
    //                                               actionlist: <Widget>[
    //                                                 // ignore: deprecated_member_use
    //                                                 FlatButton(
    //                                                     onPressed: () {
    //                                                       WidgetsBinding
    //                                                           .instance
    //                                                           .addPostFrameCallback(
    //                                                               (timeStamp) {
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
    //                       // log(elements["level"][0]["type"].toString());;
    //                     },
    //                     edit: () {
    //                       Navigator.of(context, rootNavigator: true)
    //                           .pushNamed(TrainerLevelEditor.id, arguments: {
    //                         "level": elements,
    //                         "levelid": elements["_id"],
    //                         "type": 0,
    //                         "name": elements["name"],
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
