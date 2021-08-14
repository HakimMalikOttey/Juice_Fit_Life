import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'confirm_load.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';
import 'loading_indicator.dart';

Widget spawnWorkouts(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr Function(Object?) reset) {
  // List decodedworkout = json.decode(elements["workout"]);
  return WorkoutExampleCell(
    name: elements["name"],
    workoutId: elements["_id"],
    mainMenu: mainMenu,
    reset: reset,
  );
}
