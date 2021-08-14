import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_dropdown_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/member_sign_up_data.dart';

class UserPersonalInfo extends StatefulWidget {
  final MemberSignupData? user;
  static String id = "UserPersonalInfo";
  final Function(bool condition)? validate;
  UserPersonalInfo({@required this.user, @required this.validate});
  @override
  _UserPersonalInfoState createState() => _UserPersonalInfoState();
}

class _UserPersonalInfoState extends State<UserPersonalInfo> {
  TextEditingController text = new TextEditingController();
  var time;
  Timer? clock;
  String genderValue = "Select A Gender";
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      widget.validate!(widget.user!.PersonalValidator());
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
                Text(
                  "Personal Info",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "Give us information on what makes you, you!",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user?.fName ?? text,
                    hintText: 'First Name',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.lName,
                    hintText: 'Last Name',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    maxlength: 20,
                    show: true,
                    controller: widget.user!.nickName,
                    hintText: 'Nickname',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Text(
                  "Your Gender",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomDropdownBox(
                    value: widget.user!.gender,
                    items: widget.user!.genderList,
                    onChanged: (value) {
                      setState(() {
                        widget.user!.gender = value!;
                      });
                    },
                  ),
                ),
                Text(
                  "Your Birthday",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      final picker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      setState(() {
                        widget.user!.bDay = picker!.day;
                        widget.user!.bMonth = picker.month;
                        widget.user!.bYear = picker.year;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).cardColor,
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              widget.user!.bDay == null
                                  ? 'Select Birthday'
                                  : "${widget.user!.bYear}" +
                                      "/" +
                                      "${widget.user!.bMonth}" +
                                      "/" +
                                      "${widget.user!.bDay}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Set Your Address",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    GestureDetector(
                        onTap: () async {
                          bool serviceEnabled;
                          LocationPermission permission;
                          serviceEnabled =
                              await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            print("Location services are disabled");
                          } else {
                            permission = await Geolocator.requestPermission();
                            if (permission ==
                                LocationPermission.deniedForever) {
                              print("Denied Forever");
                            } else if (permission ==
                                LocationPermission.denied) {
                              print("Denied");
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => LoadingDialog(
                                        future: Geolocator.getCurrentPosition(),
                                        successRoutine: (data) {
                                          WidgetsBinding.instance
                                              ?.addPostFrameCallback((_) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop(true);
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    LoadingDialog(
                                                        future:
                                                            placemarkFromCoordinates(
                                                                data.data
                                                                    .latitude,
                                                                data.data
                                                                    .longitude),
                                                        successRoutine: (data) {
                                                          return CustomAlertBox(
                                                            infolist: <Widget>[
                                                              Text(
                                                                  "Address has been retrieved.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Placemark
                                                                        place =
                                                                        data.data[
                                                                            0];
                                                                    widget
                                                                            .user!
                                                                            .strName
                                                                            .text =
                                                                        place
                                                                            .street!;
                                                                    widget
                                                                            .user!
                                                                            .city
                                                                            .text =
                                                                        place
                                                                            .subLocality!;
                                                                    widget
                                                                            .user!
                                                                            .state
                                                                            .text =
                                                                        place
                                                                            .administrativeArea!;
                                                                    widget
                                                                            .user!
                                                                            .country
                                                                            .text =
                                                                        place
                                                                            .country!;
                                                                    widget
                                                                            .user!
                                                                            .zip
                                                                            .text =
                                                                        place
                                                                            .postalCode!;
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        },
                                                        failedRoutine: (data) {
                                                          return CustomAlertBox(
                                                            infolist: <Widget>[
                                                              Text(
                                                                  "We were unable to get your current address. Please type it in manually.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            true);
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
                                                                  "There was an error retrieving your current address. Please type it in manually.")
                                                            ],
                                                            actionlist: <
                                                                Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        }));
                                          });
                                          return Container(
                                              width: 0.0, height: 0.0);
                                        },
                                        errorRoutine: (data) {
                                          return CustomAlertBox(
                                            infolist: <Widget>[
                                              Text(
                                                  "There was an error retrieving your current address. Please type it in manually.")
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
                                        failedRoutine: (data) {
                                          return CustomAlertBox(
                                            infolist: <Widget>[
                                              Text(
                                                  "We were unable to get your current address. Please type it in manually.")
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

                              // var location =
                              //     await Geolocator.getCurrentPosition();
                            }
                          }
                        },
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Theme.of(context).accentColor,
                          size: 35.0,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.strName,
                    hintText: 'Street Name',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.city,
                    hintText: 'City',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.state,
                    hintText: 'State',
                    onChanged: (text) {
                      // data.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: CustomTextBox(
                        show: true,
                        controller: widget.user!.country,
                        hintText: 'Country',
                        onChanged: (text) {
                          // data.name = text;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: CustomTextBox(
                        show: true,
                        controller: widget.user!.zip,
                        hintText: 'ZIP',
                        onChanged: (text) {
                          // data.name = text;
                        },
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
