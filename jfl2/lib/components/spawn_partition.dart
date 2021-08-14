import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/components/partition_container.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'custom_alert_box.dart';
import 'loading_dialog.dart';

Widget spawnPartition(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr Function(Object?) reset) {
  return PartitionContainer(
    partitionId: elements["_id"],
    reset: reset,
    name: elements["name"],
    elements: elements,
    mainMenu: mainMenu,
  );
}
