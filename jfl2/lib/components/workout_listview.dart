// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jfl2/Screens/trainers/workout_editor.dart';
// import 'package:jfl2/components/workout_example_cell.dart';
// import 'package:jfl2/data/filter_actions.dart';
// import 'package:jfl2/data/trainer_sign_up_data.dart';
// import 'package:jfl2/data/trainer_workout_editor_data.dart';
// import 'package:provider/provider.dart';
//
// import 'action_buttons.dart';
// import 'custom_alert_box.dart';
// import 'loading_indicator.dart';
//
// class WorkoutListview extends StatefulWidget{
//   final dropdownValue;
//   final bool mainMenu;
//   final TextEditingController searchController;
//   WorkoutListview({@required this.dropdownValue,@required this.mainMenu, @required this.searchController});
//   @override
//   _WorkoutListviewState createState() => _WorkoutListviewState();
// }
//
// class _WorkoutListviewState extends State<WorkoutListview> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Provider.of<TrainerWorkoutEditorData>(context)
//             .getworkouts(Provider.of<TrainerSignUpData>(context)
//             .trainerData
//             .data["_id"]),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               print(json.decode(snapshot.data));
//               List decoded = json.decode(snapshot.data);
//               if (widget.dropdownValue == filters[0]) {
//                 decoded.sort(
//                         (a, b) => (a["name"].toLowerCase()).compareTo(b["name"].toLowerCase()));
//               } else if (widget.dropdownValue == filters[1]) {
//                 decoded.sort(
//                         (a, b) => (b["name"].toLowerCase()).compareTo(a["name"].toLowerCase()));
//               } else if (widget.dropdownValue == filters[2]) {
//                 decoded.sort((a, b) =>
//                     (DateFormat(a["date"]).format(DateTime.now()))
//                         .compareTo(DateFormat(b["date"])
//                         .format(DateTime.now())));
//               } else if (widget.dropdownValue == filters[3]) {
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
//                     List decodedworkout = json.decode(decoded[index]["workout"]);
//                     if (decoded[index]["name"]
//                         .contains(widget.searchController.text)) {
//                       return WorkoutExampleCell(
//                         media: decoded[index]["media"],
//                         sets: decodedworkout.length != 0 ? decodedworkout.map((e) => e["type"] == "workout" ? 1 : 0).reduce((value, element) => value + element): 0,
//                         workoutname: decoded[index]["name"],
//                         action: () {
//                         },
//                         DBactions: Padding(
//                             padding:
//                             const EdgeInsets.only(right: 10.0),
//                             child: widget.mainMenu == true ? ActionButtons(
//                               copy: (){
//
//                                 var result = CustomAlertBox(
//                                     infolist: <Widget>[
//                                       Text("Do you want to copy this workout: ${decoded[index]["name"]}")
//                                     ],
//                                     actionlist:<Widget>[
//                                       TextButton(
//                                         child: Text("Yes",style: Theme.of(context).textTheme.headline1,),
//                                        onPressed: () {
//                                           Navigator.of(context, rootNavigator: true).pop(true);
//                                           var copy =  FutureBuilder(
//                                               future:Provider.of<TrainerWorkoutEditorData>(context,
//                                                   listen: false)
//                                                   .createworkouts(
//                                                   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
//                                                   {
//                                                     "name": decoded[index]["name"],
//                                                     "media": decoded[index]["media"],
//                                                     "workout": jsonEncode(decodedworkout),
//                                                     "date": DateTime.now().toString(),
//                                                   }),
//                                               builder:(context,snapshot){
//                                                 if(snapshot.connectionState == ConnectionState.done){
//                                                   if(snapshot.hasData){
//                                                     if(snapshot.data == true){
//                                                       return CustomAlertBox(
//                                                         infolist: <Widget>[
//                                                           Text("Workout has been copied.")
//                                                         ],
//                                                         actionlist: <Widget>[
//                                                           TextButton(
//                                                             child: Text("Ok",style: Theme.of(context).textTheme.headline1,),
//                                                             onPressed: () {
//                                                               Navigator.of(
//                                                                   context,
//                                                                   rootNavigator: true)
//                                                                   .pop(
//                                                                   true);
//                                                               // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
//                                                               // Navigator.pop(context);
//                                                             },
//                                                           ),
//                                                         ],
//                                                       );
//                                                     }
//                                                     else{
//                                                       return CustomAlertBox(
//                                                         infolist: <Widget>[
//                                                           Text("There was an error copying this workout. Please try again later.")
//                                                         ],
//                                                         actionlist: <Widget>[
//                                                           TextButton(
//                                                             child: Text("Ok",style: Theme.of(context).textTheme.headline1,),
//                                                             onPressed: () {
//                                                               Navigator.of(
//                                                                   context,
//                                                                   rootNavigator: true)
//                                                                   .pop(
//                                                                   true);
//                                                               // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
//                                                               // Navigator.pop(context);
//                                                             },
//                                                           ),
//                                                         ],
//                                                       );
//                                                     }
//                                                   }
//                                                   else{
//                                                     return LoadingIndicator();
//                                                   }
//                                                 }
//                                                 else{
//                                                   return LoadingIndicator();
//                                                 }
//                                               }
//                                           );
//                                           showDialog(barrierDismissible: false,context: context, builder: (context)=>copy);
//                                         },
//                                       ),
//                                       TextButton(
//                                         child: Text("No",style: Theme.of(context).textTheme.headline1,),
//                                         onPressed: () {
//                                           Navigator.of(
//                                               context,
//                                               rootNavigator: true)
//                                               .pop(
//                                               true);
//                                           // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
//                                           // Navigator.pop(context);
//                                         },
//                                       ),
//                                     ] );
//                                 showDialog(context: context, builder: (context)=>result);
//                               },
//                               delete: (){
//
//                               },
//                               edit: (){
//                                 Navigator.of(context, rootNavigator: true).pushNamed(
//                                     TrainerWorkoutMakerStraight.id,
//                                     arguments: {
//                                       "workoutid": decoded[index]["_id"],
//                                       "name": decoded[index]["name"],
//                                       "media": decoded[index]["media"],
//                                       "workout": decodedworkout,
//                                       "type":0
//                                     });
//                               },
//                             ):Container()
//                         )
//                       );
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