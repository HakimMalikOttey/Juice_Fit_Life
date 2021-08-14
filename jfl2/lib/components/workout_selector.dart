import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';

class WorkoutSelector extends StatefulWidget{
  final selectorindex;
  WorkoutSelector({@required this.selectorindex});
  @override
  _WorkoutSelector createState () => _WorkoutSelector();
}

class _WorkoutSelector extends State<WorkoutSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainerWorkoutEditorData>(
        builder: (context,data,child){
          return ListView.builder(
            // itemCount: data.WorkoutSets.length,
            itemCount: 2,
              itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                      // Provider.of<TrainerDayMakerData>(context,listen: false).mapdata(widget.selectorindex, data.WorkoutSets[index]);
                  },
                  child: Material(
                    elevation: 2.0,
                    color: Colors.white70,
                    child: Row(
                      children: [
                        // Image.memory(data.WorkoutSets[index].thumbnail),
                        SizedBox(
                          width: 20.0,
                        ),
                        // Expanded(
                        //   // child: Text("${data.WorkoutSets[index].name.text}"),
                        // ),
                        // Expanded(
                        //     // child: Text("${data.WorkoutSets[index].reps.length} sets")
                        // ),
                      ],
                    ),
                  ),
                ),
              );
              });
        }
    );
  }
}