import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/week_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';
import 'loading_indicator.dart';
import 'batch_delete.dart';
import 'meal_copy.dart';

class DaysContainer extends StatefulWidget {
  final Map elements;
  final String name;
  final String dayId;
  final bool mainMenu;
  final bool? added;
  final bool? view;
  final Widget? other;
  //for removing element from week list in week maker
  int? index;
  final FutureOr Function(dynamic value)? reset;
  DaysContainer(
      {required this.elements,
      required this.name,
      required this.dayId,
      required this.mainMenu,
      this.added,
      this.other,
      this.index,
      this.view,
      this.reset});

  @override
  _DaysContainerState createState() => _DaysContainerState();
}

class _DaysContainerState extends State<DaysContainer> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      if (widget.mainMenu == false && widget.added == true) {
        Provider.of<UserData>(context, listen: false).BatchOperation.value =
            true;
      }
      super.initState();
    }

    return PlanSegmentCell(
      added: widget.added,
      name:
          Text("${widget.name}", style: Theme.of(context).textTheme.headline6),
      id: widget.dayId,
      onLongPressActive: () {},
      onTapActive: () {
        setState(() {
          if (Provider.of<UserData>(context, listen: false)
              .QueryIds
              .value
              .contains("${widget.elements["_id"]}")) {
            Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .removeWhere(
                    (element) => element == "${widget.elements["_id"]}");
          } else {
            Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .add("${widget.elements["_id"]}");
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
                      remove: widget.mainMenu == false &&
                              widget.added == true &&
                              widget.view != false
                          ? () {
                              Provider.of<TrainerWeekEditorData>(context,
                                      listen: false)
                                  .removeElement(widget.index as int);
                              Navigator.pop(context);
                            }
                          : null,
                      add: widget.mainMenu == false && widget.added != true
                          ? () {
                              Provider.of<TrainerWeekEditorData>(context,
                                      listen: false)
                                  .addElement(
                                      Provider.of<TrainerWeekEditorData>(
                                              context,
                                              listen: false)
                                          .currentIndex as int,
                                      widget.name,
                                      widget.dayId,
                                      [],
                                      DayData.dayType[0]);
                              print(widget.index);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          : null,
                      view: widget.mainMenu == false
                          ? () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(TrainerDayMaker.id, arguments: {
                                "dayId": widget.dayId,
                                "type": 2
                              }).then(widget.reset as  FutureOr<dynamic> Function(Object?));
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
                                                      "Day has been deleted!",
                                                  failedMessage:
                                                      "There was an error while deleting your day. Please try again later.",
                                                  errorMessage:
                                                      "There was a major error while deleting your day. Please try again later.",
                                                  deleteRequest: Provider.of<
                                                              TrainerDayMakerData>(
                                                          context)
                                                      .deleteDay(
                                                          Provider.of<UserData>(
                                                                  context)
                                                              .id as String,
                                                          {
                                                        'dayIDs': [
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
                                          "Do you want to copy this day: ${widget.name}?",
                                      confirm: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                BatchDelete(
                                                  successMessage:
                                                      "Day has been copied!",
                                                  failedMessage:
                                                      "There was an error while copying your day. Please try again later.",
                                                  errorMessage:
                                                      "There was a major error while copying your day. Please try again later.",
                                                  deleteRequest: Provider.of<
                                                              TrainerDayMakerData>(
                                                          context)
                                                      .copyDay(
                                                          Provider.of<UserData>(
                                                                  context)
                                                              .id as String,
                                                          {
                                                        'dayIDs': [
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
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(TrainerDayMaker.id, arguments: {
                                "dayId": widget.elements["_id"],
                                "type": 0
                              }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                            }
                          : null),
                ));
      },
    );
    // var validate =
    //     dayElements.length != 0 || !jsonEncode(elements).contains("[]");
    // return GestureDetector(
    //   onTap: ontap,
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 20.0),
    //     child: Container(
    //       color: Theme.of(context).cardColor,
    //       height: 110.0,
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text(
    //                         "${elements["name"]}",
    //                         style: Theme.of(context).textTheme.headline6,
    //                       ),
    //                       Container(
    //                         child: validate == true
    //                             ? Container()
    //                             : Icon(
    //                                 Icons.warning,
    //                                 color: Colors.red,
    //                               ),
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 15.0,
    //                   ),
    //                   Wrap(
    //                     alignment: WrapAlignment.spaceEvenly,
    //                     children: List.generate(4, (index) {
    //                       if (index < dayElements.length) {
    //                         if (dayElements[index]["name"] != null) {
    //                           if (dayElements.length == 1) {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("${dayElements[index]["name"]}"),
    //                               ],
    //                             );
    //                           } else if (index == dayElements.length - 1) {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("${dayElements[index]["name"]}"),
    //                               ],
    //                             );
    //                           } else if (index == 3 &&
    //                               index == dayElements.length - 1) {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("${dayElements[index]["name"]}"),
    //                               ],
    //                             );
    //                           } else if (index == 3) {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text(
    //                                     "${dayElements[index]["name"]} ... and ${dayElements.length - index} more!"),
    //                               ],
    //                             );
    //                           } else {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("${dayElements[index]["name"]}"),
    //                                 Icon(
    //                                   Icons.arrow_forward_ios,
    //                                   size: 13.0,
    //                                   color: Theme.of(context).accentColor,
    //                                 )
    //                               ],
    //                             );
    //                           }
    //                         } else {
    //                           if (index == 3 ||
    //                               index == dayElements.length - 1) {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("rest"),
    //                               ],
    //                             );
    //                           } else {
    //                             return Row(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Text("rest"),
    //                                 Icon(Icons.arrow_forward_ios,
    //                                     size: 13.0,
    //                                     color: Theme.of(context).accentColor)
    //                               ],
    //                             );
    //                           }
    //                         }
    //                       } else {
    //                         return SizedBox();
    //                       }
    //                     }),
    //                   ),

    //                   // Text("$names")
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               child: mainMenu == true
    //                   ? ActionButtons(
    //                       validData: validate,
    //                       copy: () {
    //                         showDialog(
    //                             context: context,
    //                             builder: (context) => ConfirmLoad(
    //                                 request:
    //                                     "Do you want to copy this day: ${elements["name"]}",
    //                                 confirm: () {
    //                                   List convert = [];
    //                                   convert.addAll(dayElements);
    //                                   for (int i = 0;
    //                                       i < convert.length ?? 0;
    //                                       i++) {
    //                                     if (convert[i]["type"] != "rest") {
    //                                       final Map test = {
    //                                         "type": convert[i]["type"],
    //                                         "id": convert[i]["_id"]
    //                                       };
    //                                       convert.removeAt(i);
    //                                       convert.insert(i, test);
    //                                       // log(convert.toString());
    //                                     }
    //                                   }
    //                                   showDialog(
    //                                       barrierDismissible: false,
    //                                       context: context,
    //                                       builder: (BuildContext context) =>
    //                                           LoadingDialog(
    //                                             future: Provider.of<
    //                                                         TrainerDayMakerData>(
    //                                                     context,
    //                                                     listen: false)
    //                                                 .createDay(
    //                                                     "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
    //                                                     {
    //                                                   "type": "day",
    //                                                   "name": elements["name"],
    //                                                   "day": convert,
    //                                                   "date": DateTime.now()
    //                                                       .toString()
    //                                                 }),
    //                                             errorRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "There was a major error in saving your day. Please try again later")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (_) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                             failedRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "There was an error saving this day. Please try again later.")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (timeStamp) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                             successRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "Day has been saved.")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (timeStamp) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                           ));
    //                                 },
    //                                 deny: () {
    //                                   Navigator.of(context, rootNavigator: true)
    //                                       .pop(true);
    //                                 }));
    //                       },
    //                       delete: () {
    //                         showDialog(
    //                             context: context,
    //                             builder: (context) => ConfirmLoad(
    //                                 request:
    //                                     "This will permanently delete this day: ${elements["name"]}. Are you sure?",
    //                                 confirm: () {
    //                                   showDialog(
    //                                       barrierDismissible: false,
    //                                       context: context,
    //                                       builder: (BuildContext context) =>
    //                                           LoadingDialog(
    //                                             // future: Provider.of<
    //                                             //             TrainerDayMakerData>(
    //                                             //         context,
    //                                             //         listen: false)
    //                                             //     .deleteDay(elements["_id"]),
    //                                             failedRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "There was an error deleting your day. Try again later.")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (_) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                             errorRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "There was a major error deleting your day. Try again later.")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (_) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                             successRoutine: (data) {
    //                                               return CustomAlertBox(
    //                                                 infolist: <Widget>[
    //                                                   Text(
    //                                                       "Day has been successfully deleted.")
    //                                                 ],
    //                                                 actionlist: <Widget>[
    //                                                   // ignore: deprecated_member_use
    //                                                   FlatButton(
    //                                                       onPressed: () {
    //                                                         WidgetsBinding
    //                                                             .instance
    //                                                             .addPostFrameCallback(
    //                                                                 (timeStamp) {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         });
    //                                                         Navigator.pop(
    //                                                             context);
    //                                                       },
    //                                                       child: Text("Ok"))
    //                                                 ],
    //                                               );
    //                                             },
    //                                           ));
    //                                 },
    //                                 deny: () {
    //                                   Navigator.of(context, rootNavigator: true)
    //                                       .pop(true);
    //                                 }));
    //                       },
    //                       edit: () {
    //                         Navigator.of(context, rootNavigator: true)
    //                             .pushNamed(TrainerDayMaker.id, arguments: {
    //                           "parts": dayElements,
    //                           "dayId": elements["_id"],
    //                           "name": elements["name"],
    //                           "type": 0
    //                         });
    //                       },
    //                     )
    //                   : Container(),
    //             ),
    //             Container(
    //               child: delete,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
