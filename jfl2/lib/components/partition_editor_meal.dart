import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/meal_plan_editor_launch.dart';
import 'package:jfl2/components/meal_container.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'mini_plan_view.dart';

class PartitionEditorMeal extends StatefulWidget {
  final bool active;
  PartitionEditorMeal({required this.active});
  @override
  _PartitionEditorMealState createState() => _PartitionEditorMealState();
}

class _PartitionEditorMealState extends State<PartitionEditorMeal> {
  @override
  void initState() {
    Provider.of<UserData>(context, listen: false).BatchOperation.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer<TrainerPartitionEditorData>(builder: (context, data, child) {
          if (data.meal == null) {
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => MiniPlanView(
                        windowName: 'Select a Meal Plan',
                        dataWindow: MealPlanEditorLaunch(
                          menuType: false,
                        )));
                // showModalBottomSheet(
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (context) => MealList());
              },
              child: Container(
                height: 110.0,
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.purple)),
                child: Column(
                  children: [
                    Expanded(
                        child: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                      size: 35.0,
                    )),
                    Expanded(
                        child: Text(
                      "Insert a Meal Plan",
                      style: Theme.of(context).textTheme.headline1,
                      softWrap: true,
                    ))
                  ],
                ),
              ),
            );
          } else {
            return MealContainer(
              elements: data.meal!.element,
              mainMenu: false,
              reset: null,
              added: true,
              view: widget.active,
            );
          }
        })
      ],
    );
  }
}
