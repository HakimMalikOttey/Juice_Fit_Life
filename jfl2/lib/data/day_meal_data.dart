import 'package:flutter/material.dart';

class meal {
  String name;
  double calories;
  double cholesteral;
  double protien;
  double sodium;
  double tranFat;
  double totalCarbs;
  double totalSugar;
  double dietFiber;
  double satFat;
  meal(
      {required this.name,
      required this.calories,
      required this.cholesteral,
      required this.dietFiber,
      required this.protien,
      required this.satFat,
      required this.sodium,
      required this.totalCarbs,
      required this.totalSugar,
      required this.tranFat});
}

class day {
  String mealtype;
  List<meal>? meals;
  day({required this.mealtype, this.meals});
}

class dayMeals extends ChangeNotifier {
  List<day> partsOfMealDay = [
    new day(mealtype: "Breakfast", meals: []),
    new day(mealtype: "Lunch", meals: []),
    new day(mealtype: "Dinner", meals: []),
    new day(mealtype: "Snack", meals: []),
  ];
  int? index;
  double calculateCals(int index) {
    double calories = 0;
    partsOfMealDay[index].meals?.forEach((element) {
      calories = calories + element.calories;
    });
    return calories;
  }

  double calculateDayCalories() {
    double calories = 0;
    partsOfMealDay.forEach((element) {
      element.meals?.forEach((element) {
        calories = calories + element.calories;
      });
    });
    return calories;
  }

  double calculateGoalLeft(double amount, double goal) {
    return goal - amount;
  }

  pushMeal(meal meal) {
    partsOfMealDay[index as int].meals?.add(meal);
    notifyListeners();
  }
}
