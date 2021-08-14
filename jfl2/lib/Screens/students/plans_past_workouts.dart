import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/plan_cell.dart';

class PlansPastWorkouts extends StatefulWidget{
  static String id = "PlansPastWorkouts";
  _PlansPastWorkouts createState() => _PlansPastWorkouts();
}

class _PlansPastWorkouts extends State<PlansPastWorkouts> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    FooterButton(
                      color:Color(0xff888787),
                      text: Text("General",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                      action: () {
                        setState(() {});
                      },
                    ),
                    FooterButton(
                        color:Color(0xff888787),
                        text: Text("Favorites",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                        action: () {
                          setState(() {});
                        }),
                    FooterButton(
                        color:Color(0xff888787),
                        text: Text("Date",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                        action: () {
                          setState(() {});
                        }),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                          title: "Monday",
                          content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                          completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Tuesday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Wednesday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Thursday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Friday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Saturday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(
                            title: "Sunday",
                            content:Text("Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea…"),
                            completed: Text("completed on 12/20/2020",style: TextStyle(fontStyle: FontStyle.italic),)),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}