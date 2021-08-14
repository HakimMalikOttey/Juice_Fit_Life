import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_info.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/check_code.dart';
import 'package:jfl2/data/member_sign_up_data.dart';

class CodeInput extends StatefulWidget {
  static String id = "CodeInput";
  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  TextEditingController codeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type in the 5 digit code that you have recieved within your email.",
          style: Theme.of(context).textTheme.headline1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CustomTextBox(
            show: true,
            controller: codeController,
            hintText: "Code",
            onChanged: (text) {
              // data.name = text;
            },
          ),
        ),
        SquareButton(
            elevation: 0.0,
            color: Colors.white,
            pressed: () async {
              showDialog(
                  context: context,
                  builder: (context) => LoadingDialog(
                        future: checkCode.codeCheck(codeController.text.trim()),
                        failedRoutine: (data) {
                          return CustomAlertBox(
                            infolist: <Widget>[
                              Text(
                                  "This code is either incorrect, expired, or does not exist. Please try sending another code to your email.")
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
                                  "There was an error in checking for this code. Please try again later.")
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
                          WidgetsBinding.instance
                              ?.addPostFrameCallback((timeStamp) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, PasswordInfo.id,
                                arguments: {
                                  "Userid": data.data,
                                  "user": new MemberSignupData(),
                                  "reset": true,
                                });
                          });
                        },
                      ));
              // Navigator.of(context).pop();
            },
            butContent: Text('Check Code',
                style: Theme.of(context).textTheme.headline2),
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
