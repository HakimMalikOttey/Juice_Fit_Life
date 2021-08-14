import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/goal_list.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/goal_data.dart';
import 'package:jfl2/data/goals.dart';
import 'package:jfl2/data/weight.dart';
import 'package:provider/provider.dart';


class AddGoalScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Consumer<GoalData>(
          builder: (context, taskData, child){
              return ListView.builder(
                  itemCount: taskData.goalCount,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: 600.0,
                                    height: 40.0,
                                    child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(taskData.goals[index]['Goal'], style: Theme.of(context).textTheme.headline2),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ));
                  });
          }
      );
  }
}
