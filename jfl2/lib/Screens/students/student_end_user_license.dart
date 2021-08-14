import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/Student_Main_Menu.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/log_out_box.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:provider/provider.dart';

class StudentEndUserLicense extends StatefulWidget {
  static String id = 'MemberEndUserLicense';

  @override
  _StudentEndUserLicense createState() => _StudentEndUserLicense();
}

class _StudentEndUserLicense extends State<StudentEndUserLicense> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text('Student Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => LogOutBox(
                      pressed: () {
                        // Provider.of<CheckAccount>(context, listen: false).resetdata();
                        Provider.of<StudentSignUpData>(context, listen: false)
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
                      Provider.of<StudentSignUpData>(context, listen: false)
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                  child: Text("")),
                              SizedBox(
                                height: 20.0,
                              ),
                              Consumer<StudentSignUpData>(
                                builder: (context, data, child) {
                                  return RadioButton(
                                    text:
                                        "By clicking you agree to the terms and conditions above.",
                                    color: data.studentData.agreed == true
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).accentColor,
                                    pressed: () {
                                      data.studentData.agreed == false
                                          ? data.studentData.agreed = true
                                          : data.studentData.agreed = false;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<StudentSignUpData>(
                        builder: (context, data, child) {
                          return SquareButton(
                              color: data.studentData.agreed == true
                                  ? Theme.of(context).toggleableActiveColor
                                  : Theme.of(context).shadowColor,
                              pressed: data.studentData.agreed == true
                                  ? () async {
                                      final res = await data.studentData
                                          .eulaaccept({
                                        "id": data.studentData.data["_id"],
                                        "eulaaccept": true
                                      });
                                      if (res == true) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            StudentMainMenu.id,
                                            (r) => false);
                                      } else {
                                        var baseDialog = CustomAlertBox(
                                          infolist: <Widget>[
                                            Text(
                                                "An error has occured. Please try again later."),
                                          ],
                                          actionlist: <Widget>[
                                            FlatButton(
                                              child: Text("Ok"),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop(false);
                                              },
                                            )
                                          ],
                                        );
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                baseDialog);
                                      }
                                    }
                                  : null,
                              butContent: Text('Create Account',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              buttonwidth: 400.0);
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
