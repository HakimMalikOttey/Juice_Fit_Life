import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/Student_Main_Menu.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/Screens/students/student_menu_wrapper.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/review_box.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/hash.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class StudentInfoCompile extends StatefulWidget {
  static String id = "StudentInfoCompile";
  final Function(int index)? edit;
  StudentInfoCompile({this.edit});
  @override
  _StudentInfoCompileState createState() => _StudentInfoCompileState();
}

class _StudentInfoCompileState extends State<StudentInfoCompile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Consumer<StudentSignUpData>(
            builder: (context, data, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Review Your Information",
                        style: Theme.of(context).textTheme.headline3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ReviewBox(
                      edit: () {
                        widget.edit!(0);
                      },
                      // index: 0,
                      label: "Personal Information",
                      items: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Full Name: ${data.studentData.fName.text} ${data.studentData.lName.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Alt/Nickname: ${data.studentData.nickName.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Gender: ${data.studentData.gender}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Birthday: ${data.studentData.bYear}/${data.studentData.bMonth}/${data.studentData.bDay}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Address: ${data.studentData.strName.text},${data.studentData.city.text},${data.studentData.state.text},${data.studentData.country.text},${data.studentData.zip.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ReviewBox(
                      edit: () {
                        widget.edit!(1);
                      },
                      // index: 1,
                      label: "Contact Information",
                      items: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Email: ${data.studentData.email.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Phone Number: ${data.studentData.extension}${data.studentData.phone.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      )),
                  ReviewBox(
                      edit: () {
                        widget.edit!(2);
                      },
                      // index: 2,
                      label: "Username",
                      items: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Username: ${data.studentData.userName.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      )),
                  ReviewBox(
                    edit: () {
                      widget.edit!(3);
                    },
                    // index: 3,
                    label: "Password",
                    items: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomTextBox(
                            obscureText: true,
                            enableSuggestions: false,
                            autoCorrect: false,
                            show: true,
                            active: false,
                            controller: data.studentData.password,
                            hintText: 'Password',
                            onChanged: (text) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  ReviewBox(
                      edit: () {
                        widget.edit!(4);
                      },
                      // index: 4,
                      label: "Body and Goals",
                      items: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Weight: ${data.weight.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Height: ${data.height.text} Feet, ${data.inches.text} Inches",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Activity Rating: ${data.activelevel}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Fitness Goal: ${data.goalChoice}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: FooterButton(
                          color: Colors.green,
                          text: Column(
                            children: [
                              Text(
                                "Create Your Account",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          action: () {
                            hasher hash = new hasher();
                            showDialog(
                                context: context,
                                builder: (context) => LoadingDialog(
                                      future: data.studentData.uploadfile({
                                        "fName":
                                            data.studentData.fName.text.trim(),
                                        "lName":
                                            data.studentData.lName.text.trim(),
                                        "nName": data.studentData.nickName.text
                                            .trim(),
                                        "uName": data.studentData.userName.text
                                            .trim(),
                                        "phone": data.studentData.extension +
                                            data.studentData.phone.text.trim(),
                                        "bDay": int.parse(
                                            data.studentData.bDay.toString()),
                                        "bMonth": int.parse(
                                            data.studentData.bMonth.toString()),
                                        "bYear": int.parse(
                                            data.studentData.bYear.toString()),
                                        "gender": data.studentData.gender,
                                        "email": data.studentData.email.text,
                                        "password": hash
                                            .hashpass(data
                                                .studentData.password.text
                                                .trim())
                                            .toString(),
                                        "street": data.studentData.strName.text
                                            .trim(),
                                        "city":
                                            data.studentData.city.text.trim(),
                                        "state":
                                            data.studentData.state.text.trim(),
                                        "country": data.studentData.country.text
                                            .trim(),
                                        "zip": data.studentData.zip.text.trim(),
                                        "usertype": "student",
                                        "weight": double.parse(data.weight.text
                                            .replaceAll(RegExp(','), '')),
                                        "height": double.parse(data.height.text
                                            .replaceAll(RegExp(','), '')),
                                        "inches": double.parse(data.inches.text
                                            .replaceAll(RegExp(','), '')),
                                        "activelevel": data.activelevel,
                                        "goals": data.goalList.indexWhere(
                                            (element) =>
                                                element == data.goalChoice),
                                        "eulaAccept": true,
                                      }),
                                      errorRoutine: (data) {
                                        return CustomAlertBox(
                                          infolist: <Widget>[
                                            Text(
                                                "A major error has occured while creating your account. Please try again later.")
                                          ],
                                          actionlist: <Widget>[
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(true);
                                                },
                                                child: Text("Ok"))
                                          ],
                                        );
                                      },
                                      successRoutine: (data) {
                                        return CustomAlertBox(
                                          infolist: <Widget>[
                                            Text(
                                                "Your account has been successfully created!")
                                          ],
                                          actionlist: <Widget>[
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Provider.of<UserData>(context,listen: false).id = jsonDecode(data.data)["_id"];
                                                  Navigator.pop(context);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pushReplacementNamed(
                                                          StudentMenuWrapper
                                                              .id);
                                                },
                                                child: Text("Ok"))
                                          ],
                                        );
                                      },
                                      failedRoutine: (data) {
                                        return CustomAlertBox(
                                          infolist: <Widget>[
                                            Text(
                                                "There was an error creating your account.Please check your username and password. If the problem persists, please try again later.")
                                          ],
                                          actionlist: <Widget>[
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pushReplacementNamed(
                                                          StudentMainMenu.id);
                                                },
                                                child: Text("Ok"))
                                          ],
                                        );
                                      },
                                    ));
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: Text(
                          "By creating an account, you are agreeing to our Terms of Service"),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
