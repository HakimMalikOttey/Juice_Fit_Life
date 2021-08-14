import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/tick_button.dart';

class AmountTickerSideWays extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final label;
  final enabled;

  AmountTickerSideWays(
      {required this.controller,
      @required this.label,
      this.enabled,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   child: enabled == true ? TickButton(
        //     ontap: postive,
        //     widgeticon: Icons.keyboard_arrow_left_outlined,
        //   ): Container(),
        // ),
        SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: enabled == true
              ? () {
                  showDialog(
                      context: context,
                      builder: (context) => Stack(
                            children: [
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  height: 50.0,
                                  child: Material(
                                    child: CustomTextBox(
                                      inputFormatters: inputFormatters,
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      autoFocus: true,
                                      // controller: controller,
                                      hintText: "Type Amount....",
                                      onChanged: (text) {
                                        if (text.trim().isEmpty) {
                                          controller.text = "0";
                                        }
                                        try {
                                          if (double.parse(text.replaceAll(
                                                  new RegExp(","), "")) <
                                              0) {
                                            controller.text = "0";
                                          } else if (double.parse(
                                                  text.replaceAll(
                                                      new RegExp(","), "")) >
                                              999) {
                                            controller.text = "999";
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                        // this.callback();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                }
              : () {},
          child: Container(
            width: 70.0,
            height: 30.0,
            child: Theme(
              data: ThemeData(
                disabledColor: Colors.white,
                hintColor: Colors.white,
              ),
              child: TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.headline1,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      border: OutlineInputBorder()),
                  maxLines: 1,
                  maxLength: 4,
                  onChanged: (text) {
                    try {
                      if (double.parse(text) < 0) {
                        controller.text = "0";
                      } else if (double.parse(text) > 999) {
                        controller.text = "999";
                      }
                    } catch (e) {
                      print(e);
                    }
                  }),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        // Container(
        //   child: enabled == true ? TickButton(
        //     ontap: negative,
        //     widgeticon: Icons.keyboard_arrow_right_outlined,
        //   ): Container(),
        // ),
        SizedBox(
          width: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text("${label}"),
        )
      ],
    );
  }
}
