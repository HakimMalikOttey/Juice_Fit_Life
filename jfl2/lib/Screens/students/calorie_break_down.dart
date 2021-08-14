import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalorieBreakDown extends StatefulWidget{
  static String id = "CalorieBreakDown";
  @override
  _CalorieBreakDown createState() => _CalorieBreakDown();
}

class _CalorieBreakDown extends State<CalorieBreakDown> {
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
          title: Text('Meal Tracking'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Calories",style: TextStyle(fontSize: 23.0)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 150.0,
                      color:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left:24.0,right:24.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text("1500 out of 3000 calories consumed"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text("Calories gained from food: 1500"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text("Calories lost from excercise: 0 "),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Carbohydrates",style: TextStyle(fontSize: 23.0)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      color:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left:24.0,right:24.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text("50/225 grams of carbohydrates"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Fats",style: TextStyle(fontSize: 23.0)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 100.0,
                      color:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left:24.0,right:24.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text("Saturated: 10 grams"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text("Trans:10 grams"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text("Unsaturated: 30 grams"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Water",style: TextStyle(fontSize: 23.0)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      color:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left:24.0,right:24.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text("3/8 ounces of water"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      );
  }
}