import 'package:flutter/cupertino.dart';
import 'package:jfl2/components/spawn_partition.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'filter.dart';
import 'menu_future_builder.dart';

class PartitionList extends StatefulWidget {
  @override
  _PartitionListState createState() => _PartitionListState();
}

class _PartitionListState extends State<PartitionList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  // StretchMakerData stretchdata;
  // TrainerSignUpData trainerdata;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late Future _future;
  void setFuture() {
    // _future = Provider.of<TrainerPartitionEditorData>(context, listen: false)
    //     .getPartition(Provider.of<TrainerSignUpData>(context, listen: false)
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
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
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
                  spawner: spawnPartition,
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
      ),
    );
  }
}
