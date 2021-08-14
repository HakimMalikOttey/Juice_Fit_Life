import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_stack_scaffold.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/plans_custom_listview.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/spawn_workout.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/components/workout_listview.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WorkoutEditorLaunch extends StatefulWidget {
  static String id = "WorkoutEditorLaunch";
  final bool? menuType;
  WorkoutEditorLaunch({@required this.menuType});
  _WorkoutEditorLaunch createState() => _WorkoutEditorLaunch();
}

class _WorkoutEditorLaunch extends State<WorkoutEditorLaunch> {
  TextEditingController search = new TextEditingController();
  var time;
  late Timer clock;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future _future = Future.value(null);
  String dropdownValue = 'Earliest';
  void setfuture() {
    setState(() {
      _future = Provider.of<TrainerWorkoutEditorData>(context, listen: false)
          .getworkouts(Provider.of<UserData>(context, listen: false).id as String, {
        'sort':
            '${Provider.of<UserData>(context, listen: false).sort["query"]}',
        'name':
            '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
      });
    });
  }

  FutureOr popRefresh(data) {
    setfuture();
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
    // _future = Provider.of<TrainerWorkoutEditorData>(context, listen: false)
    //     .getworkouts(Provider.of<UserData>(context, listen: false).id, {
    //   'sort': '${Provider.of<UserData>(context, listen: false).sort["query"]}',
    //   'name':
    //       '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
    // });
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
        child: Column(
          children: [
            Container(
              child: widget.menuType == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerWorkoutMakerStraight.id,
                                    arguments: {
                                  "workoutid": "",
                                  "name": "",
                                  "media": [],
                                  "workout": [],
                                  "type": 1
                                }).then(popRefresh);
                          },
                          butContent: Row(
                            children: [
                              Text(
                                "Create New Workout",
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
                          "We encountered an error while retrieving your workouts.\n Please try again later.\n $data",
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
                              ? "You haven't made any workouts yet!\n Click 'Create New Workout' to get started!"
                              : "You haven't made any workouts yet!",
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
                height: 400.0,
                onrefresh: () {
                  if (mounted) {
                    setState(() {
                      _future = Provider.of<TrainerWorkoutEditorData>(context,
                              listen: false)
                          .getworkouts(
                              Provider.of<UserData>(context, listen: false).id as String,
                              {
                            'sort':
                                '${Provider.of<UserData>(context, listen: false).sort["query"]}',
                            'name':
                                '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
                          });
                    });
                    _future.whenComplete(
                        () => _refreshController.refreshCompleted());
                  }
                },
                dropdownValue: dropdownValue,
                searchController: search,
                spawner: spawnWorkouts,
                mainMenu: widget.menuType as bool,
              ),
            )
          ],
        ),
      ),
    );
  }
}
