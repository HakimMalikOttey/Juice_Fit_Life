import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/components/workout_type_selector_cell.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';

class WorkoutTypeSelector extends StatefulWidget{
  static String id = "WorkoutTypeSelector";
  _WorkoutTypeSelector createState() => _WorkoutTypeSelector();
}

class _WorkoutTypeSelector extends State<WorkoutTypeSelector> {
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
        title: Text('Workout Maker'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            WorkoutTypeSelectorCell(
                title: "Straight Sets",
                description: "The old fashioned way. You take rest in between sets",
                ontap: (){
                  Navigator.pushNamed(context, TrainerWorkoutMakerStraight.id);
                }),
            WorkoutTypeSelectorCell(
                title: "Super Sets",
                description: "You go from one excercise set to another excercise set without a break.",
                ontap: (){
                  Navigator.pushNamed(context, TrainerWorkoutMakerStraight.id);
                }),
            WorkoutTypeSelectorCell(
                title: "Circuit Sets",
                description: "The old fashioned way. You take rest inbetween sets",
                ontap: (){
                  Navigator.pushNamed(context, TrainerWorkoutMakerStraight.id);
                }),
            WorkoutTypeSelectorCell(
                title: "Pyramid Set",
                description: "The old fashioned way. You take rest inbetween sets",
                ontap: (){
                  Navigator.pushNamed(context, TrainerWorkoutMakerStraight.id);
                }),
            WorkoutTypeSelectorCell(
                title: "Drop Set",
                description: "The old fashioned way. You take rest inbetween sets",
                ontap: (){
                  Navigator.pushNamed(context, TrainerWorkoutMakerStraight.id);
                }),
          ],
        ),
      ),
    );
  }
}