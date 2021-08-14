import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/Screens/trainers/trainer_notifications.dart';
import 'package:jfl2/Screens/trainers/plan_maker_wrapper.dart';
import 'package:jfl2/Screens/sign_in_sign_up/general_sign_up.dart';
import 'package:jfl2/Screens/trainers/trainer_settings.dart';
import 'package:jfl2/Screens/trainers/trainer_your_clients.dart';
import 'package:jfl2/Screens/trainers/trainer_your_plans.dart';
import 'package:jfl2/Screens/trainers/trainer_your_sessions.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

import '../Screens/trainers/Trainer_Main_Menu.dart';
import 'log_out_box.dart';

class TrainerDrawer extends StatelessWidget {
  final navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  TrainerDrawer({required this.navigatorKey, required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerTheme: DividerThemeData(thickness: 0.0)),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/weights.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.matrix(<double>[
                          0.2126,
                          0.250,
                          0.070,
                          0,
                          -55,
                          0.2126,
                          0.250,
                          0.070,
                          0,
                          -55,
                          0.2126,
                          0.250,
                          0.070,
                          0,
                          -55,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ]))),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, GeneralSignUp.id,
                        arguments: {"type": true});
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: 100.0,
                      //   height: 100.0,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //         image: NetworkImage(
                      //             Provider.of<TrainerSignUpData>(context,
                      //                     listen: false)
                      //                 .trainerData
                      //                 .data["profpic"]),
                      //         fit: BoxFit.cover,
                      //       ),
                      //       border: Border.all(color: Colors.white)),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["username"]}",
                            //   style: Theme.of(context).textTheme.headline3,
                            // ),
                            // Text(
                            //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["fname"]} ${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["lname"]}",
                            //   style: Theme.of(context).textTheme.headline6,
                            // ),
                            // Text(
                            //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["email"]}",
                            //   style: Theme.of(context).textTheme.headline1,
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Dashboard'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  navigatorKey.currentState.pushNamed(TrainerMainMenu.id);
                },
              ),
              ListTile(
                title: Text('Your Plans'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  navigatorKey.currentState.pushNamed(
                    TrainerPlanMakerWrapper.id,
                  );
                },
              ),
              ListTile(
                title: Text('Your Clients'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  navigatorKey.currentState.pushNamed(TrainerYourClients.id);
                },
              ),
              ListTile(
                title: Text('Your Sessions'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  navigatorKey.currentState.pushNamed(TrainerYourSessions.id);
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  navigatorKey.currentState.pushNamed(TrainerSettings.id);
                },
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => LogOutBox(
                            pressed: () {
                              // Provider.of<CheckAccount>(context, listen: false)
                              //     .resetdata();
                              Provider.of<TrainerSignUpData>(context,
                                      listen: false)
                                  .resetData();
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, StartWrapper.id);
                            },
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
