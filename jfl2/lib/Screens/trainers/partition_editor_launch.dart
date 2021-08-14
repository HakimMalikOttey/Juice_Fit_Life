import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_stack_scaffold.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/plans_custom_listview.dart';
import 'package:jfl2/components/spawn_meal.dart';
import 'package:jfl2/components/spawn_partition.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrainerPartitionEditorLaunch extends StatefulWidget {
  static String id = "TrainerPartitionMakerLaunch";
  final bool? menuType;
  TrainerPartitionEditorLaunch({@required this.menuType});
  _TrainerPartitionEditorLaunch createState() =>
      _TrainerPartitionEditorLaunch();
}

class _TrainerPartitionEditorLaunch
    extends State<TrainerPartitionEditorLaunch> {
  TextEditingController search = new TextEditingController();
  Map dropdownValue = filters[2];
  Future _future = Future.value(null);
  var time;
  late Timer clock;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void setfuture() {
    setState(() {
      _future = Provider.of<TrainerPartitionEditorData>(context, listen: false)
          .getPartition(Provider.of<UserData>(context, listen: false).id as String, {
        'sort':
            '${Provider.of<UserData>(context, listen: false).sort["query"]}',
        'name':
            '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
      });
    });
  }

  @override
  void initState() {
    Provider.of<UserData>(context, listen: false).BatchOperation.value = false;
    Provider.of<UserData>(context, listen: false).queryReload = true;
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      if (Provider.of<UserData>(context, listen: false).queryReload == true) {
        Provider.of<UserData>(context, listen: false).queryReload = false;
        setState(() {
          setfuture();
          _future.whenComplete(() => _refreshController.refreshCompleted());
        });
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setfuture();
    });
    if (widget.menuType == true) {
      Provider.of<UserData>(context, listen: false).searchAction = setfuture;
    } else {
      Provider.of<UserData>(context, listen: false).miniSearchAction =
          setfuture;
    }
    super.initState();
  }

  @override
  void dispose() {
    clock.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            child: widget.menuType == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SquareButton(
                        color: Colors.black,
                        pressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(TrainerPartitionEditor.id, arguments: {
                            "type": 1,
                            "name": "",
                            "explanation": "",
                            "partitionId": "",
                            "levels": [],
                            "meal": {}
                          });
                        },
                        butContent: Row(
                          children: [
                            Text(
                              "Create A New Partition",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(Icons.add_circle_outline_outlined)
                          ],
                        ),
                        buttonwidth: MediaQuery.of(context).size.width),
                  )
                : Container(),
          ),
          Expanded(
            child: MenuFutureBuilder(
              errorRoutine: (data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report,
                        color: Colors.grey,
                        size: 150.0,
                      ),
                      Text(
                        "We encountered an error while retrieving your partitions.\n Please try again later.\n $data",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              failedRoutine: (data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: 150.0,
                      ),
                      Text(
                        widget.menuType == true
                            ? "You haven't made any partitions yet!\n Click 'Create A New Partition' to get started!"
                            : "You haven't made any partitions yet!",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              future: _future,
              refreshController: _refreshController,
              onrefresh: () {
                if (mounted) {
                  setState(() {
                    setfuture();
                  });
                  _future.whenComplete(
                      () => _refreshController.refreshCompleted());
                }
              },
              height: 400.0,
              dropdownValue: dropdownValue,
              searchController: search,
              spawner: spawnPartition,
              mainMenu: widget.menuType as bool,
            ),
          ),
        ]),
      ),
    );
  }
}
