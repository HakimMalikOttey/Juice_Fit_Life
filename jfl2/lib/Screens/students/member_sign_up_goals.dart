import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/components/add_goal_screen.dart';
import 'package:jfl2/components/android_dropdown.dart';
import 'package:jfl2/components/goal_list.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/goals.dart';
import 'package:jfl2/data/height.dart';
import 'package:jfl2/data/weight.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/data/hash.dart';

class MemberSignUpGoals extends StatefulWidget {
  static String id = "MemberSignUpGoals";
  @override
  _MemberSignUpGoals createState() => _MemberSignUpGoals();
}

class _MemberSignUpGoals extends State<MemberSignUpGoals> {
  int group = 0;
  String selectedWeightMeasure = weightList[0];
  String selectedHeightMeasure = heightList[0];
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
        actions: <Widget>[
          Consumer<StudentSignUpData>(builder: (context, data, child) {
            print(data.studentData.freeemail);
            if (data.studentData.fName != "" &&
                data.studentData.lName != "" &&
                data.studentData.freeusername != true &&
                data.studentData.userName != "" &&
                data.studentData.bDay != null &&
                data.studentData.gender != "" &&
                data.studentData.email != "" &&
                data.studentData.haslower &&
                data.studentData.hasUpper &&
                data.studentData.hasDigits &&
                data.studentData.hasspecial &&
                data.studentData.islong &&
                data.studentData.strName != "" &&
                data.studentData.city != "" &&
                data.studentData.country != "" &&
                data.studentData.zip != "" &&
                data.studentData.state != "" &&
                data.studentData.freeemail != true &&
                data.weight != 0 &&
                (selectedHeightMeasure == "FT" && data.height != 0 ||
                    selectedHeightMeasure == "CM" && data.height != 0) &&
                data.activelevel != null &&
                data.goalList.length != 0 &&
                data.goalList.length != null &&
                data.studentData.password == data.studentData.rPassword) {
              return FlatButton(
                textColor: Colors.white,
                onPressed: () async {
                  // Provider .of<TrainerSignUpData>(context, listen: false).trainerData.check("register",{
                  //   "fName": data.trainerData.fName,
                  //   "lName": data.trainerData.lName,
                  //   "uName" : data.trainerData.userName,
                  //   "bDay": data.trainerData.bDay.toString(),
                  //   "bMonth": data.trainerData.bMonth.toString(),
                  //   "bYear":data.trainerData.bYear.toString(),
                  //   "gender":data.trainerData.gender,
                  //   "email":data.trainerData.email,
                  //   "password":data.trainerData.password,
                  // }
                  //   );

                  // Navigator.pushNamed(context, TrainerEndUserLicense.id);
                  // print(data.Profpic);
                  hasher test = new hasher();
                  final res = await data.studentData.uploadfile({
                    "fName": data.studentData.fName,
                    "lName": data.studentData.lName,
                    "uName": data.studentData.userName,
                    "bDay": data.studentData.bDay.toString(),
                    "bMonth": data.studentData.bMonth.toString(),
                    "bYear": data.studentData.bYear.toString(),
                    "gender": data.studentData.gender,
                    "email": data.studentData.email,
                    "password": test
                        .hashpass(data.studentData.password.text)
                        .toString(),
                    "street": data.studentData.strName,
                    "city": data.studentData.city,
                    "state": data.studentData.state,
                    "country": data.studentData.country,
                    "zip": data.studentData.zip,
                    "usertype": "trainer",
                    "weight": data.weight,
                    "weightmeasuredin": selectedWeightMeasure,
                    "height": data.height,
                    "inches": data.inches,
                    "heightmeasuredin": selectedHeightMeasure,
                    "activelevel": data.activelevel,
                    "goals": data.goalList,
                    "eulaAccept": false,
                    "usertype": "student"
                  });
                  final respStr = await res.stream.bytesToString();
                  print(jsonDecode(respStr)["code"]);
                  if (jsonDecode(respStr)["code"] == 11000) {
                    var baseDialog = CustomAlertBox(
                      infolist: <Widget>[
                        Text(
                            "There was an error signing up. Try submiting a new username"),
                      ],
                      actionlist: <Widget>[
                        FlatButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(false);
                          },
                        )
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => baseDialog);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, StudentEndUserLicense.id, (r) => false);
                  }
                },
                child: Text('Create Account'),
              );
            } else {
              // print(data.trainerData.fName);
              // print(data.trainerData.lName);
              // print("Username: ${data.trainerData.freeusername}");
              // print(data.trainerData.bDay);
              // print(data.trainerData.gender);
              // print("freeemail: ${data.trainerData.email}");
              // print("haslower: ${data.trainerData.haslower}");
              // print("hasUpper: ${data.trainerData.hasUpper}");
              // print("hasDigits: ${data.trainerData.hasDigits}");
              // print("hasspecial: ${data.trainerData.hasspecial}");
              // print("islong: ${data.trainerData.islong}");
              // print("passwords match:${data.trainerData.password ==
              //     data.trainerData.rPassword}");
              // print(data.trainerData.strName);
              // print(data.trainerData.city);
              // print(data.trainerData.country);
              // print(data.trainerData.zip);
              return SizedBox();
            }
          })
        ],
        backgroundColor: Color(0xff32416F),
        title: Text('Member Sign Up'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Consumer<StudentSignUpData>(
                builder: (context, data, child) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black, width: 3.0)),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black, width: 3.0)),
                                    hintText: 'Weight',
                                    hintStyle: TextStyle(color: Colors.black)),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                onChanged: (text) {
                                  // selectedWeightMeasure == weightList[0] ? data.weightType = weightList[0] : data.weightType = weightList[1];
                                  // data.weight = double.tryParse(
                                  //         data.WeightController.text) ??
                                  //     0;
                                  print(data.weight);
                                  // print(data.WeightController.text);
                                },
                                // controller: data.WeightController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              // child: SquareButton(
                              //   color: Color(0xff32416F),
                              //   textColor: Colors.white,
                              //   pressed: () {
                              //     setState(() {});
                              //   },
                              //   butContent: Text('LB', style: TextStyle(color:Colors.white)),
                              //   buttonwidth: 50.0,
                              //   height: 37.0,
                              // ),
                              child: DropListButton(
                                startingData: selectedWeightMeasure,
                                width: 100.0,
                                dataList: weightList,
                                butColor: Color(0xff32416F),
                                color: Colors.white,
                                change: (value) {
                                  setState(() {
                                    selectedWeightMeasure = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 50.0,
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                // controller: data.FeetController,
                                decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black, width: 3.0)),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black, width: 3.0)),
                                    hintText:
                                        selectedHeightMeasure == heightList[0]
                                            ? 'Feet'
                                            : 'Centimeters',
                                    hintStyle: TextStyle(color: Colors.black)),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                onChanged: (text) {
                                  // selectedHeightMeasure == heightList[0]
                                  //     ? data.heightType = heightList[0]
                                  //     : data.heightType = heightList[1];
                                  // data.height =
                                  //     int.tryParse(data.FeetController.text) ??
                                  //         0;
                                  // print(data.height);
                                  // print(data.heightType);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: DropListButton(
                                width: 60.0,
                                startingData: selectedHeightMeasure,
                                dataList: heightList,
                                butColor: Color(0xff32416F),
                                color: Colors.white,
                                change: (value) {
                                  setState(() {
                                    selectedHeightMeasure = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: selectedHeightMeasure == heightList[0]
                                    ? TextField(
                                        keyboardType: TextInputType.number,
                                        // controller: data.InchController,
                                        decoration: InputDecoration(
                                            focusedBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.black,
                                                        width: 3.0)),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.black,
                                                        width: 3.0)),
                                            hintText: 'Inches',
                                            hintStyle:
                                                TextStyle(color: Colors.black)),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        onChanged: (text) {
                                          // selectedHeightMeasure == heightList[0]
                                          //     ? data.heightType = heightList[0]
                                          //     : data.heightType = heightList[1];
                                          // data.inches = int.parse(
                                          //     data.InchController.text);
                                          // print(data.inches);
                                          // print(data.heightType);
                                        },
                                      )
                                    : Container(),
                              ),
                            ),
                            Container(
                              child: selectedHeightMeasure == heightList[0]
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("inches"),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "How Active Are You?",
                              style: TextStyle(fontSize: 25.0),
                            ),
                          ],
                        ),
                        RadioButton(
                          text: "Extremely Active",
                          color: data.activelevel == 1
                              ? Color(0xff32416F)
                              : Colors.white,
                          pressed: () {
                            // data.activelevel = 1;
                          },
                        ),
                        RadioButton(
                          text: "Somewhat Active",
                          color: data.activelevel == 2
                              ? Color(0xff32416F)
                              : Colors.white,
                          pressed: () {
                            // data.activelevel = 2;
                          },
                        ),
                        RadioButton(
                          text: "Barely Active",
                          color: data.activelevel == 3
                              ? Color(0xff32416F)
                              : Colors.white,
                          pressed: () {
                            // data.activelevel = 3;
                          },
                        ),
                        RadioButton(
                          text: "Not Active At All",
                          color: data.activelevel == 4
                              ? Color(0xff32416F)
                              : Colors.white,
                          pressed: () {
                            // data.activelevel = 4;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "What are your goals?",
                              style: TextStyle(fontSize: 25.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SquareButton(
                                color: Colors.white,
                                pressed: () {
                                  // setState(() {});
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => GoalList());
                                },
                                butContent: Text("Add Your First Goal"),
                                buttonwidth: 200.0,
                                height: 40.0,
                                padding: EdgeInsets.only(left: 10.0, top: 0)),
                          ],
                        ),
                        AddGoalScreen()
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
