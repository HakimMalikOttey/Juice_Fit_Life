import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/small_loading_indicator.dart';
import 'package:jfl2/data/member_sign_up_data.dart';

class UserNameInfo extends StatefulWidget {
  static String id = "UserNameInfo";
  final MemberSignupData? user;
  final Function(bool condition)? validate;
  UserNameInfo({@required this.user, this.validate});
  @override
  _UserNameInfoState createState() => _UserNameInfoState();
}

class _UserNameInfoState extends State<UserNameInfo> {
  var time;
  Timer? clock;
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      widget.validate!(widget.user!.UsernameValidator());
    });
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Set Your Username",
                    style: Theme.of(context).textTheme.headline3),
                Text(
                    "Create the screen name that will be shown on your Juice Fit Life Profile!",
                    style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.userName,
                    hintText: 'Username',
                    onChanged: (text) {
                      widget.user!.freeusername = null;
                      // data.trainerData.userName = text;
                      widget.user!.userNameOperation?.cancel();
                      widget.user!.userNameOperation =
                          CancelableOperation.fromFuture(Future.delayed(
                              Duration(milliseconds: 1), () async {
                        if (widget.user!.userName != null ||
                            widget.user!.userName.text != "") {
                          widget.user!.freeusername = await widget.user!
                              .checkUsername({
                            "username": widget.user?.userName.text.trim()
                          });
                        }
                      }));
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(child: new Builder(builder: (context) {
                      var usernameavailable = widget.user!.freeusername;
                      var usernameentry = widget.user!.userName;
                      if (usernameentry.text.isEmpty) {
                        return Container();
                      } else if (usernameavailable == false) {
                        return Text("Username is Available",
                            style: Theme.of(context).textTheme.headline5);
                      } else if (usernameavailable == true) {
                        return Text("Username is taken",
                            style: Theme.of(context).textTheme.headline4);
                      } else if (usernameavailable == null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Checking Username Availability...",
                                style: Theme.of(context).textTheme.headline1),
                            SizedBox(
                              width: 20.0,
                            ),
                            SmallLoadingIndicator()
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    })),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
