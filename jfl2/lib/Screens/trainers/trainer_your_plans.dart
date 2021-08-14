import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/trainer_drawer.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

import '../../components/plan_banner.dart';

class TrainerYourPlans extends StatefulWidget {
  static String id = "TrainerYourPlans";
  @override
  _TrainerYourPlans createState() => _TrainerYourPlans();
}

class _TrainerYourPlans extends State<TrainerYourPlans> {
  int currentscreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: TrainerDrawer(),
      appBar: AppBar(
        title: Text("Your Plans"),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     if(_scaffoldKey.currentState.isDrawerOpen == false){
        //       _scaffoldKey.currentState.openDrawer();
        //     }
        //     else{
        //       _scaffoldKey.currentState.openEndDrawer();
        //     }
        //   },
        // ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: ListView(
            children: [
              Builder(builder: (context) {
                if (currentscreen == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.pushNamed(context, TrainerPlanEditor.id);
                          },
                          butContent: Text(
                            "Create New Plan",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonwidth: 150.0),
                      SizedBox(
                        height: 20.0,
                      ),
                      ExpansionTile(
                        title: Text("Unfinished Drafts"),
                        children: [],
                      ),
                      ExpansionTile(
                        title: Text("Inactive Plans"),
                        children: [],
                      ),
                      ExpansionTile(
                        title: Text("Active Plans"),
                        children: [
                          PlanBanner(
                              name: "Get Big",
                              author: "",
                              img: "assets/PlanPlaceholderImage.jpg",
                              pressed: () {
                                // Navigator.of(context).pushNamed(PlansUpcoming.id);
                                // print(index);
                              }),
                          SizedBox(
                            height: 20.0,
                          ),
                          PlanBanner(
                              name: "Get Big",
                              author: "",
                              img: "assets/PlanPlaceholderImage.jpg",
                              pressed: () {
                                // Navigator.of(context).pushNamed(PlansUpcoming.id);
                                // print(index);
                              }),
                        ],
                      ),
                    ],
                  );
                } else if (currentscreen == 1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.pushNamed(context, TrainerDayMaker.id);
                          },
                          butContent: Text(
                            "Create New Day",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonwidth: 150.0),
                      SizedBox(
                        height: 20.0,
                      ),
                      PlanCell(
                          action: () {},
                          title: "Monday",
                          content:
                              "Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea… and 8 more...."),
                    ],
                  );
                } else if (currentscreen == 2) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.pushNamed(
                                context, TrainerWorkoutMakerStraight.id);
                          },
                          butContent: Text(
                            "Create New Workout",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonwidth: 150.0),
                      SizedBox(
                        height: 20.0,
                      ),
                      // WorkoutExampleCell(
                      //   path: "assets/Coco.mp4",
                      //   sets: 3,
                      //   workoutname: "Workout test",
                      // ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SquareButton(
                          color: Colors.black,
                          pressed: () {
                            Navigator.pushNamed(
                                context, TrainerMealPlanMaker.id,
                                arguments: {"text": "", "mealid": ""});
                          },
                          butContent: Text(
                            "Create New Meal Plan",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonwidth: 150.0),
                      SizedBox(
                        height: 20.0,
                      ),
                      FutureBuilder(
                          future: Provider.of<MealPlanMakerData>(context,
                                  listen: false)
                              .getMeal(
                                  Provider.of<TrainerSignUpData>(context,
                                          listen: false)
                                      .trainerData
                                      .memberid,
                                  {}),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              List decoded = json.decode(snapshot.data as String);
                              print(decoded);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: decoded.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    TrainerMealPlanMaker.id,
                                                    arguments: {
                                                      "text": decoded[index]
                                                          ["meal"],
                                                      "mealid": decoded[index]
                                                          ["_id"]
                                                    });
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                height: 100.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "${decoded[index]["meal"]}",
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                      overflow:
                                                          TextOverflow.fade),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // data.removeWorkout(index);
                                          },
                                          child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              return SizedBox();
                            }
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      // MealPlanCell()
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          FooterButton(
            color: currentscreen == 0 ? Color(0xff32416F) : Colors.black,
            text: Text("Plans",
                style: TextStyle(color: Colors.white, fontSize: 11.0)),
            action: () {
              setState(() {
                currentscreen = 0;
              });
            },
          ),
          FooterButton(
              color: currentscreen == 1 ? Color(0xff32416F) : Colors.black,
              text: Text("Days",
                  style: TextStyle(color: Colors.white, fontSize: 11.0)),
              action: () {
                setState(() {
                  currentscreen = 1;
                });
              }),
          FooterButton(
              color: currentscreen == 2 ? Color(0xff32416F) : Colors.black,
              text: Text("Workouts",
                  style: TextStyle(color: Colors.white, fontSize: 11.0)),
              action: () {
                setState(() {
                  currentscreen = 2;
                });
              }),
          FooterButton(
              color: currentscreen == 3 ? Color(0xff32416F) : Colors.black,
              text: Text("Meal Plans",
                  style: TextStyle(color: Colors.white, fontSize: 11.0)),
              action: () {
                setState(() {
                  currentscreen = 3;
                });
              }),
        ],
      )),
    );
  }
}
