import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/constants.dart';
import 'package:http/http.dart' as http;

import '../../components/custom_alert_box.dart';
import '../../components/loading_indicator.dart';
import '../../main.dart';
import 'sign_in.dart';
import 'start_wrapper.dart';

class ResetUsername extends StatefulWidget {
  static String id = "ResetUsername";
  final userid;
  final validationid;

  ResetUsername({@required this.userid, @required this.validationid});

  @override
  _ResetUsername createState() => _ResetUsername();
}

class _ResetUsername extends State<ResetUsername> {
  TextEditingController changeuser = new TextEditingController();

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
            image:DecorationImage(
              image: AssetImage("assets/jf_3.jpg"),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, -55,
                0.2126, 0.7152, 0.0722, 0, -55,
                0.2126, 0.7152, 0.0722, 0, -55,
                0, 0, 0, 1, 0,
              ]),
            ),
          ),
          child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 2.0),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, right: 24.0, bottom: 24.0),
                          child: Center(
                              child: FutureBuilder(
                            future: checkvalidation(
                                "/email-usercode-verification/${widget.validationid}"),
                            builder: (context, snap) {
                              if (snap.connectionState == ConnectionState.done) {
                                if (snap.hasData) {
                                  final data = snap.data;
                                  print(data);
                                  if (data == false) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 300.0,
                                        ),
                                        Container(
                                            child: Text(
                                                "Please type in your new username",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0))),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SignUpFields(
                                          controller: changeuser,
                                          hinttext: 'Your new username',
                                          event: (text) {
                                            // print(data.WeightController.text);
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: changeuser,
                                            builder: (context, value, child) {
                                              final TextEditingController user = value as TextEditingController;
                                              if (value.text != "") {
                                                return SquareButton(
                                                  color: Colors.white,
                                                  pressed: () {
                                                    var reset = FutureBuilder(
                                                      future: resetUsername(
                                                          "/reset-username/${widget.userid}",
                                                          changeuser.text),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot.hasData) {
                                                            final Map snapData = snapshot.data as Map;
                                                            print(snapshot.data);
                                                            if (snapData["nModified"] >= 1) {
                                                              return CustomAlertBox(
                                                                infolist: <
                                                                    Widget>[
                                                                  Text(
                                                                      "Your username has been sucessfully changed!")
                                                                ],
                                                                actionlist: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                        "Ok"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(context, rootNavigator: true).pop(true);
                                                                      Navigator.pushReplacementNamed(context, StartWrapper.id);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            } else {
                                                              return CustomAlertBox(
                                                                infolist: <
                                                                    Widget>[
                                                                  Text(
                                                                      "An error occurred and we were not able to change your username, please try again later. ")
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
                                                    showDialog(barrierDismissible:false,context:context,builder: (context)=>reset);
                                                  },
                                                  butContent: Text(
                                                      'Change Username',
                                                      style: kFirstButton),
                                                  buttonwidth: 150.0,
                                                );
                                              }
                                              else{
                                                return Container();
                                              }
                                            }),
                                      ],
                                    );
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                  ),
                ],
              )),
        ));
  }
}

class largecircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 200.0,
        bottom: 200.0,
      ),
      child: Container(
        width: 200.0,
        height: 200.0,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).accentColor,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          strokeWidth: 10.0,
        ),
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

Future resetUsername(String data, String username) async {
  final http.Response response = await http.put(Uri.https('$link', "$data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"username": username}));
  // request.fields['data'] = json.encode(data);
  // var res = await request.send();
  return jsonDecode(response.body);
}
