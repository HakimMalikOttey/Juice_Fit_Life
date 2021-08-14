import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/Screens/trainers/End_User_License.dart';
import 'package:jfl2/components/add_goal_screen.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/goal_list.dart';
import 'package:jfl2/components/icon_picker.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/data/hash.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeneralSignUp extends StatefulWidget {
  static String id = "TrainerSignUp";
  final String? setting;
  final String? type;

  GeneralSignUp({this.setting, this.type});

  _GeneralSignUp createState() => _GeneralSignUp();
}

class _GeneralSignUp extends State<GeneralSignUp> {
  late CancelableOperation userNameOperation;
  late CancelableOperation emailOperation;
  late bool operationpending;
  late Timer timer;

  @override
  void initState() {
    operationpending = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.type == "trainer") {
        Provider.of<TrainerSignUpData>(context, listen: false)
            .trainerData
            .generalValidator();
        Provider.of<TrainerSignUpData>(context, listen: false)
            .trainerValidator();
      } else {
        Provider.of<StudentSignUpData>(context, listen: false)
            .studentData
            .generalValidator();
        Provider.of<StudentSignUpData>(context, listen: false)
            .studentValidator();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Builder(
            builder: (context) {
              if (widget.setting == "create") {
                return AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        var baseDialog = CustomAlertBox(
                          infolist: <Widget>[
                            Text(
                                "If you quit signing up, all previously inputted data will be lost! Continue?"),
                          ],
                          actionlist: <Widget>[
                            TextButton(
                              child: Text(
                                "Yes",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              onPressed: () {
                                if (widget.type == "trainer") {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(true);
                                  Provider.of<TrainerSignUpData>(context,
                                          listen: false)
                                      .resetData();
                                  Navigator.pop(context);
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(true);
                                  Provider.of<StudentSignUpData>(context,
                                          listen: false)
                                      .resetData();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            TextButton(
                              child: Text("No",
                                  style: Theme.of(context).textTheme.headline1),
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
                      }),
                  actions: widget.type == "trainer"
                      ? <Widget>[
                          Consumer<TrainerSignUpData>(
                              builder: (context, data, child) {
                            if (operationpending == false) {
                              if (data.trainerData.valid == true &&
                                  data.trainerValidation == true) {
                                // ignore: deprecated_member_use
                                return FlatButton(
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    hasher test = new hasher();
                                    var Dialog = FutureBuilder(
                                        future: data.trainerData.uploadfile({
                                          "fName": data.trainerData.fName.text
                                              .trim(),
                                          "lName": data.trainerData.lName.text
                                              .trim(),
                                          "uName": data
                                              .trainerData.userName.text
                                              .trim(),
                                          "bDay":
                                              data.trainerData.bDay.toString(),
                                          "bMonth": data.trainerData.bMonth
                                              .toString(),
                                          "bYear":
                                              data.trainerData.bYear.toString(),
                                          "gender": data.trainerData.gender,
                                          "email": data.trainerData.email.text
                                              .trim(),
                                          "password": test
                                              .hashpass(data
                                                  .trainerData.password.text
                                                  .trim())
                                              .toString(),
                                          "profpic": data.Profpic?.assetName,
                                          "street": data
                                              .trainerData.strName.text
                                              .trim(),
                                          "city":
                                              data.trainerData.city.text.trim(),
                                          "state": data.trainerData.state.text
                                              .trim(),
                                          "country": data
                                              .trainerData.country.text
                                              .trim(),
                                          "zip":
                                              data.trainerData.zip.text.trim(),
                                          "usertype": "trainer",
                                          "eulaAccept": false,
                                        }),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              final List snapData = snapshot.data as List;
                                              if (snapData[0] != 200) {
                                                return CustomAlertBox(
                                                  infolist: <Widget>[
                                                    Text(
                                                        "There was an error signing up. Try submiting a new username"),
                                                  ],
                                                  actionlist: <Widget>[
                                                    // ignore: deprecated_member_use
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(true);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                Provider.of<TrainerSignUpData>(
                                                        context,
                                                        listen: false)
                                                    .trainerData
                                                    .data = snapData[1];
                                                print(Provider.of<
                                                            TrainerSignUpData>(
                                                        context,
                                                        listen: false)
                                                    .trainerData
                                                    .data);
                                                WidgetsBinding.instance
                                                    ?.addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          TrainerEndUserLicense
                                                              .id);
                                                });
                                                return Container();
                                              }
                                            } else {
                                              return LoadingIndicator();
                                            }
                                          } else {
                                            return LoadingIndicator();
                                          }
                                        });
                                    return showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => Dialog);
                                    // final res = await data.trainerData.uploadfile({
                                    //   "fName": data.trainerData.fName.text.trim(),
                                    //   "lName": data.trainerData.lName.text.trim(),
                                    //   "uName": data.trainerData.userName.text.trim(),
                                    //   "bDay": data.trainerData.bDay.toString(),
                                    //   "bMonth": data.trainerData.bMonth.toString(),
                                    //   "bYear": data.trainerData.bYear.toString(),
                                    //   "gender": data.trainerData.gender,
                                    //   "email": data.trainerData.email.trim(),
                                    //   "password": test.hashpass(
                                    //       data.trainerData.password.trim()).toString(),
                                    //   "profpic": data.Profpic.assetName,
                                    //   "street": data.trainerData.strName.text.trim(),
                                    //   "city": data.trainerData.city.text.trim(),
                                    //   "state": data.trainerData.state.text.trim(),
                                    //   "country": data.trainerData.country.text.trim(),
                                    //   "zip": data.trainerData.zip.text.trim(),
                                    //   "usertype": "trainer",
                                    //   "eulaAccept": false,
                                    // });
                                  },
                                  child: Text('Create Account'),
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).disabledColor),
                                  strokeWidth: 5.0,
                                ),
                              );
                            }
                          })
                        ]
                      : <Widget>[
                          Consumer<StudentSignUpData>(
                              builder: (context, data, child) {
                            if (operationpending == false) {
                              if (data.studentData.valid == true &&
                                  data.studentValidate == true) {
                                // ignore: deprecated_member_use
                                return FlatButton(
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    hasher hash = new hasher();
                                    var Dialog = FutureBuilder(
                                        future: data.studentData.uploadfile({
                                          "fName": data.studentData.fName.text,
                                          "lName": data.studentData.lName.text,
                                          "uName":
                                              data.studentData.userName.text,
                                          "bDay":
                                              data.studentData.bDay.toString(),
                                          "bMonth": data.studentData.bMonth
                                              .toString(),
                                          "bYear":
                                              data.studentData.bYear.toString(),
                                          "gender": data.studentData.gender,
                                          "email": data.studentData.email,
                                          "password": hash
                                              .hashpass(data
                                                  .studentData.password.text)
                                              .toString(),
                                          "street":
                                              data.studentData.strName.text,
                                          "city": data.studentData.city.text,
                                          "state": data.studentData.state.text,
                                          "country":
                                              data.studentData.country.text,
                                          "zip": data.studentData.zip.text,
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
                                        }),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              final List snapData = snapshot.data as List;
                                              if (snapData[0] != 200) {
                                                return CustomAlertBox(
                                                  infolist: <Widget>[
                                                    Text(
                                                        "There was an error signing up. Try again later"),
                                                  ],
                                                  actionlist: <Widget>[
                                                    // ignore: deprecated_member_use
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(true);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                data.studentData.data =
                                                snapData[1];
                                                WidgetsBinding.instance
                                                    ?.addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          StudentEndUserLicense
                                                              .id);
                                                });
                                                return Container();
                                              }
                                            } else {
                                              return LoadingIndicator();
                                            }
                                          } else {
                                            return LoadingIndicator();
                                          }
                                        });
                                    return showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => Dialog);
                                  },
                                  child: Text('Create Account'),
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).disabledColor),
                                  strokeWidth: 5.0,
                                ),
                              );
                            }
                          })
                        ],
                  title: widget.type == "trainer"
                      ? Text('Trainer Sign Up')
                      : Text('Student Sign Up'),
                );
              } else {
                return AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text('Your Settings'),
                );
              }
            },
          )),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 2.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Center(
                child: Consumer<StudentSignUpData>(
                    builder: (context, studData, child) {
                  return Consumer<TrainerSignUpData>(
                    builder: (context, trainerData, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 4,
                                child: SignUpFields(
                                    hinttext: 'First Name',
                                    controller: widget.type == "trainer"
                                        ? trainerData.trainerData.fName
                                        : studData.studentData.fName,
                                    event: (text) {}),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SignUpFields(
                                    controller: widget.type == "trainer"
                                        ? trainerData.trainerData.lName
                                        : studData.studentData.lName,
                                    hinttext: 'Last Name',
                                    event: (text) {}),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SignUpFields(
                                    controller: widget.type == "trainer"
                                        ? trainerData.trainerData.userName
                                        : studData.studentData.userName,
                                    hinttext: 'User Name',
                                    event: (text) {
                                      operationpending = true;
                                      // data.trainerData.userName = text;
                                      userNameOperation.cancel();
                                      userNameOperation =
                                          CancelableOperation.fromFuture(
                                              Future.delayed(
                                                  Duration(milliseconds: 1),
                                                  () async {
                                        final data = widget.type == "trainer"
                                            ? trainerData.trainerData
                                            : studData.studentData;
                                        if (data.userName != null ||
                                            data.userName.text != "") {
                                          // data.freeusername = await data.checkUsername(
                                          //     "username", {
                                          //   "username":
                                          //       data.userName.text.trim()
                                          // });
                                        }
                                        operationpending = false;
                                      }));
                                      //
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Container(child: new Builder(builder: (context) {
                                final data = widget.type == "trainer"
                                    ? trainerData.trainerData
                                    : studData.studentData;
                                var usernameavailable = data.freeusername;
                                var usernameentry = data.userName;
                                if (usernameentry.text != "" &&
                                    usernameavailable == false) {
                                  return Text("Username is Available",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5);
                                } else if (usernameentry.text != "" &&
                                    usernameavailable == true) {
                                  return Text("Username is taken",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4);
                                } else {
                                  return SizedBox();
                                }
                              })),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              // ignore: deprecated_member_use
                              FlatButton.icon(
                                  onPressed: () async {
                                    final data = widget.type == "trainer"
                                        ? trainerData.trainerData
                                        : studData.studentData;
                                    final picker = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    data.bDay = picker?.day;
                                    data.bMonth = picker?.month;
                                    data.bYear = picker?.year;
                                  },
                                  icon: Icon(Icons.calendar_today),
                                  label: Text('')),
                              Builder(builder: (context) {
                                if (widget.type == "trainer") {
                                  return Text(trainerData.trainerData.bDay ==
                                          null
                                      ? 'Select Birthday'
                                      : "${trainerData.trainerData.bYear}" +
                                          "/" +
                                          "${trainerData.trainerData.bMonth}" +
                                          "/" +
                                          "${trainerData.trainerData.bDay}");
                                } else {
                                  return Text(studData.studentData.bDay == null
                                      ? 'Select Birthday'
                                      : "${studData.studentData.bYear}" +
                                          "/" +
                                          "${studData.studentData.bMonth}" +
                                          "/" +
                                          "${studData.studentData.bDay}");
                                }
                              }),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  // to disable GridView's scrolling
                                  shrinkWrap: true,
                                  itemCount: widget.type == "trainer"
                                      ? trainerData
                                          .trainerData.genderList.length
                                      : studData.studentData.genderList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 3),
                                  itemBuilder: (context, index) {
                                    final data = widget.type == "trainer"
                                        ? trainerData.trainerData
                                        : studData.studentData;
                                    String pointer = data.genderList[index];
                                    return SquareButton(
                                      color: data.gender == pointer
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).accentColor,
                                      pressed: () {
                                        data.gender = pointer;
                                      },
                                      butContent: Text(pointer,
                                          style: data.gender == pointer
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                              : Theme.of(context)
                                                  .textTheme
                                                  .headline2),
                                      buttonwidth: 130.0,
                                      height: 37.0,
                                    );
                                  },
                                  //   crossAxisSpacing: 10,
                                  // mainAxisSpacing: 10,
                                  // crossAxisCount: 2,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SignUpFields(
                                  controller: widget.type == "trainer"
                                      ? trainerData.trainerData.email
                                      : studData.studentData.email,
                                    hinttext: 'Email',
                                    event: (text) {
                                      final data = widget.type == "trainer"
                                          ? trainerData.trainerData
                                          : studData.studentData;
                                      operationpending = true;
                                      data.email = text;
                                      emailOperation.cancel();
                                      emailOperation =
                                          CancelableOperation.fromFuture(
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                        // if (data.email != "") {
                                        //   data.freeemail = await data.checkUsername(
                                        //       "email", {"email": data.email});
                                        // }
                                        operationpending = false;
                                      }));
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Container(child: new Builder(builder: (context) {
                                final data = widget.type == "trainer"
                                    ? trainerData.trainerData
                                    : studData.studentData;
                                var emailavailable = data.freeemail;
                                var emailentry = data.email;
                                if (emailentry.text != "" &&
                                    emailavailable == false) {
                                  return Text("Email is available!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5);
                                } else if (emailavailable == true) {
                                  return Text("Email is Taken",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4);
                                } else {
                                  return SizedBox();
                                }
                              })),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SignUpFields(
                                  controller: widget.type == "trainer"
                                      ? trainerData.trainerData.password
                                      : studData.studentData.password,
                                    obscure: true,
                                    suggestions: true,
                                    autocorrect: true,
                                    hinttext: 'Password',
                                    event: (text) {
                                      final data = widget.type == "trainer"
                                          ? trainerData.trainerData
                                          : studData.studentData;
                                      data.password = text;
                                    }),
                              ),
                            ],
                          ),
                          SignUpFields(
                            controller: widget.type == "trainer"
                                ? trainerData.trainerData.rPassword
                                : studData.studentData.rPassword,
                              obscure: true,
                              suggestions: true,
                              autocorrect: true,
                              hinttext: 'Repeat Password',
                              event: (text) {
                                final data = widget.type == "trainer"
                                    ? trainerData.trainerData
                                    : studData.studentData;
                                data.rPassword = text;
                              }),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  final data = widget.type == "trainer"
                                      ? trainerData.trainerData
                                      : studData.studentData;
                                  if (data.rPassword != "" &&
                                      data.rPassword == data.password) {
                                    return Text("Password matches",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5);
                                  } else if (data.rPassword != "" &&
                                      data.rPassword != data.password) {
                                    return Text("Password does not match",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4);
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Builder(builder: (context) {
                            if (widget.type == "trainer") {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Set Your Profile Picture",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: trainerData.Profpic == null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                                width: 150.0,
                                                height: 150.0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Your Profile Picture",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                    )
                                                  ],
                                                ))
                                            : Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                            trainerData.Profpic as AssetImage,
                                                        fit: BoxFit.fill)),
                                                width: 150.0,
                                                height: 150.0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [],
                                                )),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            SquareButton(
                                              color:
                                                  Theme.of(context).accentColor,
                                              pressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        IconPicker());
                                              },
                                              butContent: Text(
                                                "Select an Icon",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              ),
                                              buttonwidth:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              height: 30.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }),
                          Row(
                            children: [
                              Text(
                                "Set Your Address",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    final data = widget.type == "trainer"
                                        ? trainerData.trainerData
                                        : studData.studentData;
                                    bool serviceEnabled;
                                    LocationPermission permission;
                                    serviceEnabled = await Geolocator
                                        .isLocationServiceEnabled();
                                    if (!serviceEnabled) {
                                      print("Location services are disabled");
                                    } else {
                                      permission =
                                          await Geolocator.requestPermission();
                                      if (permission ==
                                          LocationPermission.deniedForever) {
                                        print("Denied Forever");
                                      } else if (permission ==
                                          LocationPermission.denied) {
                                        print("Denied");
                                      } else {
                                        var location = await Geolocator
                                            .getCurrentPosition();
                                        print(location.latitude);
                                        print(location.longitude);
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                                location.latitude,
                                                location.longitude);
                                        Placemark place = placemarks[0];
                                        data.strName.text = place.street as String;
                                        data.city.text = place.subLocality as String;
                                        data.state.text =
                                            place.administrativeArea as String;
                                        data.country.text = place.country as String;
                                        data.zip.text = place.postalCode as String;
                                      }
                                    }
                                  },
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: Theme.of(context).accentColor,
                                    size: 35.0,
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SignUpFields(
                                      controller: widget.type == "trainer"
                                          ? trainerData.trainerData.strName
                                          : studData.studentData.strName,
                                      hinttext: 'Street Name',
                                      event: (text) {},
                                    ),
                                    SignUpFields(
                                        controller: widget.type == "trainer"
                                            ? trainerData.trainerData.city
                                            : studData.studentData.city,
                                        hinttext: 'City',
                                        event: (text) {}),
                                    SignUpFields(
                                        controller: widget.type == "trainer"
                                            ? trainerData.trainerData.state
                                            : studData.studentData.state,
                                        hinttext: 'State',
                                        event: (text) {}),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: SignUpFields(
                                                controller:
                                                    widget.type == "trainer"
                                                        ? trainerData
                                                            .trainerData.country
                                                        : studData.studentData
                                                            .country,
                                                hinttext: 'Country',
                                                event: (text) {})),
                                        SizedBox(width: 30.0),
                                        Expanded(
                                            flex: 1,
                                            child: SignUpFields(
                                                controller: widget.type ==
                                                        "trainer"
                                                    ? trainerData
                                                        .trainerData.zip
                                                    : studData.studentData.zip,
                                                hinttext: 'ZIP',
                                                event: (text) {})),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Builder(builder: (context) {
                                      if (widget.type == "trainer") {
                                        return Container();
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: SignUpFields(
                                                    controller: studData.weight,
                                                    keyboardtype:
                                                        TextInputType.number,
                                                    hinttext: 'Weight',
                                                    event: (text) {
                                                      // studData.weight =
                                                      //     double.tryParse(
                                                      //             text) ??
                                                      //         0;
                                                      // print(data.WeightController.text);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30.0,
                                                ),
                                                Text("LB",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1)
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: SignUpFields(
                                                    controller: studData.height,
                                                    keyboardtype:
                                                        TextInputType.number,
                                                    hinttext: 'Feet',
                                                    event: (text) {
                                                      // studData.height =
                                                      //     int.tryParse(text) ??
                                                      //         0;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Text("Feet",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Expanded(
                                                  child: SignUpFields(
                                                    controller:  studData.inches,
                                                    keyboardtype:
                                                        TextInputType.number,
                                                    hinttext: 'Inches',
                                                    event: (text) {
                                                      // studData.inches =
                                                      //     int.parse(text) ?? 0;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Text("Inches",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            Text(
                                              "How Active Are You?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            RadioButton(
                                              text: "Extremely Active",
                                              color: studData.activelevel == 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                              pressed: () {
                                                // studData.activelevel = 1;
                                              },
                                            ),
                                            RadioButton(
                                              text: "Somewhat Active",
                                              color: studData.activelevel == 2
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                              pressed: () {
                                                // studData.activelevel = 2;
                                              },
                                            ),
                                            RadioButton(
                                              text: "Barely Active",
                                              color: studData.activelevel == 3
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                              pressed: () {
                                                // studData.activelevel = 3;
                                              },
                                            ),
                                            RadioButton(
                                              text: "Not Active At All",
                                              color: studData.activelevel == 4
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                              pressed: () {
                                                // studData.activelevel = 4;
                                              },
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Text(
                                              "What are your goals?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            SquareButton(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                pressed: () {
                                                  // setState(() {});
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          GoalList());
                                                },
                                                butContent: Text(
                                                  "Add Your First Goal",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2,
                                                ),
                                                buttonwidth: 200.0,
                                                height: 40.0,
                                                padding: EdgeInsets.only(
                                                    left: 10.0, top: 0)),
                                            AddGoalScreen()
                                          ],
                                        );
                                      }
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.setting == "create"
          ? Container(
              height: 0.0,
            )
          : Container(
              color: Colors.green,
              height: 40.0,
            ),
    );
  }
}

