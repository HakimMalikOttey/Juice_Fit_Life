import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_stack_scaffold.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/spawn_meal.dart';
import 'package:jfl2/components/plan_banner.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/plans_custom_listview.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:jfl2/components/meal_listview.dart';
import 'package:jfl2/components/menu_future_builder.dart';

class MealPlanEditorLaunch extends StatefulWidget {
  static String id = "MealPlanEditorLaunch";
  final bool? menuType;
  MealPlanEditorLaunch({@required this.menuType});
  _MealPlanEditorLaunch createState() => _MealPlanEditorLaunch();
}

class _MealPlanEditorLaunch extends State<MealPlanEditorLaunch> {
  GlobalKey _textGlobalKey = new GlobalKey();
  TextEditingController search = new TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var time;
  late Timer clock;
  //Allows for the user to sort the data delivered to them based on certain rules
  Map dropdownValue = filters[0];
  Future _future = Future.value(null);
  // ZefyrController _mealController;
  // FocusNode _mealFocusNode;
  late ScrollController _scrollController;
  void setfuture() {
    setState(() {
      _future = Provider.of<MealPlanMakerData>(context, listen: false)
          .getMeal(Provider.of<UserData>(context, listen: false).id as String, {
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
    if (widget.menuType == true) {
      Provider.of<UserData>(context, listen: false).searchAction = setfuture;
    } else {
      Provider.of<UserData>(context, listen: false).miniSearchAction =
          setfuture;
    }
    // setfuture();
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
            // Filter(
            //   submitAction: () {
            //     setState(() {
            //       setfuture();
            //     });
            //     _future
            //         .whenComplete(() => _refreshController.refreshCompleted());
            //   },
            //   value: dropdownValue,
            //   show: false,
            //   searchController: search,
            //   queryAction: (Map newValue) {
            //     setState(() {
            //       dropdownValue = newValue;
            //       setfuture();
            //     });
            //     _future
            //         .whenComplete(() => _refreshController.refreshCompleted());
            //   },
            // ),
            Container(
              child: widget.menuType == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerMealPlanMaker.id, arguments: {
                              "title": "",
                              "mealid": "",
                              "mealPlan": "",
                              "type": 1
                            }).then(popRefresh);
                          },
                          butContent: Row(
                            children: [

                              Text(
                                "Create New Meal Plan",
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
              child: ListView(
                children: [
                  MenuFutureBuilder(
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
                              "We encountered an error while retrieving your meals.\n Please try again later.\n $data",
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
                                  ? "You haven't made any meal plans yet!\n Click 'Create New Meal Plans' to get started!"
                                  : "You haven't made any meal plans yet!",
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
                      setState(() {
                        setfuture();
                      });
                      _future.whenComplete(
                          () => _refreshController.refreshCompleted());
                    },
                    height: 400.0,
                    dropdownValue: dropdownValue,
                    searchController: search,
                    spawner: spawnmeal,
                    mainMenu: widget.menuType as bool,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // MealPlanCell()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
