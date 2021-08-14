import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/week_editor.dart';
import 'package:jfl2/components/week_container.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

Widget spawnweek(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr Function(Object?) reset) {
  print(elements);
  return WeekContainer(
      elements: elements,
      mainMenu: mainMenu,
      weekId: elements["_id"],
      reset: reset,
      name: elements["name"]);
}
