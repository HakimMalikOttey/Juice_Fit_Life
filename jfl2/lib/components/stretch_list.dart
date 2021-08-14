import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/spawn_container.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/stretch_listview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'menu_future_builder.dart';

class StretchList extends StatefulWidget {
  _StretchList createState() => _StretchList();
}

class _StretchList extends State<StretchList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  late StretchMakerData stretchdata;
  late TrainerSignUpData trainerdata;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late Future _future;
  void setFuture() {
    // _future = stretchdata.getstretches(trainerdata.trainerData.data["_id"]);
  }

  @override
  void initState() {
    stretchdata = Provider.of<StretchMakerData>(context, listen: false);
    trainerdata = Provider.of<TrainerSignUpData>(context, listen: false);
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
            padding: const EdgeInsets.only(top: 60.0),
            child: MenuFutureBuilder(
                future: _future,
                onrefresh: () {
                  setState(() {
                    setFuture();
                  });
                  _future.whenComplete(
                      () => _refreshController.refreshCompleted());
                },
                height: 320.0,
                refreshController: _refreshController,
                dropdownValue: dropdownValue,
                searchController: search,
                spawner: spawnStretch,
                mainMenu: false, errorRoutine: (Object data) {  }, failedRoutine: (AsyncSnapshot<dynamic> data) {  },),
          ),
          Positioned(
            top: 0,
            child: Filter(
              searchController: search,
              queryAction: (text) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
