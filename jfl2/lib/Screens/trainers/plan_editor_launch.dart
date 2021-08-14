import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_stack_scaffold.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/components/plan_banner.dart';
import 'package:jfl2/components/plans_custom_listview.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/spawn_plans.dart';
import 'package:jfl2/components/spawn_week.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlanEditorLaunch extends StatefulWidget {
  static String id = "PlanEditorLaunch";
  final bool? menuType;
  PlanEditorLaunch({@required this.menuType});
  _PlanEditorLaunch createState() => _PlanEditorLaunch();
}

class _PlanEditorLaunch extends State<PlanEditorLaunch> {
  TextEditingController search = new TextEditingController();
  Map dropdownValue = filters[2];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
   Future _future = Future.value(null);
  var time;
  late Timer clock;
  void setFuture() {
    setState(() {
      _future = Provider.of<PlanEditorData>(context, listen: false)
          .getPlan(Provider.of<UserData>(context, listen: false).id as String, {
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
        child: Column(children: [
          Container(
            child: widget.menuType == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SquareButton(
                        color: Colors.black,
                        pressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(TrainerPlanEditor.id, arguments: {
                            "type": 1,
                            "name": "",
                            "explanation": "",
                            "planId": "",
                            "banner": "",
                            "partitions": [],
                            "hook": ""
                          }).then(popRefresh);
                        },
                        butContent: Row(
                          children: [
                            Text(
                              "Create A New Plan",
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
                          "We encountered an error while retrieving your plans.\n Please try again later.\n $data",
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
                              ? "You haven't made any plans yet!\n Click 'Create A New Plan' to get started!"
                              : "You haven't made any plans yet!",
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
                  setState(() {
                    setFuture();
                  });
                  _future.whenComplete(
                      () => _refreshController.refreshCompleted());
                },
                future: _future,
                dropdownValue: dropdownValue,
                searchController: search,
                spawner: spawnPlan,
                mainMenu: widget.menuType as bool),
          )
        ]),
      ),
    );
  }
}
