import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/spawn_workout.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'menu_future_builder.dart';

class WorkoutList extends StatefulWidget {
  _WorkoutList createState() => _WorkoutList();
}

class _WorkoutList extends State<WorkoutList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  late Future _future;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void setFuture() {
    _future = Provider.of<TrainerWorkoutEditorData>(context, listen: false)
        .getworkouts(Provider.of<UserData>(context, listen: false).id as String, {
      'sort': '${Provider.of<UserData>(context, listen: false).sort["query"]}',
      'name':
          '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
    });
  }

  @override
  void initState() {
    setFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: MenuFutureBuilder(
                refreshController: _refreshController,
                onrefresh: () {
                  setState(() {
                    setFuture();
                  });
                  _future.whenComplete(
                      () => _refreshController.refreshCompleted());
                },
                height: 320.0,
                future: _future,
                dropdownValue: dropdownValue,
                searchController: search,
                spawner: spawnWorkouts,
                mainMenu: false, failedRoutine: (AsyncSnapshot<dynamic> data) {  }, errorRoutine: (Object data) {  },),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top:80.0),
          //   child: FutureBuilder(
          //     future: workoutdata.getworkouts(trainerdata.trainerData.data["_id"]),
          //     builder: (context, snapshot) {
          //       if(snapshot.connectionState == ConnectionState.done){
          //         if(snapshot.hasData){
          //           List decoded = json.decode(snapshot.data);
          //           if (dropdownValue == filters[0]) {
          //             decoded.sort(
          //                     (a, b) => (a["name"].toLowerCase()).compareTo(b["name"].toLowerCase()));
          //           } else if (dropdownValue == filters[1]) {
          //             decoded.sort(
          //                     (a, b) => (b["name"].toLowerCase()).compareTo(a["name"].toLowerCase()));
          //           } else if (dropdownValue == filters[2]) {
          //             decoded.sort((a, b) =>
          //                 (DateFormat(a["date"]).format(DateTime.now()))
          //                     .compareTo(DateFormat(b["date"])
          //                     .format(DateTime.now())));
          //           } else if (dropdownValue == filters[3]) {
          //             decoded.sort((a, b) =>
          //                 (DateFormat(b["date"]).format(DateTime.now()))
          //                     .compareTo(DateFormat(a["date"])
          //                     .format(DateTime.now())));
          //           }
          //           return Consumer<TrainerDayMakerData>(
          //               builder: (context,data,child){
          //                 return ListView.builder(
          //                     itemCount:decoded.length,
          //                     shrinkWrap: true,
          //                     physics: ClampingScrollPhysics(),
          //                     itemBuilder: (context,index){
          //                       List decodedworkout = json.decode(decoded[index]["workout"]);
          //                         return ValueListenableBuilder(
          //                           valueListenable: search,
          //                           builder: (context,value,child) {
          //                             if(decoded[index]["name"].contains(search.text.trim())){
          //                               return WorkoutExampleCell(
          //                                 path: decoded[index]["media"],
          //                                 sets: decodedworkout.length != 0 ? decodedworkout.map((e) => e["type"] == "workout" ? 1 : 0).reduce((value, element) => value + element): 0,
          //                                 workoutname: decoded[index]["name"],
          //                                 action: () {
          //                                   data.appendWorkout(decoded[index]);
          //                                   log(decoded[index].toString());
          //                                   Navigator.pop(context);
          //                                   // data.dayworkouts.add(value);
          //                                 },
          //                                 DBactions: Padding(
          //                                   padding:
          //                                   const EdgeInsets.only(right: 10.0),
          //                                 ),
          //                               );
          //                             }
          //                             else{
          //                               return Container();
          //                             }
          //                           }
          //                         );
          //                     }
          //                 );
          //               }
          //           );
          //         }
          //         else{
          //           return LoadingIndicator();
          //         }
          //       }
          //       else{
          //         return LoadingIndicator();
          //       }
          //     }
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   child: Filter(
          //     searchController: search,
          //     queryAction: (text) {},
          //   ),
          // ),
        ],
      ),
    );
  }
}
