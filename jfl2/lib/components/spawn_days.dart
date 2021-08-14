import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/components/action_buttons.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/days_container.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:provider/provider.dart';

Widget spawndays(dynamic elements, BuildContext context, bool mainMenu,
    int index,  FutureOr<dynamic> Function(Object?) reset) {
  // final List dayelements = elements["day"];
  return DaysContainer(
    name: elements["name"],
    dayId: elements["_id"],
    elements: elements,
    mainMenu: mainMenu,
    reset: reset,
  );
}
