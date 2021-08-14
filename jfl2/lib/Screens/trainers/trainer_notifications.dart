import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/trainer_drawer.dart';

class TrainerNotifications extends StatefulWidget{
  static String id = "TrainerNotifications";
  @override
  _TrainerNotifications createState() => _TrainerNotifications();
}

class _TrainerNotifications extends State<TrainerNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: TrainerDrawer(),
      backgroundColor: Color(0xffE5DDDD),
      appBar: AppBar(
        title: Text("Notifications") ,
        backgroundColor: Color(0xff32416F),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     if(_scaffoldKey.currentState.isDrawerOpen == false){
        //       _scaffoldKey.currentState.openDrawer();
        //     }
        //     else{
        //       _scaffoldKey.currentState.openEndDrawer();
        //     }
        //   },
        // ),
      ),
    );
  }
}