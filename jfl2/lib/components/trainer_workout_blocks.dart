import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/rest_container.dart';
import 'package:jfl2/components/set_container.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/sets_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';

class TrainerWorkoutBlocks extends StatefulWidget {
  final int type;
  TrainerWorkoutBlocks({ required this.type});
  @override
  _TrainerWorkoutBlocksState createState() => _TrainerWorkoutBlocksState();
}

class _TrainerWorkoutBlocksState extends State<TrainerWorkoutBlocks> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainerWorkoutEditorData>(builder: (context, data, child) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: widget.type == 2
                ? Container()
                : Row(
                    children: [
                      Expanded(
                        child: SquareButton(
                          padding: EdgeInsets.only(top: 0),
                          color: Colors.black,
                          pressed: () {
                            data.appendWorkout(0);
                          },
                          butContent: Text(
                            "Create New Set",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonwidth: MediaQuery.of(context).size.width,
                          height: 50.0,
                        ),
                      ),
                      Expanded(
                        child: SquareButton(
                          padding: EdgeInsets.only(top: 0),
                          color: Colors.white,
                          pressed: () {
                            // setState(() {
                            data.appendWorkout(1);
                            // });
                          },
                          butContent: Text(
                            "Create New Rest Timer",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          buttonwidth: MediaQuery.of(context).size.width,
                          height: 50.0,
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: Container(
              child: ReorderableListView(
                children: <Widget>[
                  for (int index = 0;
                      index < data.SetsList.length;
                      index++)
                    Padding(
                      key: Key('$index'),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Builder(builder: (context) {
                        if (data.SetsList[index].type ==
                            SetsData.workoutTypeList[0]) {
                          int test = 0;
                          for (int i = 0; i <= index; i++) {
                            if (data.SetsList[i].type ==
                                SetsData.workoutTypeList[0]) {
                              test++;
                            }
                          }
                          return SetContainer(
                            timeType: data.SetsList[index].timeType as String,
                            timeTypeList: SetsData.timeTypeList,
                            changeTimeType: data.changeTimeType,
                            time: data.SetsList[index].timeCieling as TextEditingController,
                            changeRepType: data.changeRepType,
                            index: index,
                            repTypeList: SetsData.repTypeList,
                            repType: data.SetsList[index].reptype as String,
                            setnumber: test,
                            active: widget.type != 2 ? true : false,
                            rep: data.SetsList[index].reps as TextEditingController,
                            delete: () {
                              data.removeSegment(index);
                              // setState(() {
                              //   data.SetsList.removeAt(index);
                              // });
                            },
                            pound: data.SetsList[index].pounds as TextEditingController,
                          );
                        } else {
                          return RestContainer(
                              index: index,
                              timeTypeList: SetsData.timeTypeList,
                              timeType: data.SetsList[index].timeType as String,
                              changeTimeType: data.changeTimeType,
                              active: widget.type != 2 ? true : false,
                              controller: data.SetsList[index].timeCieling as TextEditingController,
                              delete: () {
                                data.removeSegment(index);
                              });
                        }
                      }),
                    )
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = data.SetsList.removeAt(oldIndex);
                    data.SetsList.insert(newIndex, item);
                    print(data.SetsList);
                  });
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
