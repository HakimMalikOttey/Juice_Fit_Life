import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/client_profile.dart';
import 'package:jfl2/components/trainer_drawer.dart';

import '../../components/square_button.dart';
import '../../components/square_button.dart';

class TrainerYourClients extends StatefulWidget{
  static String id = "TrainerYourClients";
  @override
  _TrainerYourClients createState() => _TrainerYourClients();
}

class _TrainerYourClients extends State<TrainerYourClients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: ListView(
            children: [
                SquareButton(
                    color: Colors.white,
                    pressed: (){
                      Navigator.pushNamed(context, ClientProfile.id);
                    },
                    butContent: Row(
                      children: [
                        Expanded(child: Text("Roberto Davis")),
                        Text("Get Big")
                      ],
                    ),
                    buttonwidth: 320.0
                ),
            ],
          ),
        ),
      ),
    );
  }
}