import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/change_password.dart';
import 'package:jfl2/data/hash.dart';
import 'package:jfl2/data/member_sign_up_data.dart';

import '../start_wrapper.dart';

class PasswordInfo extends StatefulWidget {
  static String id = "PasswordInfo";
  final MemberSignupData? user;
  final Function(bool condition)? validate;
  final bool? reset;
  final String? Userid;
  PasswordInfo({@required this.user, this.validate, this.reset, this.Userid});
  @override
  _PasswordInfoState createState() => _PasswordInfoState();
}

class _PasswordInfoState extends State<PasswordInfo> {
  var time;
  Timer? clock;
  bool? validPass;
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    if (widget.reset == true) {
      clock = new Timer.periodic(time, (timer) {
        validPass = widget.user!.PasswordValidator();
      });
    } else {
      clock = new Timer.periodic(time, (timer) {
        widget.validate!(widget.user!.PasswordValidator());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.reset == true
          ? AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Text("Password Reset"),
              leading: IconButton(
                icon: Text("Cancel"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertBox(
                            infolist: <Widget>[
                              Text(
                                  "Canceling your password reset will return you to the main menu. You will not be able to use your code again to change your password. Are you sure that you want to quit?"),
                            ],
                            actionlist: <Widget>[
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  // Provider.of<MealPlanMakerData>(context, listen: false).mealname.clear();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(true);
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(false);
                                },
                              )
                            ],
                          ));
                  // return exitSignUp();
                },
              ),
            )
          : null,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Set Your Password",
                    style: Theme.of(context).textTheme.headline3),
                Text(
                    "Create a unique password that you will use to log into your account!",
                    style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    obscureText: true,
                    enableSuggestions: false,
                    autoCorrect: false,
                    show: true,
                    controller: widget.user!.password,
                    hintText: 'Password',
                    onChanged: (text) {
                      setState(() {
                        widget.user!.checkpassword();
                        // widget.user.password = text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Text("Your password must have:",
                        style: Theme.of(context).textTheme.headline1)
                  ],
                ),
                Builder(builder: (context) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text("12 characters minimum"),
                          Container(
                            child: widget.user!.islong == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 capital letter"),
                          Container(
                            child: widget.user!.hasUpper == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 lowercase letter"),
                          Container(
                            child: widget.user!.haslower == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("4 numbers minimum"),
                          Container(
                            child: widget.user!.hasDigits == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("At least 1 special character"),
                          Container(
                            child: widget.user!.hasspecial == false
                                ? Icon(Icons.close,
                                    color: Theme.of(context).errorColor)
                                : Icon(Icons.check,
                                    color: Theme.of(context)
                                        .toggleableActiveColor),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CustomTextBox(
                          obscureText: true,
                          enableSuggestions: false,
                          autoCorrect: false,
                          show: true,
                          controller: widget.user!.rPassword,
                          hintText: 'Repeat Password',
                          onChanged: (text) {
                            setState(() {});
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              if (widget.user!.rPassword.text != "" &&
                                  widget.user!.rPassword.text ==
                                      widget.user!.password.text) {
                                return Text("Password matches",
                                    style:
                                        Theme.of(context).textTheme.headline5);
                              } else if (widget.user!.rPassword.text != "" &&
                                  widget.user!.rPassword.text !=
                                      widget.user!.password.text) {
                                return Text("Password does not match",
                                    style:
                                        Theme.of(context).textTheme.headline4);
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                      Container(
                        child: widget.reset == true
                            ? Row(
                                children: [
                                  Expanded(
                                    child: widget.reset == true
                                        ? FooterButton(
                                            color: Colors.green,
                                            text: Column(
                                              children: [
                                                Text(
                                                  "Change Password",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                              ],
                                            ),
                                            action: () {
                                              hasher hash = new hasher();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      LoadingDialog(
                                                        future: ChangePassword
                                                            .changePass(
                                                                widget.Userid as String,
                                                                hash
                                                                    .hashpass(widget
                                                                        .user!
                                                                        .password
                                                                        .text
                                                                        .trim())
                                                                    .toString()),
                                                        failedRoutine: (data) {
                                                          return CustomAlertBox(
                                                            infolist: <Widget>[
                                                              Text(
                                                                  "We could not change the password for this account. Please try sending another code to your email.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        },
                                                        errorRoutine: (data) {
                                                          return CustomAlertBox(
                                                            infolist: <Widget>[
                                                              Text(
                                                                  "There was a major error changing the password for this account. Please try again later.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        },
                                                        successRoutine: (data) {
                                                          return CustomAlertBox(
                                                            infolist: <Widget>[
                                                              Text(
                                                                  "Your password has been sucessfuly changed.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pushReplacementNamed(
                                                                        context,
                                                                        StartWrapper
                                                                            .id);
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        },
                                                      ));
                                            },
                                          )
                                        : Row(
                                            children: [
                                              FooterButton(
                                                  text: Text(
                                                    "Change Password",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  color: Colors.grey)
                                            ],
                                          ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
