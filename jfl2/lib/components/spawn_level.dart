import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/level_editor.dart';
import 'package:jfl2/components/level_container.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

Widget spawnLevel(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr<dynamic> Function(Object?) reset) {
  print(elements["name"]);
  return LevelContainer(
    levelId: elements["_id"],
    name: elements["name"],
    reset: reset,
    elements: elements,
    mainMenu: mainMenu,
    other: Container(),
  );
}
