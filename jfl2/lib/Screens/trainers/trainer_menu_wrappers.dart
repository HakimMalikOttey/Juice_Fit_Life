import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/general_sign_up.dart';
import 'package:jfl2/Screens/trainers/day_editor_launch.dart';
import 'package:jfl2/Screens/trainers/level_editor_launch.dart';
import 'package:jfl2/Screens/trainers/meal_plan_editor_launch.dart';
import 'package:jfl2/Screens/trainers/partition_editor_launch.dart';
import 'package:jfl2/Screens/trainers/plan_editor_launch.dart';
import 'package:jfl2/Screens/trainers/plan_maker_wrapper.dart';
import 'package:jfl2/Screens/trainers/stretch_editor_launch.dart';
import 'package:jfl2/Screens/trainers/trainer_settings.dart';
import 'package:jfl2/Screens/trainers/trainer_your_clients.dart';
import 'package:jfl2/Screens/trainers/trainer_your_sessions.dart';
import 'package:jfl2/Screens/trainers/week_editor_launch.dart';
import 'package:jfl2/Screens/trainers/workout_editor_launch.dart';
import 'package:jfl2/components/confirm_load.dart';
import 'package:jfl2/components/custom_page_route.dart';
import 'package:jfl2/components/double_value_listanable.dart';
import 'package:jfl2/components/meal_copy.dart';
import 'package:jfl2/components/batch_delete.dart';
import 'package:jfl2/components/trainer_drawer.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'Trainer_Main_Menu.dart';

class TrainerMenuWrapper extends StatefulWidget {
  static String id = "TrainerMenuWrapper";
  @override
  _TrainerMenuWrapperState createState() => _TrainerMenuWrapperState();
}

class _TrainerMenuWrapperState extends State<TrainerMenuWrapper> {
  ValueNotifier<String> settingsName =
      ValueNotifier<String>(TrainerMainMenu.id);
  final _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List batchId = [];
  bool startBatch = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: ValueListenableBuilder(
            valueListenable: Provider.of<UserData>(context).BatchOperation,
            builder: (context, data, child) {
              return data == true
                  ? Container()
                  : TrainerDrawer(
                      navigatorKey: _navigatorKey,
                      scaffoldKey: _scaffoldKey,
                    );
            }),
        appBar: AppBar(
            leading: ValueListenableBuilder(
                valueListenable: Provider.of<UserData>(context).BatchOperation,
                builder: (context, data, child) {
                  return data == true
                      ? IconButton(
                          icon: Icon(Icons.clear_outlined),
                          onPressed: () {
                            setState(() {
                              Provider.of<UserData>(context, listen: false)
                                  .QueryIds
                                  .value
                                  .clear();
                              Provider.of<UserData>(context, listen: false)
                                  .QueryIdsLength
                                  .value = false;
                              Provider.of<UserData>(context, listen: false)
                                  .BatchOperation
                                  .value = false;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        );
                }),
            actions: [
              DoubleValueListenable(
                  first: Provider.of<UserData>(context).BatchOperation,
                  second: Provider.of<UserData>(context).QueryIdsLength,
                  child: Container(),
                  builder: (context, first, second, child) {
                    return first == true
                        ? Container(
                            child: second == true
                                ? PopupMenuButton(
                                    onSelected: (item) => BatchQuery(item as int),
                                    color: Theme.of(context).shadowColor,
                                    itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                              // enabled: Provider.of<UserData>(context,
                                              //         listen: false)
                                              //     .QueryIds
                                              //     .isNotEmpty,
                                              value: 0,
                                              child: Text("Delete")),
                                          PopupMenuItem<int>(
                                              // enabled: Provider.of<UserData>(context,
                                              //         listen: false)
                                              //     .QueryIds
                                              //     .isNotEmpty,
                                              value: 1,
                                              child: Text("Copy"))
                                        ])
                                : IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    )),
                          )
                        : Container();
                  }),
            ],
            // Provider.of<UserData>(context, listen: true).batchOperation ==
            //         true
            //     ? [
            //         IconButton(
            //           icon: Icon(Icons.more_vert),
            //           onPressed: () {},
            //         ),
            //       ]
            //     : [],
            title: ValueListenableBuilder<String>(
              valueListenable: settingsName,
              builder: (context, String value, _) {
                if (value == TrainerMainMenu.id) {
                  return Text("Main Menu");
                } else if (value == TrainerPlanMakerWrapper.id) {
                  return Text("Plan Maker");
                } else if (value == TrainerYourClients.id) {
                  return Text("Your Clients");
                } else if (value == TrainerYourSessions.id) {
                  return Text("Your Sessions");
                } else {
                  return Text("Main Menu");
                }
              },
            )),
        body: Stack(
          children: [
            Navigator(
              key: _navigatorKey,
              initialRoute: TrainerMainMenu.id,
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                Map arguments;
                if(settings.arguments != null){
                  arguments = settings.arguments as Map;
                }

                if (settings.name == TrainerMainMenu.id)
                  builder = (context) => TrainerMainMenu();
                else if (settings.name == TrainerPlanMakerWrapper.id)
                  builder = (context) => TrainerPlanMakerWrapper();
                else if (settings.name == TrainerYourClients.id)
                  builder = (context) => TrainerYourClients();
                else if (settings.name == TrainerYourSessions.id)
                  builder = (context) => TrainerYourSessions();
                else if (settings.name == TrainerSettings.id)
                  builder = (context) => TrainerSettings();
                else
                  builder = (context) => TrainerMainMenu();
                return CustomPageRoute(builder: builder, settings: settings);
              },
            )
          ],
        ),
      ),
    );
  }

  void BatchSelect(String id, bool checkboxActive) {
    startBatch = true;
    batchId.add(id);
    checkboxActive = true;
  }

  Future BatchQuery(int query) {
    print(query);
    final List batch =
        Provider.of<UserData>(context, listen: false).QueryIds.value;
    final String screenName =
        Provider.of<UserData>(context, listen: false).encapsulatedNav as String;
    if (query == 0) {
      if (screenName == MealPlanEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} meals. Are you sure?",
                confirm: () {
                  // mealIds: batch
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your meals. Please try again later.",
                            deleteRequest: Provider.of<MealPlanMakerData>(
                                    context,
                                    listen: false)
                                .deleteMeal(Provider.of<UserData>(context).id as String,
                                    {'mealIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your meals. Please try again later",
                            successMessage:
                                "Meals have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == WorkoutEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} workouts. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your workouts. Please try again later.",
                            deleteRequest:
                                Provider.of<TrainerWorkoutEditorData>(context,
                                        listen: false)
                                    .deleteworkout(
                                        Provider.of<UserData>(context).id as String,
                                        {'workoutIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your workouts. Please try again later",
                            successMessage:
                                "workouts have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == DayEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} days. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your days. Please try again later.",
                            deleteRequest: Provider.of<TrainerDayMakerData>(
                                    context,
                                    listen: false)
                                .deleteDay(Provider.of<UserData>(context).id as String,
                                    {'dayIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your days. Please try again later",
                            successMessage:
                                "Days have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerWeekEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} weeks. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your week. Please try again later.",
                            deleteRequest: Provider.of<TrainerWeekEditorData>(
                                    context,
                                    listen: false)
                                .deleteWeek(Provider.of<UserData>(context).id as String,
                                    {'weekIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your week. Please try again later",
                            successMessage:
                                "Week have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerLevelEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} levels. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your levels. Please try again later.",
                            deleteRequest: Provider.of<TrainerLevelEditorData>(
                                    context,
                                    listen: false)
                                .deleteLevel(Provider.of<UserData>(context).id as String,
                                    {'levelIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your levels. Please try again later",
                            successMessage:
                                "Levels have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerPartitionEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} partitions. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your partitions. Please try again later.",
                            deleteRequest:
                                Provider.of<TrainerPartitionEditorData>(context,
                                        listen: false)
                                    .deletePartition(
                                        Provider.of<UserData>(context).id as String,
                                        {'partitionIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your partitions. Please try again later",
                            successMessage:
                                "Partitions have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == PlanEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Deleting ${batch.length} plans. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in deleting your plans. Please try again later.",
                            deleteRequest: Provider.of<PlanEditorData>(context,
                                    listen: false)
                                .deletePlan(Provider.of<UserData>(context).id as String,
                                    {'workoutIDs': batch}),
                            failedMessage:
                                "There was an error in deleting your plans. Please try again later",
                            successMessage:
                                "Plans have been sucessfully deleted",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else {
        return Future.value(false);
      }
      //Batch Copying Logic
    } else {
      if (screenName == MealPlanEditorLaunch.id) {
        // return showDialog(
        //     context: context,
        //     builder: (context) => ConfirmLoad(
        //         request: "Duplicating ${batch.length} meals. Are you sure?",
        //         confirm: () {
        //           showDialog(
        //               barrierDismissible: false,
        //               context: context,
        //               builder: (BuildContext context) =>
        //                   MealCopy(mealIds: batch));
        //         },
        //         deny: () {
        //           Navigator.of(context, rootNavigator: true).pop(true);
        //         }));
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} meals. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your meals. Please try again later.",
                            deleteRequest: Provider.of<MealPlanMakerData>(
                                    context,
                                    listen: false)
                                .copyMeal(Provider.of<UserData>(context).id as String,
                                    {'mealIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your meals. Please try again later.",
                            successMessage:
                                "Meals have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == WorkoutEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} workouts. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your workouts. Please try again later.",
                            deleteRequest:
                                Provider.of<TrainerWorkoutEditorData>(context,
                                        listen: false)
                                    .copyWorkout(
                                        Provider.of<UserData>(context).id as String,
                                        {'workoutIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your workouts. Please try again later.",
                            successMessage:
                                "Workouts have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == DayEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} days. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your days. Please try again later.",
                            deleteRequest: Provider.of<TrainerDayMakerData>(
                                    context,
                                    listen: false)
                                .copyDay(Provider.of<UserData>(context).id as String,
                                    {'dayIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your days. Please try again later.",
                            successMessage:
                                "Days have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerWeekEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} weeks. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your weeks. Please try again later.",
                            deleteRequest: Provider.of<TrainerWeekEditorData>(
                                    context,
                                    listen: false)
                                .copyWeek(Provider.of<UserData>(context).id as String,
                                    {'weekIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your weeks. Please try again later.",
                            successMessage:
                                "Weeks have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerLevelEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} levels. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your levels. Please try again later.",
                            deleteRequest: Provider.of<TrainerWeekEditorData>(
                                    context,
                                    listen: false)
                                .copyWeek(Provider.of<UserData>(context).id as String,
                                    {'levelIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your weeks. Please try again later.",
                            successMessage:
                                "Weeks have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == TrainerPartitionEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request:
                    "Duplicating ${batch.length} partitions. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your partitions. Please try again later.",
                            deleteRequest:
                                Provider.of<TrainerPartitionEditorData>(context,
                                        listen: false)
                                    .copyPartition(
                                        Provider.of<UserData>(context).id as String,
                                        {'workoutIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your partitions. Please try again later.",
                            successMessage:
                                "Partitions have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else if (screenName == PlanEditorLaunch.id) {
        return showDialog(
            context: context,
            builder: (context) => ConfirmLoad(
                request: "Duplicating ${batch.length} plans. Are you sure?",
                confirm: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => BatchDelete(
                            errorMessage:
                                "There was a major error in duplicating your plans. Please try again later.",
                            deleteRequest: Provider.of<PlanEditorData>(context,
                                    listen: false)
                                .copyPlan(Provider.of<UserData>(context).id as String,
                                    {'planIDs': batch}),
                            failedMessage:
                                "There was an error in duplicating your plans. Please try again later.",
                            successMessage:
                                "Plans have been sucessfully duplicated.",
                          ));
                },
                deny: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }));
      } else {
        return Future.value(false);
      }
    }
  }
}
