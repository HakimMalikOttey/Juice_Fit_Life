import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'package:jfl2/Screens/trainers/trainer_notifications.dart';
import 'package:jfl2/Screens/trainers/trainer_your_clients.dart';
import 'package:jfl2/Screens/trainers/trainer_your_plans.dart';
import 'package:jfl2/Screens/trainers/trainer_your_sessions.dart';
import 'package:jfl2/components/log_out_box.dart';
import 'package:jfl2/components/trainer_drawer.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';
class TrainerMainMenu extends StatefulWidget{
  static String id = "TrainerMainMenu";
  _TrainerMainMenu createState() => _TrainerMainMenu();
}

class _TrainerMainMenu extends State<TrainerMainMenu>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          return Future.value(false);
          // return showDialog(context: context, builder: (BuildContext context) => LogOutBox(
          //   pressed: () {
          //     Provider.of<SignInData>(context, listen: false).resetdata();
          //     Provider.of<TrainerSignUpData>(context, listen: false).resetData();
          //     Navigator.pop(context);
          //     Navigator.pushReplacementNamed(context, StartWrapper.id);
          //   },
          // ));
        },
        child: SafeArea(
          child: Consumer<TrainerSignUpData>(builder: (context, data, child) {
            return Center(
            );
    }
        ),
    ),
      ));
  }

}