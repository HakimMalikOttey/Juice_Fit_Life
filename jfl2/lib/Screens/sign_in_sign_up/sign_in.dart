import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_retrieval.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/Screens/students/student_menu_wrapper.dart';
import 'package:jfl2/Screens/trainers/End_User_License.dart';
import 'package:jfl2/Screens/students/Student_Main_Menu.dart';
import 'package:jfl2/Screens/trainers/trainer_menu_wrappers.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/log_out_box.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/Screens/trainers/Trainer_Main_Menu.dart';
import 'package:jfl2/Screens/sign_in_sign_up/send_email.dart';
import 'package:jfl2/data/hash.dart';

class SignIn extends StatefulWidget {
  static String id = 'signIn';

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomTextBox(
        show: true,
        controller: userName,
        labelText: "Username/Password",
        onChanged: (text) {
          // data.name = text;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      CustomTextBox(
        obscureText: true,
        enableSuggestions: false,
        autoCorrect: false,
        show: true,
        controller: password,
        labelText: "Password",
        onChanged: (text) {
          // data.password = text;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      SquareButton(
        butContent:
            Text('Sign In', style: Theme.of(context).textTheme.headline2),
        buttonwidth: MediaQuery.of(context).size.width,
        color: Colors.white,
        pressed: () {
          hasher hash = new hasher();
          showDialog(
              context: context,
              builder: (context) => LoadingDialog(
                    future: CheckAccount.checkUser(userName.text.trim(),
                        hash.hashpass(password.text.trim()).toString()),
                    failedRoutine: (data) {
                      return CustomAlertBox(
                        infolist: <Widget>[
                          Text(
                              "This account does not exist. Please check your username and password and try again.")
                        ],
                        actionlist: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    errorRoutine: (data) {
                      return CustomAlertBox(
                        infolist: <Widget>[
                          Text(
                              "There was a major error in searching for your account. Please try again later.")
                        ],
                        actionlist: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    successRoutine: (data) {
                      final userData = jsonDecode(data.data);
                      print(userData);
                      Provider.of<UserData>(context).id = userData["_id"];
                      Provider.of<UserData>(context).scope = userData["vimeo"] != null?
                          userData["vimeo"]["scope"] : "";
                      Provider.of<UserData>(context).name =userData["vimeo"] != null?
                          userData["vimeo"]["name"]:"";
                      Provider.of<UserData>(context).access_token =userData["vimeo"] != null?
                          userData["vimeo"]["access_token"]: "";
                      print(Provider.of<UserData>(context).name);
                      print(Provider.of<UserData>(context).scope);
                      print(Provider.of<UserData>(context).access_token);
                      if (jsonDecode(data.data)["userType"] == "trainer") {
                        WidgetsBinding.instance
                            ?.addPostFrameCallback((timeStamp) {
                          Navigator.pushReplacementNamed(
                              context, TrainerMenuWrapper.id);
                        });
                      } else {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          // Navigator.pushReplacementNamed(context, StudentMainMenu.id);
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacementNamed(StudentMenuWrapper.id);
                        });
                        // Timer.run(() {
                        //   Navigator.of(context,rootNavigator: true).pushNamed(StudentMainMenu.id);
                        // });

                      }
                      return Container();
                    },
                  ));
        },
      ),
      Center(
        child: Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 2.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Text("or", style: Theme.of(context).textTheme.headline1),
            ),
            Expanded(
              child: Divider(
                thickness: 2.0,
              ),
            ),
          ],
        ),
      ),
      SquareButton(
          color: Colors.deepOrange,
          pressed: () {
            print("reached");
            Navigator.of(context).pushNamed(SignUp.id);
          },
          butContent:
              Text('Sign Up', style: Theme.of(context).textTheme.headline1),
          buttonwidth: MediaQuery.of(context).size.width),
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(PasswordRetrieval.id);
            },
            child: Text("Forgot your password? Click Here!",
                style: Theme.of(context).textTheme.headline1),
          )
        ],
      )
    ]);
  }
}
