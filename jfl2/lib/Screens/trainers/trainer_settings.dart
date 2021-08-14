import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/linked_accounts.dart';
import 'package:jfl2/components/trainer_drawer.dart';

class TrainerSettings extends StatefulWidget {
  static String id = "TrainerSettings";
  @override
  _TrainerSettings createState() => _TrainerSettings();
}

class _TrainerSettings extends State<TrainerSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            child: ListTile(
              title: Text(
                'Linked Accounts',
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(LinkedAccounts.id);
                // scaffoldKey.currentState.openEndDrawer();
                // navigatorKey.currentState.pushNamed(TrainerMainMenu.id);
              },
            ),
          ),
        ],
      )),
    );
  }
}
