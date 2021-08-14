import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/Screens/trainers/stretch_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/spawn_container.dart';
import 'package:jfl2/components/stretch_list.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/custom_stack_scaffold.dart';
import 'package:jfl2/components/plans_custom_listview.dart';
import 'package:jfl2/components/stretch_listview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrainerStretchEditorLaunch extends StatefulWidget {
  static String id = "TrainerStretchMaker";

  _TrainerStretchEditorLaunch createState() => _TrainerStretchEditorLaunch();
}

class _TrainerStretchEditorLaunch extends State<TrainerStretchEditorLaunch> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController search = new TextEditingController();
  Map dropdownValue = filters[2];
  late Future _future;
  //Starts
  void setFuture() {
    // _future = Provider.of<StretchMakerData>(context, listen: false)
    //     .getstretches(Provider.of<UserData>(context, listen: false).id);
  }

  @override
  void initState() {
    setFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SquareButton(
                color: Colors.black,
                pressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(StretchEditor.id, arguments: {
                    "stretchId": "",
                    "name": "",
                    "media": [],
                    "type": 1
                  });
                },
                butContent: Row(
                  children: [
                    Text(
                      "Create A New Stretch",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.add_circle_outline_outlined)
                  ],
                ),
                buttonwidth: MediaQuery.of(context).size.width),
          ),
          Expanded(
            child: ListView(
              children: [
                MenuFutureBuilder(
                    errorRoutine: (data) {
                      return CustomAlertBox(
                        infolist: <Widget>[
                          Text(
                              "There was a major error in retrieving your levels. Please try again later. Error Code:$data")
                        ],
                        actionlist: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    failedRoutine: (data) {
                      return Container();
                    },
                    onrefresh: () {
                      setState(() {
                        setFuture();
                      });
                      _future.whenComplete(
                          () => _refreshController.refreshCompleted());
                    },
                    refreshController: _refreshController,
                    height: 400.0,
                    future: _future,
                    dropdownValue: dropdownValue,
                    searchController: search,
                    spawner: spawnStretch,
                    mainMenu: true),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: SquareButton(
            //       color: Colors.black,
            //       pressed: () {
            //         Navigator.of(context, rootNavigator: true)
            //             .pushNamed(StretchEditor.id, arguments: {
            //           "stretchId": "",
            //           "name": "",
            //           "media": [],
            //           "type": 1
            //         });
            //       },
            //       butContent: Row(
            //         children: [
            //           Text(
            //             "Create A New Stretch",
            //             style: Theme.of(context).textTheme.headline1,
            //           ),
            //           SizedBox(
            //             width: 10.0,
            //           ),
            //           Icon(Icons.add_circle_outline_outlined)
            //         ],
            //       ),
            //       buttonwidth: MediaQuery.of(context).size.width),
            // ),
            // MenuFutureBuilder(
            //     errorRoutine: (data) {
            //       return CustomAlertBox(
            //         infolist: <Widget>[
            //           Text(
            //               "There was a major error in retrieving your levels. Please try again later. Error Code:$data")
            //         ],
            //         actionlist: <Widget>[
            //           // ignore: deprecated_member_use
            //           FlatButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               child: Text("Ok"))
            //         ],
            //       );
            //     },
            //     failedRoutine: (data) {
            //       return Container();
            //     },
            //     onrefresh: () {
            //       setState(() {
            //         setFuture();
            //       });
            //       _future.whenComplete(
            //           () => _refreshController.refreshCompleted());
            //     },
            //     refreshController: _refreshController,
            //     height: 420.0,
            //     future: _future,
            //     dropdownValue: dropdownValue,
            //     searchController: search,
            //     spawner: spawnStretch,
            //     mainMenu: true),