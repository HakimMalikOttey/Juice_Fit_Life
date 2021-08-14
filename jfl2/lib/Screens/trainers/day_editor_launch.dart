import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/add_button.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/plan_banner.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/week_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/spawn_days.dart';

class DayEditorLaunch extends StatefulWidget {
  static String id = "DayEditorLaunch";
  final bool? menuType;
  DayEditorLaunch({@required this.menuType});
  _DayEditorLaunch createState() => _DayEditorLaunch();
}

class _DayEditorLaunch extends State<DayEditorLaunch> {
  var time;
  late Timer clock;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController search = new TextEditingController();
  Map dropdownValue = filters[2];
  Future _future = Future.value(null);
  void setFuture() {
    setState(() {
      _future = Provider.of<TrainerDayMakerData>(context, listen: false)
          .getDay(Provider.of<UserData>(context, listen: false).id as String, {
        'sort':
            '${Provider.of<UserData>(context, listen: false).sort["query"]}',
        'name':
            '${Provider.of<UserData>(context, listen: false).search.text.trim()}'
      });
    });
  }

  FutureOr popRefresh(data) {
    setFuture();
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
          setFuture();
          _future.whenComplete(() => _refreshController.refreshCompleted());
        });
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setFuture();
    });
    if (widget.menuType == true) {
      Provider.of<UserData>(context, listen: false).searchAction = setFuture;
    } else {
      Provider.of<UserData>(context, listen: false).miniSearchAction =
          setFuture;
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
                              .pushNamed(TrainerDayMaker.id, arguments: {
                            "parts": [],
                            "dayId": "",
                            "name": "",
                            "type": 1
                          }).then(popRefresh);
                        },
                        butContent: Row(
                          children: [
                            Text(
                              "Create A New Day",
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
          Container(
            child: widget.menuType == false
                ? GestureDetector(
                    onTap: () {
                      Provider.of<TrainerWeekEditorData>(context, listen: false)
                          .addElement(
                              Provider.of<TrainerWeekEditorData>(context,
                                      listen: false)
                                  .currentIndex as int,
                              "",
                              "",
                              [],
                              DayData.dayType[1]);
                      Navigator.pop(context);
                      // Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Make It A Rest Day",
                                style: Theme.of(context).textTheme.headline6),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.add_circle_outline_outlined,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          SizedBox(
            height: widget.menuType == false ? 10.0 : 0.0,
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
                          "We encountered an error while retrieving your days.\n Please try again later.\n $data",
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
                              ? "You haven't made any days yet!\n Click 'Create New Day' to get started!"
                              : "You haven't made any days yet!",
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
                height: 400.0,
                refreshController: _refreshController,
                onrefresh: () {
                  if (mounted) {
                    setState(() {
                      _future = Provider.of<TrainerDayMakerData>(context,
                              listen: false)
                          .getDay(
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
                future: _future,
                dropdownValue: dropdownValue,
                searchController: search,
                spawner: spawndays,
                mainMenu: widget.menuType as bool),
          ),
        ],
      ),
    ));
  }
}
