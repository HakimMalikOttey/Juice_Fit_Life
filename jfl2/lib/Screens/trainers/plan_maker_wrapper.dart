import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jfl2/Screens/trainers/level_editor_launch.dart';
import 'package:jfl2/Screens/trainers/day_editor_launch.dart';
import 'package:jfl2/Screens/trainers/meal_plan_editor_launch.dart';
import 'package:jfl2/Screens/trainers/plan_editor_launch.dart';
import 'package:jfl2/Screens/trainers/partition_editor_launch.dart';
import 'package:jfl2/Screens/trainers/stretch_editor_launch.dart';
import 'package:jfl2/Screens/trainers/week_editor_launch.dart';
import 'package:jfl2/Screens/trainers/workout_editor_launch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jfl2/components/custom_page_route.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import '../../components/footer_button.dart';

class TrainerPlanMakerWrapper extends StatefulWidget {
  static String id = "TrainerPlanMakerWrapper";
  _TrainerPlanMakerWrapper createState() => _TrainerPlanMakerWrapper();
}

class _TrainerPlanMakerWrapper extends State<TrainerPlanMakerWrapper>
    with SingleTickerProviderStateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String settingsName = PlanEditorLaunch.id;
  double height = 45.0;
  Widget barrier = Container();
  late Widget _animatedModalBarrier;
  late AnimationController _animationController;
  late Animation<Color> _colorTweenAnimation;
  Color _selectbuttoncolor = Colors.pinkAccent;
  String _selectbuttontext = "Plan Maker";
  var _selectbuttonicon = FontAwesomeIcons.check;
  TextEditingController search = new TextEditingController();
  Map dropdownValue = filters[0];
  @override
  void initState() {
    // ColorTween _colorTween =
    //     ColorTween(begin: Colors.black38, end: Colors.black38);
    // _animationController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // _colorTweenAnimation = _colorTween.animate(_animationController) as Animation<Color>;
    // _animatedModalBarrier = AnimatedModalBarrier(
    //   color: _colorTweenAnimation,
    //   dismissible: true,
    // );
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   setState(() {
    //     _navigatorKey.currentState.pushReplacementNamed(PlanEditorLaunch.id,
    //         arguments: {"menuType": true});
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: <Widget>[],
      //   title: Text('Your Plans'),
      // ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable:
              Provider.of<UserData>(context, listen: false).BatchOperation,
          builder: (context, data, snapshot) {
            return data == false
                ? BottomAppBar(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FooterButton(
                          color: settingsName == PlanEditorLaunch.id
                              ? Colors.pinkAccent
                              : Theme.of(context).disabledColor,
                          text: Text("Plan Maker",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center),
                          action: () {
                            if (settingsName != PlanEditorLaunch.id) {
                              setState(() {
                                _navigatorKey.currentState?.pushReplacementNamed(
                                    PlanEditorLaunch.id,
                                    arguments: {"menuType": true});
                              });
                            }
                          },
                        ),
                        FooterButton(
                            color:
                                settingsName == TrainerPartitionEditorLaunch.id
                                    ? Colors.red
                                    : Theme.of(context).disabledColor,
                            text: Text("Partition Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {
                              if (settingsName !=
                                  TrainerPartitionEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(
                                          TrainerPartitionEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                        FooterButton(
                            color: settingsName == TrainerLevelEditorLaunch.id
                                ? Colors.blue
                                : Theme.of(context).disabledColor,
                            text: Text("Level Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {
                              if (settingsName != TrainerLevelEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(
                                          TrainerLevelEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                        FooterButton(
                            color: settingsName == TrainerWeekEditorLaunch.id
                                ? Colors.green
                                : Theme.of(context).disabledColor,
                            text: Text("Week Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {
                              if (settingsName != TrainerWeekEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(
                                          TrainerWeekEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                        FooterButton(
                            color: settingsName == DayEditorLaunch.id
                                ? Colors.purple
                                : Theme.of(context).disabledColor,
                            text: Text("Day Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {
                              if (settingsName != DayEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(DayEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                        FooterButton(
                            color: settingsName == WorkoutEditorLaunch.id
                                ? Colors.orange
                                : Theme.of(context).disabledColor,
                            text: Text(
                              "Workout Maker",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                            action: () {
                              if (settingsName != WorkoutEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(
                                          WorkoutEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                        FooterButton(
                            color: settingsName == MealPlanEditorLaunch.id
                                ? Colors.teal
                                : Theme.of(context).disabledColor,
                            text: Text("Meal Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {
                              if (settingsName != MealPlanEditorLaunch.id) {
                                setState(() {
                                  _navigatorKey.currentState
                                      ?.pushReplacementNamed(
                                          MealPlanEditorLaunch.id,
                                          arguments: {"menuType": true});
                                });
                              }
                            }),
                      ],
                    ),
                  ))
                : BottomAppBar(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FooterButton(
                          color: Theme.of(context).shadowColor,
                          text: Text("Plan Maker",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center),
                          action: () {},
                        ),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text("Partition Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text("Level Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text("Week Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text("Day Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text(
                              "Workout Maker",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text(
                              "Stretch Maker",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                            action: () {}),
                        FooterButton(
                            color: Theme.of(context).shadowColor,
                            text: Text("Meal Maker",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            action: () {}),
                      ],
                    ),
                  ));
          }),
      body: Column(
        children: [
          Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            child: Filter(
              submitAction: () {
                Provider.of<UserData>(context, listen: false).searchAction!();
              },
              value: Provider.of<UserData>(context, listen: false).sort,
              show: false,
              searchController: Provider.of<UserData>(context).search, queryAction: (Map<dynamic, dynamic>? data) {
            setState(() {
            Provider.of<UserData>(context, listen: false).sort = data as Map<String,dynamic>;
            Provider.of<UserData>(context, listen: false).searchAction!();
            });
            },

            ),
          ),
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              // initialRoute: PlanEditorLaunch.id,
              onGenerateRoute: (settings) {
                Map arguments ={};
                if(settings.arguments != null){
                  arguments = settings.arguments as Map;
                }

                settingsName =
                    (settings.name == "/" ? PlanEditorLaunch.id : settings.name)!;
                WidgetBuilder builder;
                if (settings.name == PlanEditorLaunch.id)
                  builder = (context) =>
                      PlanEditorLaunch(menuType: arguments["menuType"]);
                else if (settings.name == DayEditorLaunch.id)
                  builder = (context) => DayEditorLaunch(
                        menuType: arguments["menuType"],
                      );
                else if (settings.name == WorkoutEditorLaunch.id)
                  builder = (context) => WorkoutEditorLaunch(
                        menuType: arguments["menuType"],
                      );
                else if (settings.name == MealPlanEditorLaunch.id)
                  builder = (context) =>
                      MealPlanEditorLaunch(menuType: arguments["menuType"]);
                else if (settings.name == TrainerWeekEditorLaunch.id)
                  builder = (context) =>
                      TrainerWeekEditorLaunch(menuType: arguments["menuType"]);
                else if (settings.name == TrainerLevelEditorLaunch.id)
                  builder = (context) =>
                      TrainerLevelEditorLaunch(menuType: arguments["menuType"]);
                else if (settings.name == TrainerPartitionEditorLaunch.id)
                  builder = (context) => TrainerPartitionEditorLaunch(
                      menuType: arguments["menuType"]);
                else
                  builder = (context) => PlanEditorLaunch(menuType: true);
                Provider.of<UserData>(context, listen: false).encapsulatedNav =
                    settings.name;
                Provider.of<UserData>(context, listen: false).search.clear();
                Provider.of<UserData>(context, listen: false).sort = filters[0];
                return CustomPageRoute(builder: builder, settings: settings);
              },
            ),
          ),
        ],
      ),
    );
  }
}
