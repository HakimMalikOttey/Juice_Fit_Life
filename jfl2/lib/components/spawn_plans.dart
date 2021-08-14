import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jfl2/components/plans_container.dart';

Widget spawnPlan(dynamic elements, BuildContext context, bool mainMenu,
    int index, FutureOr Function(Object?) reset) {
  log(elements.toString());
  return GestureDetector(
      onTap: () {
        // if(mainMenu == false){
        //   Provider.of<PlanEditorData>(context,listen: false).appendPartition(elements);
        //   Navigator.pop(context);
        // }
      },
      child: PlansContainer(
        name: elements["name"],
        reset: reset,
        weekId: elements["_id"],
        elements: elements,
        mainMenu: true,
        other: Container(),
      )
      // child: PartitionContainer(
      //   elements: elements,
      //   mainMenu: mainMenu,
      // ),
      );
}
