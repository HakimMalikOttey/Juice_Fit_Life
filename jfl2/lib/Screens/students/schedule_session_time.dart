import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/square_button.dart';
class ScheduleSessionTime extends StatefulWidget {
  static String id = "ScheduleSessionTime";

  _ScheduleSessionTime createState() => _ScheduleSessionTime();
}

class _ScheduleSessionTime extends State<ScheduleSessionTime> {
  var steps = 0;
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = "";
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
        title: Text('Set Up a Session'),
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Row(
                      children: [
                        FooterButton(
                          color: steps == 0 ? Color(0xffA96DCC) : Color(
                              0xff888787),
                          text: Text("1",
                              style:
                              TextStyle(color: Colors.white, fontSize: 30.0)),
                          action: () {
                            setState(() {
                              steps = 0;
                            });
                          },
                        ),
                        SizedBox(
                          width: 30.0,
                          child: Icon(Icons.arrow_forward),
                        ),
                        FooterButton(
                            color:
                            steps == 1 ? Color(0xffA96DCC) : Color(0xff888787),
                            text: Text("2",
                                style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                            action: () {
                              setState(() {
                                steps = 1;
                              });
                            }),
                        SizedBox(
                          width: 30.0,
                          child: Icon(Icons.arrow_forward),
                        ),
                        FooterButton(
                            color:
                            steps == 2 ? Color(0xffA96DCC) : Color(0xff888787),
                            text: Text("3",
                                style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                            action: () {
                              setState(() {
                                steps = 2;
                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Builder(builder: (context) {
                    if (steps == 0) {
                      return Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Available Times",
                                      style: TextStyle(fontSize: 20.0),),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SquareButton(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    pressed: () {},
                                    butContent: Row(
                                      children: [
                                        Expanded(
                                            flex: 2, child: Text("October 3")),
                                        Expanded(flex: 2, child: Text("2021")),
                                        Expanded(child: Text("1:15 PM")),
                                      ],
                                    ),
                                    buttonwidth: 320.0,
                                    height: 30.0,
                                    padding: EdgeInsets.only(left: 0, top: 0)),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SquareButton(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    pressed: () {},
                                    butContent: Row(
                                      children: [
                                        Expanded(
                                            flex: 2, child: Text("October 3")),
                                        Expanded(flex: 2, child: Text("2021")),
                                        Expanded(child: Text("2:15 PM")),
                                      ],
                                    ),
                                    buttonwidth: 320.0,
                                    height: 30.0,
                                    padding: EdgeInsets.only(left: 0, top: 0)),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (steps == 1) {
                      return Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Pick A Trainer",
                                      style: TextStyle(fontSize: 20.0),),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                GridView.count(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                    crossAxisCount: 3,
                                    children: List.generate((100), (index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/PlanPlaceholderImage.jpg"),
                                            ),
                                            color: Colors.black
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color:Colors.black,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Hakim Ottey",style: TextStyle(color: Colors.white),),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("October 3rd, 2021 1:15 PM",style: TextStyle(fontSize: 25.0),),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/PlanPlaceholderImage.jpg"),
                                              ),
                                              color: Colors.black
                                          ),
                                          width: 150.0,
                                          height: 150.0,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text("Hakim Ottey",style: TextStyle(fontSize: 23.0),)
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    Text("The Gym",style: TextStyle(fontSize: 23.0),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("112-13 12th Street",style: TextStyle(fontSize: 23.0),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("New York, New York",style: TextStyle(fontSize: 23.0),),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    Text("Special Request from Trainer",style: TextStyle(fontSize: 23.0),),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  color: Colors.white,
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    readOnly: true,
                                    controller: controller,
                                    maxLines: null,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            )
                          ],
                        )
                      );
                    }
                  }),
                ],
              ),
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            FooterButton(
              color: Colors.green,
              text: Text("Next",
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              action: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
