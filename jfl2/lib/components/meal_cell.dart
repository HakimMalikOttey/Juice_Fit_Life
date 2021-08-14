import 'package:flutter/cupertino.dart';
import 'package:jfl2/Screens/students/open_food_facts_load.dart';
import 'package:jfl2/Screens/students/plans_meals.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/day_meal_data.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class MealCell extends StatelessWidget {
  final String mealName;
  final String calories;
  final List<meal> meals;
  final int index;
  final Function addMeal;
  MealCell(
      {required this.mealName,
      required this.calories,
      required this.meals,
      required this.index,
      required this.addMeal});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$mealName",
                style: TextStyle(fontSize: 20.0),
              ),
              Text("$calories Calories", style: TextStyle(fontSize: 20.0)),
              SquareButton(
                  color: Colors.black,
                  pressed: addMeal,
                  butContent: Text(
                    "Add Meal",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  buttonwidth: 90.0,
                  height: 30.0,
                  padding: EdgeInsets.only(left: 0, top: 0)),
            ],
          ),
        ),
        Column(
          children: List.generate(meals.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10.0,
                            ),
                            Expanded(
                                flex: 2,
                                child: Text("${meals[index].name}",
                                    style:
                                        Theme.of(context).textTheme.headline1)),
                            Expanded(
                                child: Text("${meals[index].calories} Calories",
                                    style:
                                        Theme.of(context).textTheme.headline1))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
