import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/stretch_editor.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/workout_segment_cell_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';
import 'loading_indicator.dart';

Widget spawnStretch(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr reset) {
  return Container();
  // return GestureDetector(
  //     onTap: () {
  //       if (mainMenu == false) {
  //         Provider.of<TrainerDayMakerData>(context, listen: false)
  //             .appendWorkout(
  //                 elements, WorkoutSegmentCellData.daySegmentTypeList[1]);
  //         Navigator.pop(context);
  //       }
  //     },
  // child: WorkoutExampleCell(
  //   dbActions: mainMenu == true
  //       ? Padding(
  //           padding: const EdgeInsets.only(right: 10.0),
  //           child: ActionButtons(
  //             validData: true,
  //             copy: () async {
  //               showDialog(
  //                   context: context,
  //                   builder: (context) => ConfirmLoad(
  //                       request:
  //                           "Do you want to copy this stretch: ${elements["name"]}",
  //                       confirm: () {
  //                         showDialog(
  //                             barrierDismissible: false,
  //                             context: context,
  //                             builder: (BuildContext context) =>
  //                                 LoadingDialog(
  //                                   future: Provider.of<StretchMakerData>(
  //                                           context,
  //                                           listen: false)
  //                                       .createstrecth(
  //                                           "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
  //                                           {
  //                                         "name": elements["name"],
  //                                         "media": elements["media"],
  //                                         "date": DateTime.now().toString(),
  //                                       }),
  //                                   failedRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text(
  //                                             "There was an error saving this stretch. Please try again later.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                   errorRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text(
  //                                             "There was a major error saving this stretch. Please try again later.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                   successRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text("Stretch has been saved.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                 ));
  //                       },
  //                       deny: () {
  //                         Navigator.of(context, rootNavigator: true)
  //                             .pop(true);
  //                       }));
  //             },
  //             delete: () {
  //               showDialog(
  //                   context: context,
  //                   builder: (context) => ConfirmLoad(
  //                       request:
  //                           "This will permanently delete this stretch: ${elements["name"]}. Are you sure?",
  //                       confirm: () {
  //                         showDialog(
  //                             barrierDismissible: false,
  //                             context: context,
  //                             builder: (BuildContext context) =>
  //                                 LoadingDialog(
  //                                   future: Provider.of<StretchMakerData>(
  //                                           context,
  //                                           listen: false)
  //                                       .deletestretch(elements["_id"]),
  //                                   failedRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text(
  //                                             "There was an error deleting your stretch. Try again later.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                   errorRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text(
  //                                             "There was a major error deleting your stretch. Try again later.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                   successRoutine: (data) {
  //                                     return CustomAlertBox(
  //                                       infolist: <Widget>[
  //                                         Text(
  //                                             "Stretch has been successfully deleted.")
  //                                       ],
  //                                       actionlist: <Widget>[
  //                                         // ignore: deprecated_member_use
  //                                         FlatButton(
  //                                             onPressed: () {
  //                                               WidgetsBinding.instance
  //                                                   .addPostFrameCallback(
  //                                                       (_) {
  //                                                 Navigator.pop(context);
  //                                               });
  //                                               Navigator.pop(context);
  //                                             },
  //                                             child: Text("Ok"))
  //                                       ],
  //                                     );
  //                                   },
  //                                 ));
  //                       },
  //                       deny: () {
  //                         Navigator.of(context, rootNavigator: true)
  //                             .pop(true);
  //                       }));
  //             },
  //             edit: () {
  //               Navigator.of(context, rootNavigator: true)
  //                   .pushNamed(StretchEditor.id, arguments: {
  //                 "stretchId": elements["_id"],
  //                 "name": elements["name"],
  //                 "media": elements["media"],
  //                 "type": 0
  //               });
  //             },
  //           ),
  //         )
  //       : Container(),
  //   elements: elements,
  //   mainMenu: mainMenu,
  // ));
}
