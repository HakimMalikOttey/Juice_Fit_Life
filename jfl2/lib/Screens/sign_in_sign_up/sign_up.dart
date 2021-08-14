import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/sign_up_wrapper.dart';
import 'package:jfl2/Screens/students/student_sign_up.dart';
import 'package:jfl2/Screens/sign_in_sign_up/general_sign_up.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/constants.dart';

class SignUp extends StatefulWidget {
  static String id = "SignUp";
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SquareButton(
            color: Theme.of(context).accentColor,
            pressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(SignUpWrapper.id, arguments: {"userType": 0});
            },
            butContent: Text('Student Sign Up',
                style: Theme.of(context).textTheme.headline2),
            buttonwidth: MediaQuery.of(context).size.width),
        SquareButton(
            elevation: 0.0,
            color: Colors.deepOrange,
            pressed: () {
              // Navigator.of(context,rootNavigator: true).pushNamed(GeneralSignUp.id,arguments: {
              //   "setting":"create",
              //   "type": "trainer"
              // });
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(SignUpWrapper.id, arguments: {"userType": 1});
            },
            butContent: Text('Trainer Sign Up',
                style: Theme.of(context).textTheme.headline1),
            buttonwidth: MediaQuery.of(context).size.width),
        Expanded(child: SizedBox()),
        SquareButton(
            elevation: 0.0,
            color: Colors.black,
            pressed: () {
              Navigator.of(context).pop();
            },
            butContent:
                Text('Back', style: Theme.of(context).textTheme.headline1),
            buttonwidth: MediaQuery.of(context).size.width),
      ],
    );
  }
}
