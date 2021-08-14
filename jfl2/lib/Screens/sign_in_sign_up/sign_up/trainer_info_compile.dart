import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/End_User_License.dart';
import 'package:jfl2/Screens/trainers/Trainer_Main_Menu.dart';
import 'package:jfl2/Screens/trainers/trainer_menu_wrappers.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/review_box.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/hash.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

class TrainerInfoCompile extends StatefulWidget {
  static String id = "TrainerInfoCompile";
  final Function(int index)? edit;
  TrainerInfoCompile({this.edit});
  @override
  _TrainerInfoCompileState createState() => _TrainerInfoCompileState();
}

class _TrainerInfoCompileState extends State<TrainerInfoCompile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Consumer<TrainerSignUpData>(
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
                              "Full Name: ${data.trainerData.fName.text} ${data.trainerData.lName.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Alt/Nickname: ${data.trainerData.nickName.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Gender: ${data.trainerData.gender}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Birthday: ${data.trainerData.bYear}/${data.trainerData.bMonth}/${data.trainerData.bDay}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Address: ${data.trainerData.strName.text},${data.trainerData.city.text},${data.trainerData.state.text},${data.trainerData.country.text},${data.trainerData.zip.text}",
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
                              "Email: ${data.trainerData.email.text}",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Phone Number: ${data.trainerData.extension}${data.trainerData.phone.text}",
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
                              "Username: ${data.trainerData.userName.text}",
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
                            controller: data.trainerData.password,
                            hintText: 'Password',
                            onChanged: (text) {},
                          ),
                          // child: Text(
                          //   "Password: ${data.trainerData.password.text}",
                          //   style: Theme.of(context).textTheme.headline1,
                          // ),
                        ),
                      ],
                    ),
                  ),
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
                                      future: data.trainerData.uploadfile({
                                        "fName":
                                            data.trainerData.fName.text.trim(),
                                        "lName":
                                            data.trainerData.lName.text.trim(),
                                        "nName": data.trainerData.nickName.text
                                            .trim(),
                                        "uName": data.trainerData.userName.text
                                            .trim(),
                                        "bDay": int.parse(
                                            data.trainerData.bDay.toString()),
                                        "bMonth": int.parse(
                                            data.trainerData.bMonth.toString()),
                                        "bYear": int.parse(
                                            data.trainerData.bYear.toString()),
                                        "gender": data.trainerData.gender,
                                        "phone":
                                            "${data.trainerData.extension}${data.trainerData.phone.text}",
                                        "email":
                                            data.trainerData.email.text.trim(),
                                        "password": hash
                                            .hashpass(data
                                                .trainerData.password.text
                                                .trim())
                                            .toString(),
                                        "profpic": "",
                                        "street": data.trainerData.strName.text
                                            .trim(),
                                        "city":
                                            data.trainerData.city.text.trim(),
                                        "state":
                                            data.trainerData.state.text.trim(),
                                        "country": data.trainerData.country.text
                                            .trim(),
                                        "zip": data.trainerData.zip.text.trim(),
                                        "usertype": "trainer",
                                        "eulaAccept": false,
                                      }),
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
                                                          TrainerMenuWrapper
                                                              .id);
                                                },
                                                child: Text("Ok"))
                                          ],
                                        );
                                      },
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
                                    ));
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                           showDialog(
                              context: context,
                              builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      leading: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    body: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                  child: Text(""))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // body: Container(
                                    //       height: MediaQuery.of(context).size.height,
                                    //       width: MediaQuery.of(context).size.width,
                                    //       color: Theme.of(context).shadowColor,
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.all(8.0),
                                    //         child: Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             IconButton(
                                    //               icon: Icon(
                                    //                 Icons.close_outlined,
                                    //                 color: Colors.white,
                                    //               ),
                                    //               onPressed: () {},
                                    //             ),
                                    //             // Icon(
                                    //             //   Icons.close_outlined,
                                    //             //   color: Colors.white,
                                    //             // )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                  ));
                          // Navigator.pushReplacementNamed(
                          //     context, TrainerEndUserLicense.id);
                        },
                        child: Container(
                          height: 20.0,
                          child: Text(
                              "By creating an account, you are agreeing to our Terms of Service"),
                        ),
                      ),
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
