import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalorieBoxCell extends StatelessWidget {
  final String calories;
  final String label;
  CalorieBoxCell({required this.calories, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Column(
        children: [
          Expanded(
            child: Text(
              "$calories",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(fontSize: 16.0),
            ),
          ),
          Text("$label", style: Theme.of(context).textTheme.headline1)
        ],
      ),
    );
  }
}
