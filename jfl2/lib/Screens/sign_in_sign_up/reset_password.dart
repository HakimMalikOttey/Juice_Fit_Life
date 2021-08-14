import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/double_value_listanable.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/constants.dart';
import 'package:http/http.dart' as http;

import '../../components/custom_alert_box.dart';
import '../../components/loading_indicator.dart';
import '../../data/hash.dart';
import '../../data/member_sign_up_data.dart';
import '../../main.dart';
import 'sign_in.dart';
import 'start_wrapper.dart';

class ResetPassword extends StatefulWidget {
  static String id = "ResetPassword";
  final userid;
  final validationid;
  ResetPassword({@required this.userid, @required this.validationid});
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  TextEditingController changepassword = new TextEditingController();
  TextEditingController changepasswordcheck = new TextEditingController();
  MemberSignupData resetdata = new MemberSignupData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/jf_2.jpg"),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.matrix(<double>[
                0.2126,
                0.7152,
                0.0722,
                0,
                -55,
                0.2126,
                0.7152,
                0.0722,
                0,
                -55,
                0.2126,
                0.7152,
                0.0722,
                0,
                -55,
                0,
                0,
                0,
                1,
                0,
              ]),
            ),
          ),
          child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 2.0),
              child: ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 24.0),
                      child: Center(
                          child: FutureBuilder(
                        future: checkvalidation(
                            "/email-passcode-verification/${widget.validationid}"),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.done) {
                            if (snap.hasData) {
                              final data = snap.data;
                              print(data);
                              if (data == false) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 150.0,
                                    ),
                                    Container(
                                        child: Text(
                                            "Please create your new password",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0))),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SignUpFields(
                                      obscure: true,
                                      suggestions: true,
                                      autocorrect: true,
                                      controller: changepassword,
                                      hinttext: 'Your new password',
                                      event: (text) {
                                        resetdata.password.text =
                                            changepassword.text;
                                        // print(data.WeightController.text);
                                      },
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        Text("Your password must have:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1)
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: changepassword,
                                        builder: (context, value, child) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("12 characters minimum"),
                                                  Container(
                                                    child: resetdata.islong ==
                                                            false
                                                        ? Icon(Icons.close,
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)
                                                        : Icon(Icons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .toggleableActiveColor),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "At least 1 capital letter"),
                                                  Container(
                                                    child: resetdata.hasUpper ==
                                                            false
                                                        ? Icon(Icons.close,
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)
                                                        : Icon(Icons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .toggleableActiveColor),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "At least 1 lowercase letter"),
                                                  Container(
                                                    child: resetdata.haslower ==
                                                            false
                                                        ? Icon(Icons.close,
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)
                                                        : Icon(Icons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .toggleableActiveColor),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("4 numbers minimum"),
                                                  Container(
                                                    child: resetdata
                                                                .hasDigits ==
                                                            false
                                                        ? Icon(Icons.close,
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)
                                                        : Icon(Icons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .toggleableActiveColor),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "At least 1 special character"),
                                                  Container(
                                                    child: resetdata
                                                                .hasspecial ==
                                                            false
                                                        ? Icon(Icons.close,
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)
                                                        : Icon(Icons.check,
                                                            color: Theme.of(
                                                                    context)
                                                                .toggleableActiveColor),
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                    SignUpFields(
                                      obscure: true,
                                      suggestions: true,
                                      autocorrect: true,
                                      controller: changepasswordcheck,
                                      hinttext: 'Re-type your own password',
                                      event: (text) {
                                        resetdata.rPassword.text =
                                            changepasswordcheck.text;
                                      },
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: changepasswordcheck,
                                          builder: (context, value, child) {
                                            if (resetdata.rPassword != "" &&
                                                resetdata.rPassword ==
                                                    resetdata.password) {
                                              return Text("Password matches",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5);
                                            } else if (resetdata.rPassword !=
                                                    "" &&
                                                resetdata.rPassword !=
                                                    resetdata.password) {
                                              return Text(
                                                  "Password does not match",
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
                                      height: 20,
                                    ),
                                    DoubleValueListenable(
                                      first: changepassword,
                                      second: changepasswordcheck,
                                      builder: (context, val1, val2, child) {
                                        final TextEditingController v1 = val1 as TextEditingController;
                                        final TextEditingController v2 = val2 as TextEditingController;
                                        if (v1.text  != "" ||
                                            v2.text != "") {
                                          if (resetdata.islong &&
                                              resetdata.hasUpper &&
                                              resetdata.haslower &&
                                              resetdata.hasDigits &&
                                              resetdata.hasspecial) {
                                            if (v1.text ==
                                                v2.text) {
                                              return SquareButton(
                                                color: Colors.white,
                                                pressed: () {
                                                  final hash = new hasher();
                                                  var reset = FutureBuilder(
                                                    future: resetPassword(
                                                        "/reset-password/${widget.userid}",
                                                        hash
                                                            .hashpass(
                                                                changepassword
                                                                    .text)
                                                            .toString()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          final Map snapData = snapshot.data as Map;
                                                          if (snapData[
                                                                  "nModified"] >=
                                                              1) {
                                                            return CustomAlertBox(
                                                              infolist: <
                                                                  Widget>[
                                                                Text(
                                                                    "Your password has been sucessfully changed!")
                                                              ],
                                                              actionlist: <
                                                                  Widget>[
                                                                TextButton(
                                                                  child: Text(
                                                                      "Ok"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            true);
                                                                    Navigator.pushReplacementNamed(
                                                                        context,
                                                                        StartWrapper
                                                                            .id);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          } else {
                                                            return CustomAlertBox(
                                                              infolist: <
                                                                  Widget>[
                                                                Text(
                                                                    "An error occurred and we were not able to change your password, please try again later. ")
                                                              ],
                                                              actionlist: <
                                                                  Widget>[
                                                                TextButton(
                                                                  child: Text(
                                                                      "Ok"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        } else {
                                                          return LoadingIndicator();
                                                        }
                                                      } else {
                                                        return LoadingIndicator();
                                                      }
                                                    },
                                                  );
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          reset);
                                                  // Navigator.pushNamed(context, SignIn.id);
                                                },
                                                butContent: Text(
                                                    'Change Password',
                                                    style: kFirstButton),
                                                buttonwidth: 150.0,
                                              );
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Container();
                                        }
                                      },
                                      child: Container(),
                                    ),
                                  ],
                                );
                              } else {
                                print("test");
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "This link has either expired or does not exist"),
                                      SquareButton(
                                        color: Colors.white,
                                        pressed: () {
                                          Navigator.pushNamed(
                                              context, StartWrapper.id);
                                        },
                                        butContent: Text(
                                            'Return to Start Screen',
                                            style: kFirstButton),
                                        buttonwidth: 150.0,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return largecircle();
                            }
                          } else {
                            return largecircle();
                          }
                        },
                      ))),
                ],
              )),
        ));
  }
}

class largecircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).accentColor,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        strokeWidth: 10.0,
      ),
    );
  }
}

Future checkvalidation(String data) async {
  final http.Response response = await http.get(
    Uri.https('$link', "$data"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  // request.fields['data'] = json.encode(data);
  // var res = await request.send();
  return jsonDecode(response.body);
}

Future resetPassword(String data, String username) async {
  final http.Response response = await http.put(Uri.https('$link', "$data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"password": username}));
  // request.fields['data'] = json.encode(data);
  // var res = await request.send();
  return jsonDecode(response.body);
}
