import 'package:flutter/material.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/plan_cell.dart';
import 'package:jfl2/components/square_button.dart';

class ClientProfile extends StatefulWidget{
  static String id = "ClientProfile";
  _ClientProfile createState() => _ClientProfile();
}

class _ClientProfile extends State<ClientProfile>{
  int currentscreen = 0;
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
        title: Text('Client'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: ListView(
            children: [
              Builder(
                  builder: (context){
                    if(currentscreen == 0){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          PlanCell(
                              title: "Roberto Davis",
                              content: "Been your client since 10/03/2020"),
                          SquareButton(
                            color: Colors.black,
                            pressed: (){

                            },
                            butContent: Text("Remove from Plan",style: TextStyle(color: Colors.white),),
                            buttonwidth: 200.0,
                            height: 30.0,
                          )
                        ],
                      );
                    }
                    else if(currentscreen == 1){
                      return Column(
                        children: List.generate(2, (index) {
                          return SquareButton(
                            color: Colors.white,
                            pressed: (){

                            },
                            butContent: Row(
                              children: [
                                Text("Calorie Breakdown for 10/03/2020",style: TextStyle(color: Colors.black),),
                              ],
                            ),
                            buttonwidth: 400.0,
                            height: 30.0,
                          );
                        })
                      );
                    }
                    else if (currentscreen == 2){
                      return Column(
                        children: List.generate(2, (index){
                          return Padding(
                            padding: const EdgeInsets.only(top:20.0),
                            child: PlanCell(
                                title: "Monday",
                                completed: Column(
                                  children: [
                                    Text("Completed on 10/03/2020",style: TextStyle(color: Colors.green,),),
                                  ],
                                ),
                                content: "Barbell Box...,Barbell Lat...,Squat Jum…,Barbell Dea… and 8 more...."),
                          );
                        })
                      );
                    }
                    else{
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            color: Colors.white,
                            height: 100.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Text("Current Progress",style: TextStyle(fontSize: 20.0),),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("200 Pounds(-10 pounds)",style: TextStyle(fontSize: 15.0),),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("20 pounds from goal weight of 180",style: TextStyle(fontSize: 15.0)),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Previous Weight",style: TextStyle(fontSize: 20.0)),
                          Column(
                            children: List.generate(5, (index) => Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Text("200 pounds on 10/03/2020",style: TextStyle(fontSize: 15.0)),
                            )),
                          )
                        ],
                      );
                    }
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              FooterButton(
                color: currentscreen == 0 ? Color(0xff32416F): Colors.black,
                text: Text("General",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                action: () {
                  setState(() {
                    currentscreen = 0;
                  });
                },
              ),
              FooterButton(
                  color: currentscreen == 1 ? Color(0xff32416F): Colors.black,
                  text: Text("Meals",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                  action: () {
                    setState(() {
                      currentscreen = 1;
                    });
                  }),
              FooterButton(
                  color: currentscreen == 2 ? Color(0xff32416F): Colors.black,
                  text: Text("Workout",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                  action: () {
                    setState(() {
                      currentscreen = 2;
                    });
                  }),
              FooterButton(
                  color: currentscreen == 3 ? Color(0xff32416F):Colors.black,
                  text: Text("Weight",style: TextStyle(color: Colors.white,fontSize: 11.0)) ,
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