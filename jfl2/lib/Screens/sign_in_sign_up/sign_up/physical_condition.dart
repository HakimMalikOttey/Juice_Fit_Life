import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/custom_dropdown_box.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

class PhysicalConditions extends StatefulWidget {
  static String id = "PhysicalConditions";
  final Function(bool condition)? validate;
  PhysicalConditions({this.validate});
  @override
  _PhysicalConditionsState createState() => _PhysicalConditionsState();
}

class _PhysicalConditionsState extends State<PhysicalConditions> {
  var time;
  Timer? clock;
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      widget.validate!(Provider.of<StudentSignUpData>(context, listen: false)
          .goalValidator());
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
                Text("Your Goals",
                    style: Theme.of(context).textTheme.headline3),
                Text(
                    "Tell us where you are starting off and what goals that you have for your body!",
                    style: Theme.of(context).textTheme.headline1),
                Consumer<StudentSignUpData>(builder: (context, data, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: CustomTextBox(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CurrencyTextInputFormatter(symbol: '')
                                ],
                                show: true,
                                controller: data.weight,
                                hintText: 'Weight(LB)',
                                onChanged: (value) {
                                  setState(() {});
                                  // data.weight.text = double.tryParse(value).toString() ?? 0;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: CustomTextBox(
                                inputFormatters: [
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                show: true,
                                controller: data.height,
                                hintText: 'Feet',
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: CustomTextBox(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                show: true,
                                controller: data.inches,
                                hintText: 'Inches',
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "How Active Are You?",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      CustomDropdownBox(
                        value: data.activelevel as String,
                        items: data.activeMeasure,
                        onChanged: (value) {
                          setState(() {
                            data.activelevel = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "What are your goals?",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      CustomDropdownBox(
                        value: data.goalChoice as String,
                        items: data.goalList,
                        onChanged: (value) {
                          setState(() {
                            data.goalChoice = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
