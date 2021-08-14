import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/calorie_break_down.dart';
import 'package:jfl2/Screens/students/schedule_session_time.dart';
import 'package:jfl2/Screens/students/workout_preview.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/meal_cell.dart';
import 'package:jfl2/components/Calorie_Box.dart';
class PlansUpcoming extends StatefulWidget {
  static String id = "PlansUpcoming";

  @override
  _PlansUpcoming createState() => _PlansUpcoming();
}

class _PlansUpcoming extends State<PlansUpcoming> {
  var currentscreen = 0;
  var meals = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
        // return false;
      },
      child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          action: (){
                            Navigator.pushNamed(context, WorkoutPreview.id);
                          },
                          title: "Monday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Tuesday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Wednesday",
                          content: Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Thursday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Friday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Saturday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 10.0),
                      child: PlanCell(
                          title: "Sunday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…")),
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                  ],
                ),
              )
            ),
          ),
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 15.0),
          //   child: FloatingActionButton(
          //     child: Icon(Icons.add),
          //     onPressed: (){
          //
          //     },
          //   ),
          // ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // bottomNavigationBar: BottomAppBar(
          //     child: Row(
          //   children: [
          //     FooterButton(
          //       color: currentscreen == 0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          //       text: Text("Upcoming",style: TextStyle(color: Colors.white,fontSize: 11.0)),
          //       action: () {
          //         setState(() {
          //           currentscreen = 0;
          //         });
          //       },
          //     ),
          //     FooterButton(
          //         color:currentscreen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          //         text: Text("Past Workouts",style: TextStyle(color: Colors.white,fontSize: 11.0)),
          //         action: () {
          //           setState(() {
          //             currentscreen = 1;
          //           });
          //         }),
          //     FooterButton(
          //         color: currentscreen == 2 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          //         text: Text("Meals",style: TextStyle(color: Colors.white,fontSize: 11.0)),
          //         action: () {
          //           setState(() {
          //             currentscreen = 2;
          //           });
          //         }),
          //     FooterButton(
          //         color: currentscreen == 3 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          //         text: Text("Training",style: TextStyle(color: Colors.white,fontSize: 11.0)) ,
          //         action: () {
          //           setState(() {
          //             currentscreen = 3;
          //           });
          //         }),
          //   ],
          // ))
      ),
    );
  }
}

