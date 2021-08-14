import 'package:flutter/cupertino.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/spawn_week.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'filter.dart';

class WeekList extends StatefulWidget {
  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late Future _future;
  void setFuture() {
    // _future = Provider.of<TrainerWeekEditorData>(context, listen: false)
    //     .getWeek(Provider.of<TrainerSignUpData>(context, listen: false)
    //         .trainerData
    //         .data["_id"]);
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
                _future
                    .whenComplete(() => _refreshController.refreshCompleted());
              },
              height: 320.0,
              future: _future,
              dropdownValue: dropdownValue,
              searchController: search,
              spawner: spawnweek,
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
