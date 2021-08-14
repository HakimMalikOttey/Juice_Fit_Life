import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/components/meal_container.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'loading_dialog.dart';

Widget spawnmeal(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr<dynamic> Function(Object?) reset) {
  return Consumer<UserData>(builder: (context, data, child) {
    return MealContainer(
      reset: reset,
      elements: elements,
      mainMenu: mainMenu,
    );
  });
}
