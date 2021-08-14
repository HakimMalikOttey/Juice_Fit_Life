// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jfl2/Screens/trainers/stretch_editor.dart';
// import 'package:jfl2/components/workout_example_cell.dart';
// import 'package:jfl2/data/filter_actions.dart';
// import 'package:jfl2/data/stretch_maker_data.dart';
// import 'package:jfl2/data/trainer_day_maker_data.dart';
// import 'package:jfl2/data/trainer_sign_up_data.dart';
// import 'package:provider/provider.dart';
//
// import 'action_buttons.dart';
// import 'custom_alert_box.dart';
// import 'loading_indicator.dart';
//
// class StretchListView extends StatefulWidget{
//   final dropdownvalue;
//   final TextEditingController textcontroller;
//   final bool mainMenu;
//   StretchListView({ @required this.dropdownvalue, @required this.textcontroller,@required this.mainMenu});
//
//   @override
//   _StretchListViewState createState() => _StretchListViewState();
// }
//
// class _StretchListViewState extends State<StretchListView> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Provider.of<StretchMakerData>(context)
//             .getstretches(Provider.of<TrainerSignUpData>(context)
//             .trainerData
//             .data["_id"]),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               List decoded = json.decode(snapshot.data);
//               if (widget.dropdownvalue == filters[0]) {
//                 decoded.sort((a, b) => (a["name"].toLowerCase())
//                     .compareTo(b["name"].toLowerCase()));
//               } else if (widget.dropdownvalue == filters[1]) {
//                 decoded.sort((a, b) => (b["name"].toLowerCase())
//                     .compareTo(a["name"].toLowerCase()));
//               } else if (widget.dropdownvalue == filters[2]) {
//                 decoded.sort((a, b) =>
//                     (DateFormat(a["date"]).format(DateTime.now()))
//                         .compareTo(DateFormat(b["date"])
//                         .format(DateTime.now())));
//               } else if (widget.dropdownvalue == filters[3]) {
//                 decoded.sort((a, b) =>
//                     (DateFormat(b["date"]).format(DateTime.now()))
//                         .compareTo(DateFormat(a["date"])
//                         .format(DateTime.now())));
//               }
//               return ListView.builder(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   itemCount: decoded.length,
//                   itemBuilder: (context, index) {
//                     if (decoded[index]["name"]
//                         .contains(widget.textcontroller.text)) {
//                       return WorkoutExampleCell(
//                           DBactions: Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 10.0),
//                               child: widget.mainMenu == true? ActionButtons(
//                                 copy: () {
//                                   var result = CustomAlertBox(
//                                       infolist: <Widget>[
//                                         Text(
//                                             "Do you want to copy this workout: ${decoded[index]["name"]}")
//                                       ],
//                                       actionlist: <Widget>[
//                                         TextButton(
//                                           child: Text(
//                                             "Yes",
//                                             style:
//                                             Theme.of(context)
//                                                 .textTheme
//                                                 .headline1,
//                                           ),
//                                           onPressed: () {
//                                             Navigator.of(context,
//                                                 rootNavigator:
//                                                 true)
//                                                 .pop(true);
//                                             var copy =
//                                             FutureBuilder(
//                                                 future: Provider.of<
//                                                     StretchMakerData>(
//                                                     context,
//                                                     listen:
//                                                     false)
//                                                     .createstrecth(
//                                                     "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
//                                                     {
//                                                       "name": decoded[index]
//                                                       [
//                                                       "name"],
//                                                       "media":
//                                                       decoded[index]["media"],
//                                                       "date":
//                                                       DateTime.now().toString(),
//                                                     }),
//                                                 builder: (context,
//                                                     snapshot) {
//                                                   if (snapshot
//                                                       .connectionState ==
//                                                       ConnectionState
//                                                           .done) {
//                                                     if (snapshot
//                                                         .hasData) {
//                                                       if (snapshot.data ==
//                                                           true) {
//                                                         return CustomAlertBox(
//                                                           infolist: <Widget>[
//                                                             Text("Workout has been copied.")
//                                                           ],
//                                                           actionlist: <Widget>[
//                                                             TextButton(
//                                                               child: Text(
//                                                                 "Ok",
//                                                                 style: Theme.of(context).textTheme.headline1,
//                                                               ),
//                                                               onPressed: () {
//                                                                 Navigator.of(context, rootNavigator: true).pop(true);
//                                                               },
//                                                             ),
//                                                           ],
//                                                         );
//                                                       } else {
//                                                         return CustomAlertBox(
//                                                           infolist: <Widget>[
//                                                             Text("There was an error copying this workout. Please try again later.")
//                                                           ],
//                                                           actionlist: <Widget>[
//                                                             TextButton(
//                                                               child: Text(
//                                                                 "Ok",
//                                                                 style: Theme.of(context).textTheme.headline1,
//                                                               ),
//                                                               onPressed: () {
//                                                                 Navigator.of(context, rootNavigator: true).pop(true);
//                                                               },
//                                                             ),
//                                                           ],
//                                                         );
//                                                       }
//                                                     } else {
//                                                       return LoadingIndicator();
//                                                     }
//                                                   } else {
//                                                     return LoadingIndicator();
//                                                   }
//                                                 });
//                                             showDialog(
//                                                 barrierDismissible:
//                                                 false,
//                                                 context: context,
//                                                 builder:
//                                                     (context) =>
//                                                 copy);
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: Text(
//                                             "No",
//                                             style:
//                                             Theme.of(context)
//                                                 .textTheme
//                                                 .headline1,
//                                           ),
//                                           onPressed: () {
//                                             Navigator.of(context,
//                                                 rootNavigator:
//                                                 true)
//                                                 .pop(true);
//                                           },
//                                         ),
//                                       ]);
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) =>
//                                       result);
//                                 },
//                                 delete: () {},
//                                 edit: () {
//                                   Navigator.of(context,
//                                       rootNavigator: true)
//                                       .pushNamed(StretchEditor.id,
//                                       arguments: {
//                                         "stretchId":
//                                         decoded[index]["_id"],
//                                         "name": decoded[index]
//                                         ["name"],
//                                         "media": decoded[index]
//                                         ["media"],
//                                         "type": 0
//                                       });
//                                 },
//                               ):Container(),
//                           ),
//                           media: decoded[index]["media"],
//                           sets: null,
//                           workoutname: decoded[index]["name"],
//                           action: widget.mainMenu == false ?(){
//                             Provider.of<TrainerDayMakerData>(context,listen: false).appendWorkout(decoded[index]);
//                             Navigator.pop(context);
//                           }:(){
//
//                           });
//                     } else {
//                       return Container();
//                     }
//                   });
//             } else {
//               return Container();
//             }
//           } else {
//             return Container();
//           }
//         });
//   }
// }
// void _test(){
//   print("teeeeeeeeeeeeeeest");
// }