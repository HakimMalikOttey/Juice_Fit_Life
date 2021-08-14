import 'package:flutter/material.dart';
import 'package:jfl2/components/calorie_box_cell.dart';

class Calorie_Box extends StatelessWidget {
  final double goal;
  final double curCals;
  final double excercise;
  final double totalCals;
  final action;
  Calorie_Box(
      {required this.action,
      required this.curCals,
      required this.excercise,
      required this.totalCals,
      required this.goal});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CalorieBoxCell(
              calories: "$goal",
              label: "Goal",
            ),
          ),
          Icon(
            Icons.remove,
            color: Colors.white,
          ),
          Expanded(
            child: CalorieBoxCell(
              calories: "$curCals",
              label: "Cals",
            ),
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Expanded(
            child: CalorieBoxCell(
              calories: "$excercise",
              label: "Excercise",
            ),
          ),
          Text(
            "=",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          Expanded(
            child: CalorieBoxCell(
              calories: "$totalCals",
              label: "Total",
            ),
          ),
        ],
      ),
    );
  }
}
