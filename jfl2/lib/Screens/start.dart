import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_in.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/square_button.dart';
import"package:jfl2/main.dart";
import 'package:jfl2/constants.dart';
class Start extends StatefulWidget{
  static String id = 'Start';
  @override
  _StartState createState()=> _StartState();
}
class _StartState extends State<Start>{
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
            padding:EdgeInsets.symmetric(horizontal:30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                  ),
                  SquareButton(
                    color:Theme.of(context).accentColor,
                    pressed: (){
                      Navigator.of(context).pushNamed(SignIn.id);
                    },
                    butContent: Text('Sign In', style: Theme.of(context).textTheme.headline2),
                    buttonwidth:150.0,
                  ),
                  SquareButton(
                    elevation: 0.0,
                    color:Theme.of(context).secondaryHeaderColor,
                    pressed: (){
                      Navigator.of(context).pushNamed(SignUp.id);
                      // Navigator.pushNamed();
                    },
                    butContent: Text('Sign Up', style: Theme.of(context).textTheme.headline1,
                    ),
                    buttonwidth:150.0,
                  )
                ],
              ),
            ),
          ),
    );
  }
}