import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jfl2/components/footer_button.dart';
import 'plans_upcoming.dart';

class WorkoutReview extends StatefulWidget{
  static String id = "WorkoutReview";
  _WorkoutReview createState() => _WorkoutReview();
}

class _WorkoutReview extends State<WorkoutReview> {
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
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0,),
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text("Workout Intensity"),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(child: Text("Easy"))),
                      Container(child: Text("Hard"))
                    ],
                  ),
                  SliderTheme(data: SliderTheme.of(context).copyWith(
                    trackShape: RectangularSliderTrackShape() ,
                      trackHeight: 1,
                      inactiveTrackColor: Colors.black,
                      activeTrackColor: Colors.black,
                      thumbColor: Colors.black,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 7.0),
                      overlayColor: Color(0x29EB1555)
                  ), child: Slider(
                    value: 3,
                    divisions: 10,
                    min:0,
                    max:10,
                    inactiveColor: Colors.black,
                    onChanged: (double newvalue){
                    },
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(10, (index) => Text("${index+1}")),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Text("Current Feeling"),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(child: Text("Good"))),
                      Container(child: Text("Bad"))
                    ],
                  ),
                  SliderTheme(data: SliderTheme.of(context).copyWith(
                      trackShape: RectangularSliderTrackShape() ,
                      trackHeight: 1,
                      inactiveTrackColor: Colors.black,
                      activeTrackColor: Colors.black,
                      thumbColor: Colors.black,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 7.0),
                      overlayColor: Color(0x29EB1555)
                  ), child: Slider(
                    value: 3,
                    divisions: 10,
                    min:0,
                    max:10,
                    inactiveColor: Colors.black,
                    onChanged: (double newvalue){
                    },
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(10, (index) => Text("${index+1}")),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Text("Comments"),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                height: 200,
                // constraints: BoxConstraints(maxHeight: 200),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  readOnly: false,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            FooterButton(
              color: Colors.green,
              text: Text("End Workout",
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              action: () {
                Navigator.pushNamed(context, PlansUpcoming.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}