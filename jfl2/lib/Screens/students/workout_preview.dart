import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/workout_start.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/workout_example_cell.dart';
class WorkoutPreview extends StatefulWidget {
  static String id = "Workout";

  _Workout createState() => _Workout();
}

class _Workout extends State<WorkoutPreview> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5DDDD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
        backgroundColor: Color(0xff32416F),
        title: Text('Workout'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  // WorkoutExampleCell(
                  //  path: "assets/Coco.mp4",
                  //   sets: 3,
                  //   workoutname: "Workout test",
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // WorkoutExampleCell(
                  //   path: "assets/Coco.mp4",
                  //   sets: 3,
                  //   workoutname: "Workout test",
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            FooterButton(
              color: Colors.green,
              text: Text("Start Workout",
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              action: () {
                Navigator.pushNamed(context, WorkoutStart.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
