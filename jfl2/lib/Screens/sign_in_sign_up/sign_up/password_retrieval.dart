import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/code_input.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/email_password.dart';

class PasswordRetrieval extends StatefulWidget {
  static String id = "PasswordRetrieval";
  @override
  _PasswordRetrievalState createState() => _PasswordRetrievalState();
}

class _PasswordRetrievalState extends State<PasswordRetrieval> {
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Type in your email. If this email is used with an account, we will send an email telling you your next steps in resetting your password.",
          style: Theme.of(context).textTheme.headline1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CustomTextBox(
            show: true,
            controller: emailController,
            hintText: "Email",
            onChanged: (text) {
              // data.name = text;
            },
          ),
        ),
        SquareButton(
            elevation: 0.0,
            color: Colors.white,
            pressed: () async {
              print(emailController.text);
              showDialog(
                  context: context,
                  builder: (context) => LoadingDialog(
                        errorRoutine: (data) {
                          return CustomAlertBox(
                            infolist: <Widget>[
                              Text(
                                  "There was an error doing this operation. Please try again later.")
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
                        failedRoutine: (data) {
                          return CustomAlertBox(
                            infolist: <Widget>[
                              Text(
                                  "We could not send you a password reset email. Please try again.")
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
                          return CustomAlertBox(
                            infolist: <Widget>[
                              Text(
                                  "Check your email. If you don't recieve it within an hour, check to see if the email you typed was correct.")
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
                        future: emailPassword
                            .emailpass(emailController.text.trim()),
                      ));
            },
            butContent: Text('Send Email',
                style: Theme.of(context).textTheme.headline2),
            buttonwidth: MediaQuery.of(context).size.width),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CodeInput.id);
            },
            child: Text(
              "Already have a pin?",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
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
