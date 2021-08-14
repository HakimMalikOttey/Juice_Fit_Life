import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/level_editor_launch.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:provider/provider.dart';

import 'level_container.dart';
import 'mini_plan_view.dart';

class PartitionEditorLevel extends StatefulWidget {
  final bool active;
  PartitionEditorLevel({required this.active});
  @override
  _PartitionEditorLevelState createState() => _PartitionEditorLevelState();
}

class _PartitionEditorLevelState extends State<PartitionEditorLevel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: widget.active == true
              ? SquareButton(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.black,
                  pressed: () {
                    return showDialog(
                        context: context,
                        builder: (context) => MiniPlanView(
                            windowName: 'Select a Level',
                            dataWindow: TrainerLevelEditorLaunch(
                              menuType: false,
                            )));
                    // data.appendWorkout();
                  },
                  butContent: Text(
                    "Insert a Level",
                    style: TextStyle(color: Colors.white),
                  ),
                  buttonwidth: MediaQuery.of(context).size.width,
                  height: 50.0,
                )
              : Container(),
        ),
        Expanded(
          child: Consumer<TrainerPartitionEditorData>(
              builder: (context, data, child) {
            return ReorderableListView(
              scrollController: data.levelController,
              children: [
                for (int index = 0; index < data.Levels.length; index++)
                  Builder(
                      key: Key('$index'),
                      builder: (context) {
                        return Container(
                          child: LevelContainer(
                            view: widget.active,
                            elements: data.Levels[index],
                            mainMenu: false,
                            added: true,
                            name: data.Levels[index].name,
                            levelId: data.Levels[index].id,
                            reset: null,
                            index: index,
                          ),
                        );
                      })
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = data.Levels.removeAt(oldIndex);
                  data.Levels.insert(newIndex, item);
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
