import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/Screens/students/member_sign_up_goals.dart';
import 'package:jfl2/components/add_goal_screen.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/goal_list.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/hash.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/custom_alert_box.dart';

class MemberSignUp extends StatefulWidget {
  static String id = 'MemberSignUp';

  @override
  _MemberSignUp createState() => _MemberSignUp();
}

class _MemberSignUp extends State<MemberSignUp> {
  late DateTime _dateTime;
  late CancelableOperation userNameOperation;
  late CancelableOperation emailOperation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE5DDDD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            var baseDialog = CustomAlertBox(
              infolist: <Widget>[
                Text(
                    "If you quit signing up, all previously inputted data will be lost! Continue?"),
              ],
              actionlist: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                    Provider.of<StudentSignUpData>(context, listen: false)
                        .resetData();
                    // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                )
              ],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => baseDialog);
          },
        ),
        actions: <Widget>[
          Consumer<StudentSignUpData>(builder: (context, data, child) {
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
                data.height != 0 &&
                data.activelevel != null &&
                data.goalList.length != 0 &&
                data.goalList.length != null &&
                data.studentData.password == data.studentData.rPassword) {
              return FlatButton(
                textColor: Theme.of(context).accentColor,
                onPressed: () async {
                  hasher hash = new hasher();
                  final res = await data.studentData.uploadfile({
                    "fName": data.studentData.fName,
                    "lName": data.studentData.lName,
                    "uName": data.studentData.userName,
                    "bDay": data.studentData.bDay.toString(),
                    "bMonth": data.studentData.bMonth.toString(),
                    "bYear": data.studentData.bYear.toString(),
                    "gender": data.studentData.gender,
                    "email": data.studentData.email,
                    "password": hash
                        .hashpass(data.studentData.password.text)
                        .toString(),
                    "street": data.studentData.strName,
                    "city": data.studentData.city,
                    "state": data.studentData.state,
                    "country": data.studentData.country,
                    "zip": data.studentData.zip,
                    "usertype": "trainer",
                    "weight": data.weight,
                    "weightmeasuredin": "LB",
                    "height": data.height,
                    "inches": data.inches,
                    "heightmeasuredin": "Feet",
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
                    Provider.of<StudentSignUpData>(context, listen: false)
                        .studentData
                        .data = respStr;
                    Navigator.pushNamedAndRemoveUntil(
                        context, StudentEndUserLicense.id, (r) => false);
                  }
                },
                child: Text('Create Account'),
              );
            } else {
              return SizedBox();
            }
          })
        ],
        // backgroundColor: Color(0xff32416F),
        title: Text('Member Sign Up'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 2.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Center(
                child: Consumer<StudentSignUpData>(
                    builder: (context, data, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SignUpFields(
                        controller: data.studentData.fName,
                          hinttext: 'First Name',
                          event: (text) {
                            data.studentData.fName = text;
                          }),
                      SignUpFields(
                        controller: data.studentData.lName,
                          hinttext: 'Last Name',
                          event: (text) {
                            data.studentData.lName = text;
                          }),
                      SignUpFields(
                        controller:data.studentData.userName ,
                        hinttext: 'User Name',
                        event: (text) {
                          data.studentData.userName = text;
                          userNameOperation.cancel();
                          userNameOperation = CancelableOperation.fromFuture(
                              Future.delayed(Duration(seconds: 1), () async {
                            if (data.studentData.userName != "") {
                              // data.studentData.freeusername =
                              //     await data.studentData.checkUsername("username",
                              //         {"username": data.studentData.userName});
                            }
                          }));
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(child: new Builder(builder: (context) {
                            var usernameavailable =
                                Provider.of<StudentSignUpData>(context,
                                        listen: false)
                                    .studentData
                                    .freeusername;
                            var usernameentry = Provider.of<StudentSignUpData>(
                                    context,
                                    listen: false)
                                .studentData
                                .userName;
                            if (usernameentry != "" &&
                                usernameavailable == false) {
                              return Text("Username is Available",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0));
                            } else if (usernameentry != "" &&
                                usernameavailable == true) {
                              return Text("Username is taken",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0));
                            } else {
                              return SizedBox();
                            }
                          })),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now())
                                    .then((date) {
                                  Provider.of<StudentSignUpData>(context,
                                          listen: false)
                                      .studentData
                                      .bDay = date?.day;
                                  print(data.studentData.bDay);
                                  Provider.of<StudentSignUpData>(context,
                                          listen: false)
                                      .studentData
                                      .bMonth = date?.month;
                                  print(data.studentData.bMonth);
                                  Provider.of<StudentSignUpData>(context,
                                          listen: false)
                                      .studentData
                                      .bYear = date?.year;
                                  print(data.studentData.bYear);
                                  // _dateTime = date;
                                  // _dateTime = date;
                                });
                              },
                              icon: Icon(Icons.calendar_today),
                              label: Text('')),
                          Text(data.studentData.bDay == null
                              ? 'Select Birthday'
                              : "${data.studentData.bYear}" +
                                  "/" +
                                  "${data.studentData.bMonth}" +
                                  "/" +
                                  "${data.studentData.bDay}"),
                        ],
                      ),

                      //Creates the gender select menu. Will cause crash if shrinkwrap is removed since this is a grid builder inside a listview
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        // to disable GridView's scrolling
                        shrinkWrap: true,
                        itemCount: data.studentData.genderList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            childAspectRatio: 3),
                        itemBuilder: (context, index) {
                          String pointer = data.studentData.genderList[index];
                          return SquareButton(
                            color: data.studentData.gender == pointer
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                            pressed: () {
                              setState(() {
                                data.studentData.gender = pointer;
                              });
                              print(data.studentData.gender);
                              // data.studentData.gender = "Male";
                            },
                            butContent: Text(pointer,
                                style: data.studentData.gender == pointer
                                    ? Theme.of(context).textTheme.headline1
                                    : Theme.of(context).textTheme.headline2),
                            buttonwidth: 130.0,
                            height: 37.0,
                          );
                        },
                        //   crossAxisSpacing: 10,
                        // mainAxisSpacing: 10,
                        // crossAxisCount: 2,
                      ),
                      SignUpFields(
                        controller: data.studentData.email,
                          hinttext: 'Email',
                          event: (text) {
                            data.studentData.email = text;
                            emailOperation.cancel();
                            emailOperation = CancelableOperation.fromFuture(
                                Future.delayed(Duration(seconds: 1), () async {
                              if (data.studentData.email != "") {
                                // data.studentData.freeemail =
                                //     await data.studentData.checkUsername("email",
                                //         {"email": data.studentData.email});
                              }
                            }));
                            // data.notifyListeners();
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(child: new Builder(builder: (context) {
                            var emailavailable = data.studentData.freeemail;
                            var emailentry = data.studentData.email;
                            if (emailentry != "" && emailavailable == false) {
                              return Text("Email is available!",
                                  style: Theme.of(context).textTheme.headline5);
                            } else if (emailentry != "" &&
                                emailavailable == true) {
                              return Text("Email is Taken",
                                  style: Theme.of(context).textTheme.headline4);
                            } else {
                              return SizedBox();
                            }
                          })),
                        ],
                      ),
                      SignUpFields(
                        controller: data.studentData.password,
                          obscure: true,
                          suggestions: true,
                          autocorrect: true,
                          hinttext: 'Password',
                          event: (text) {
                            setState(() {
                              data.studentData.password = text;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text("Your password must have:",
                              style: Theme.of(context).textTheme.headline6)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "12 characters minimum",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Container(
                            child: data.studentData.islong == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 capital letter",
                              style: Theme.of(context).textTheme.headline1),
                          Container(
                            child: data.studentData.hasUpper == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 lowercase letter",
                              style: Theme.of(context).textTheme.headline1),
                          Container(
                            child: data.studentData.haslower == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("4 numbers minimum",
                              style: Theme.of(context).textTheme.headline1),
                          Container(
                            child: data.studentData.hasDigits == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 special character",
                              style: Theme.of(context).textTheme.headline1),
                          Container(
                            child: data.studentData.hasspecial == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      SignUpFields(
                        controller: data.studentData.rPassword,
                          obscure: true,
                          suggestions: true,
                          autocorrect: true,
                          hinttext: 'Repeat Password',
                          event: (text) {
                            setState(() {
                              data.studentData.rPassword = text;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              if (data.studentData.rPassword != "") {
                                if (data.studentData.rPassword ==
                                    data.studentData.password) {
                                  return Text("Password matches",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5);
                                } else {
                                  return Text("Password does not match",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4);
                                }
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                      SignUpFields(
                        controller: data.studentData.strName,
                        hinttext: 'Street Name',
                        event: (text) {
                          data.studentData.strName = text;
                        },
                      ),
                      SignUpFields(
                        controller:data.studentData.city ,
                          hinttext: 'City',
                          event: (text) {
                            data.studentData.city = text;
                          }),
                      SignUpFields(
                        controller: data.studentData.state,
                        hinttext: 'State',
                        event: (text) {
                          data.studentData.state = text;
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SignUpFields(
                              controller: data.studentData.country,
                              hinttext: 'Country',
                              event: (text) {
                                data.studentData.country = text;
                              },
                            ),
                          ),
                          SizedBox(width: 30.0),
                          Expanded(
                            flex: 1,
                            child: SignUpFields(
                              controller: data.studentData.zip,
                              hinttext: 'ZIP',
                              event: (text) {
                                data.studentData.zip = text;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: SignUpFields(
                              controller: data.weight,
                              keyboardtype: TextInputType.number,
                              hinttext: 'Weight',
                              event: (text) {
                                // data.weight = double.tryParse(text) ?? 0;
                                print(data.weight);
                                // print(data.WeightController.text);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text("LB",
                              style: Theme.of(context).textTheme.bodyText1)
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: SignUpFields(
                              controller: data.height,
                              keyboardtype: TextInputType.number,
                              hinttext: 'Feet',
                              event: (text) {
                                // data.height = int.tryParse(text) ?? 0;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("Feet",
                              style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: SignUpFields(
                              controller: data.inches,
                              keyboardtype: TextInputType.number,
                              hinttext: 'Inches',
                              event: (text) {
                                // data.inches = int.parse(text) ?? 0;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("Inches",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "How Active Are You?",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RadioButton(
                        text: "Extremely Active",
                        color: data.activelevel == 1
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        pressed: () {
                          // data.activelevel = 1;
                        },
                      ),
                      RadioButton(
                        text: "Somewhat Active",
                        color: data.activelevel == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        pressed: () {
                          // data.activelevel = 2;
                        },
                      ),
                      RadioButton(
                        text: "Barely Active",
                        color: data.activelevel == 3
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        pressed: () {
                          // data.activelevel = 3;
                        },
                      ),
                      RadioButton(
                        text: "Not Active At All",
                        color: data.activelevel == 4
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        pressed: () {
                          // data.activelevel = 4;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "What are your goals?",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SquareButton(
                          color: Theme.of(context).accentColor,
                          pressed: () {
                            // setState(() {});
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => GoalList());
                          },
                          butContent: Text(
                            "Add Your First Goal",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          buttonwidth: 200.0,
                          height: 40.0,
                          padding: EdgeInsets.only(left: 10.0, top: 0)),
                      AddGoalScreen()
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
