import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/small_loading_indicator.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';

class ContactInfo extends StatefulWidget {
  final MemberSignupData? user;
  static String id = "ContactInfo";
  final Function(bool condition)? validate;
  ContactInfo({@required this.user, this.validate});
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  var time;
  Timer? clock;
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      widget.validate!(widget.user!.ContactValidator());
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
    TextEditingController text = new TextEditingController();
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Info",
                    style: Theme.of(context).textTheme.headline3),
                Text("Tell us how we should contact you!",
                    style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextBox(
                    show: true,
                    controller: widget.user!.email,
                    hintText: 'Email',
                    onChanged: (text) {
                      widget.user!.validEmail = EmailValidator.validate(text);
                      if (EmailValidator.validate(text) == true) {
                        widget.user!.emailOperation?.cancel();
                        widget.user!.freeemail = null;
                        // print("IsValid:${EmailValidator.validate(text)}");
                        // assert(EmailValidator.validate(text));
                        setState(() {
                          widget.user!.emailOperation =
                              CancelableOperation.fromFuture(Future.delayed(
                                  Duration(seconds: 1), () async {
                            if (widget.user!.email.text != "") {
                              widget.user!.freeemail = await widget.user!
                                  .checkEmail(
                                      {"email": widget.user!.email.text});
                            }
                          }));
                        });
                      } else {
                        setState(() {});
                      }
                      // widget.user.email.text = text;
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(child: new Builder(builder: (context) {
                      if (widget.user!.email.text.isEmpty) {
                        return Container();
                      } else if (widget.user!.validEmail == false) {
                        return Text("Please place in a valid email.",
                            style: Theme.of(context).textTheme.headline4);
                      } else if (widget.user!.email.text != "" &&
                          widget.user!.freeemail == false) {
                        return Text("Email is available!",
                            style: Theme.of(context).textTheme.headline5);
                      } else if (widget.user!.freeemail == true) {
                        return Text("Email is Taken.",
                            style: Theme.of(context).textTheme.headline4);
                      } else if (widget.user!.freeemail == null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Checking Email Availability...",
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
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (text) {
                        widget.user!.extension = text.dialCode!;
                      },
                      initialSelection: 'IT',
                      favorite: ['+39', 'FR'],
                      showCountryOnly: false,
                      backgroundColor: Theme.of(context).shadowColor,
                      dialogBackgroundColor: Theme.of(context).shadowColor,
                      barrierColor: Theme.of(context).shadowColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CustomTextBox(
                          show: true,
                          controller: widget.user!.phone,
                          hintText: 'Phone Number',
                          onChanged: (text) {
                            // data.name = text;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
