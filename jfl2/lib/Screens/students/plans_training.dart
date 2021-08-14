import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/schedule_session_time.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/square_button.dart';

class PlansTraining extends StatefulWidget{
  static String id = "PlansTraining";
  _PlansTraining createState() => _PlansTraining();
}

class _PlansTraining extends State<PlansTraining> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
        title: Text('Plans Information'),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 30.0,
              ),
              SquareButton(
                  color: Color(0xff29DE11),
                  pressed: () {
                    Navigator.pushNamed(context, ScheduleSessionTime.id);
                  },
                  butContent: Row(
                    children: [
                      Text("Schedule A Session"),
                      Icon(Icons.add)
                    ],
                  ),
                  buttonwidth: 200.0,
                  height: 40.0,
                  padding: EdgeInsets.only(left: 0, top: 0)),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text("Upcoming",style: TextStyle(fontSize: 25.0),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    PlanCell(
                        title: "Hakim Ottey",
                        content:
                        "The Gym",
                        year: "2021",
                        date: "05/15th",
                        time:"10:00am"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text("Upcoming",style: TextStyle(fontSize: 25.0),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    PlanCell(
                        title: "Hakim Ottey",
                        content:
                        "The Gym",
                        completed: Text("Completed",style: TextStyle(color:Colors.green,fontStyle: FontStyle.italic),),
                        year: "2021",
                        date: "05/15th",
                        time:"10:00am"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}