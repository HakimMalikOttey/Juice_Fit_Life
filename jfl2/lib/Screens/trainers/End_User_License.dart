import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/log_out_box.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/constants.dart';
import 'package:jfl2/Screens/trainers/Trainer_Main_Menu.dart';

class TrainerEndUserLicense extends StatefulWidget {
  static String id = 'TrainerEndUserLicense';

  @override
  _TrainerEndUserLicense createState() => _TrainerEndUserLicense();
}

class _TrainerEndUserLicense extends State<TrainerEndUserLicense> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text('Trainer Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => LogOutBox(
                      pressed: () {
                        // Provider.of<CheckAccount>(context, listen: false).resetdata();
                        Provider.of<TrainerSignUpData>(context, listen: false)
                            .resetData();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, StartWrapper.id);
                      },
                    ));
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => LogOutBox(
                    pressed: () {
                      // Provider.of<CheckAccount>(context, listen: false).resetdata();
                      Provider.of<TrainerSignUpData>(context, listen: false)
                          .resetData();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, StartWrapper.id);
                    },
                  ));
          return Future.value(false);
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 2.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("End User License Agreement",
                          style: TextStyle(fontSize: 30.0)),
                      SizedBox(height: 15.0),
                      Container(
                        height: 450.0,
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: kSymetricalHorz,
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                  child: Text("")),
                              SizedBox(
                                height: 20.0,
                              ),
                              Consumer<TrainerSignUpData>(
                                builder: (context, data, child) {
                                  return RadioButton(
                                    text:
                                        "By clicking you agree to the terms and conditions above.",
                                    color: data.trainerData.agreed == true
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).accentColor,
                                    pressed: () {
                                      data.trainerData.agreed == false
                                          ? data.trainerData.agreed = true
                                          : data.trainerData.agreed = false;
                                      print(data.trainerData.agreed);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<TrainerSignUpData>(
                        builder: (context, data, child) {
                          return SquareButton(
                              color: data.trainerData.agreed == true
                                  ? Theme.of(context).toggleableActiveColor
                                  : Theme.of(context).shadowColor,
                              pressed: data.trainerData.agreed == true
                                  ? () async {
                                      var Dialog = FutureBuilder(
                                        future: data.trainerData.eulaaccept({
                                          "id": data.trainerData.data["_id"],
                                          "eulaaccept": true
                                        }),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data == true) {
                                                WidgetsBinding.instance
                                                    ?.addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          TrainerMainMenu.id);
                                                });
                                                return Container();
                                              } else {
                                                return CustomAlertBox(
                                                  infolist: <Widget>[
                                                    Text(
                                                        "An error has occured. Please try again later."),
                                                  ],
                                                  actionlist: <Widget>[
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        WidgetsBinding.instance
                                                            ?.addPostFrameCallback(
                                                                (timeStamp) {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        });
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
                                      // final res =  await data.trainerData.eulaaccept({
                                      //     "id":data.trainerData.data["_id"],
                                      //     "eulaaccept":true
                                      //   });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog);
                                    }
                                  : null,
                              butContent: Text('Proceed',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              buttonwidth: 180.0);
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
