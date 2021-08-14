import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/Screens/trainers/partition_editor_launch.dart';
import 'package:jfl2/components/partition_container.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:provider/provider.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'mini_plan_view.dart';

class PlanEditorPartitions extends StatefulWidget {
  final type;
  PlanEditorPartitions({@required this.type});
  @override
  _PlanEditorPartitionsState createState() => _PlanEditorPartitionsState();
}

class _PlanEditorPartitionsState extends State<PlanEditorPartitions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SquareButton(
          padding: EdgeInsets.only(top: 0),
          color: Colors.black,
          pressed: () {
            // showModalBottomSheet(
            //     isScrollControlled: true,
            //     context: context,
            //     builder: (context) => PartitionList());
            return showDialog(
                context: context,
                builder: (context) => MiniPlanView(
                      windowName: 'Select a Partition',
                      dataWindow: TrainerPartitionEditorLaunch(
                        menuType: false,
                      ),
                    ));
            // data.appendWorkout();
          },
          butContent: Text(
            "Insert a Partition",
            style: TextStyle(color: Colors.white),
          ),
          buttonwidth: MediaQuery.of(context).size.width,
          height: 50.0,
        ),
        Expanded(
          child: Consumer<PlanEditorData>(
            builder: (context, data, child) {
              return ReorderableListView(
                  children: [
                    for (int index = 0; index < data.Partitions.length; index++)
                      Builder(
                          key: Key('$index'),
                          builder: (context) {
                            return PartitionContainer(
                              added: true,
                              index: index,
                              reset: null,
                              name: data.Partitions[index].name,
                              partitionId: data.Partitions[index].id,
                              elements: "",
                              mainMenu: false,
                            );
                          })
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = data.Partitions.removeAt(oldIndex);
                      data.Partitions.insert(newIndex, item);
                    });
                  });
            },
          ),
        ),
      ],
    );
  }
}
