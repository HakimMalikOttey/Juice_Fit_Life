import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/calorie_break_down.dart';
import 'package:jfl2/components/Calorie_Box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/meal_cell.dart';
import 'package:jfl2/data/day_meal_data.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import 'open_food_facts_load.dart';

class PlansMeals extends StatefulWidget {
  static String id = "PlansMeals";
  _PlansMeals createState() => _PlansMeals();
}

class _PlansMeals extends State<PlansMeals>
    with SingleTickerProviderStateMixin {
  var meals = 0;
  late TabController controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
        title: Text('Plans Information'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(
              child: Text("Meal Diary"),
            ),
            Tab(
              child: Text("Meal Expectations"),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: controller,
          children: [
            Consumer<dayMeals>(builder: (context, data, child) {
              return Column(
                children: [
                  Calorie_Box(
                    goal: 3000.0,
                    curCals: data.calculateDayCalories(),
                    excercise: 0.0,
                    totalCals: data.calculateGoalLeft(
                        data.calculateDayCalories(), 3000.0),
                    action: () {
                      Navigator.pushNamed(context, CalorieBreakDown.id);
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                          itemCount: Provider.of<dayMeals>(context)
                              .partsOfMealDay
                              .length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 24.0),
                              child: MealCell(
                                addMeal: () {
                                  data.index = index;
                                  Navigator.pushNamed(
                                      context, OpenFoodFactsLoad.id);
                                },
                                index: index,
                                calories:
                                    "${data.calculateCals(index).round()}",
                                mealName:
                                    "${data.partsOfMealDay[index].mealtype}",
                                meals: data.partsOfMealDay[index].meals as List<meal>,
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            }),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
