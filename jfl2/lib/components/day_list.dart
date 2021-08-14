import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/components/spawn_days.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'filter.dart';
import 'loading_indicator.dart';
import 'menu_future_builder.dart';

class DayList extends StatefulWidget {
  final dayindex;
  DayList({this.dayindex});
  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  late TrainerDayMakerData daydata;
  late TrainerSignUpData trainerdata;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late Future _future;
  setFuture() {
    // _future = daydata.getDay(trainerdata.trainerData.data["_id"]);
  }

  void initState() {
    daydata = Provider.of<TrainerDayMakerData>(context, listen: false);
    trainerdata = Provider.of<TrainerSignUpData>(context, listen: false);
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
              future: _future,
              refreshController: _refreshController,
              dropdownValue: dropdownValue,
              onrefresh: () {
                setState(() {
                  setFuture();
                });
                _future
                    .whenComplete(() => _refreshController.refreshCompleted());
              },
              height: 320.0,
              searchController: search,
              spawner: spawndays,
              daysindex: widget.dayindex,
              mainMenu: false, failedRoutine: (AsyncSnapshot<dynamic> data) {  }, errorRoutine: (Object data) {  },
            ),
          ),
          Positioned(
            top: 0,
            child: Filter(
              searchController: search,
              queryAction: (text) {},
            ),
          ),
        ],
      ),
    );
  }
}
