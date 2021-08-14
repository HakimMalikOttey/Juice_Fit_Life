import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/goal_data.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:jfl2/data/goals.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/weight.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:provider/provider.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalList createState() => _GoalList();
}

class _GoalList extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentSignUpData>(
      builder: (context, data, child) {
        return ListView.builder(
            itemCount: Goals.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final item = index;
              return ListTile(
                  title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SquareButton(
                        color: Colors.white,
                        pressed: () {
                          print(item);
                          var object = null;
                          if (Goals[index]['Selected'] == false) {
                            Goals[index].update('Selected', (value) => true);
                            object = {
                              'Goal': Goals[index]['Goal'],
                              'Pointer': index
                            };
                            Provider.of<GoalData>(context, listen: false)
                                .addGoal(object);
                          } else {
                            Goals[index].update('Selected', (value) => false);
                            Provider.of<GoalData>(context, listen: false)
                                .findAndDeleteGoal((element) =>
                                    element['Goal'] == Goals[index]['Goal']);
                            // SelectedGoals.removeWhere((element) => element['Goal'] == Goals[index]['Goal']);
                          }
                          // data.goalList =
                          //     Provider.of<GoalData>(context, listen: false)
                          //         .goals;
                          print(data.goalList);
                        },
                        butContent: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Text(
                                  Goals[index]['Goal'],
                                  style: Theme.of(context).textTheme.headline2,
                                )),
                            Icon(
                                Goals[index]['Selected'] == false
                                    ? Icons.add
                                    : Icons.remove,
                                color: Theme.of(context).iconTheme.color)
                          ],
                        ),
                        buttonwidth: 50.0,
                        height: 40.0,
                        padding: EdgeInsets.only(left: 10.0, top: 0)),
                  ),
                ],
              ));
            });
      },
    );
  }
}
