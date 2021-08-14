import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/plan_info.dart';
import 'package:jfl2/Screens/students/plans_wrapper.dart';
import 'package:jfl2/Screens/students/plans_upcoming.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_in.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/log_out_box.dart';
import 'package:jfl2/components/plan_banner.dart';
import 'package:jfl2/data/plan_data.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/Screens/start.dart';
import 'package:jfl2/data/student_sign_up_data.dart';

class StudentMainMenu extends StatefulWidget {
  static String id = "UserMainMenu";

  _StudentMainMenu createState() => _StudentMainMenu();
}

class _StudentMainMenu extends State<StudentMainMenu> {
  int currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: currentpage == 0
            ? Text("Dashboard - Available Plans")
            : Text("Dashboard - Your Plans"),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
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
          child: Consumer<PlanData>(builder: (context, data, child) {
            if (currentpage == 0) {
              return Center(
                child: new ListView.builder(
                    itemCount: data.plans.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          PlanBanner(
                            calltoaction: Text("Learn More..."),
                            description: Text("Plan Description Here"),
                            name: data.plans[index]["name"],
                            author: data.plans[index]["author"],
                            img: data.plans[index]["picture"],
                            pressed: () {
                              // Navigator.push(
                              //   context,
                              //     MaterialPageRoute( builder: (context) => PlanInfo(),
                              //         settings: RouteSettings(
                              //             arguments: {"name": data.plans[index]["name"]}
                              //         ))
                              // );
                              Navigator.of(context)
                                  .pushNamed(PlanInfo.id, arguments: {
                                "data": data.plans[index]["name"],
                                "auth": data.plans[index]["author"],
                                "intro": "",
                                "authInfo": "",
                                "comments": "",
                                "picture": ""
                              });
                              print(index);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      );
                    }),
              );
            } else {
              return Center(
                child: new ListView.builder(
                    itemCount: data.plans.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          PlanBanner(
                            boughtdate: Text(
                              "Bought on 10/03/1999",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            name: data.plans[index]["name"],
                            author: data.plans[index]["author"],
                            img: data.plans[index]["picture"],
                            pressed: () {
                              Navigator.of(context).pushNamed(PlansWrapper.id);
                              print(index);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      );
                    }),
              );
            }
          }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          FooterButton(
            color: currentpage == 0
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            text:
                Text("Available Plans", style: TextStyle(color: Colors.white)),
            action: () {
              setState(() {
                currentpage = 0;
              });
            },
          ),
          FooterButton(
            color: currentpage == 1
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            text: Text("My Plans", style: TextStyle(color: Colors.white)),
            action: () {
              setState(() {
                currentpage = 1;
              });
            },
          ),
        ],
      )),
    );
  }
}
// PlanBanner(
// name:data.plans[index]["name"],
// author:data.plans[index]["author"],
// img: data.plans[index]["picture"],
// pressed: (){
// Navigator.of(context).pushNamed(PlansUpcoming.id);
// print(index);
// }
// ),