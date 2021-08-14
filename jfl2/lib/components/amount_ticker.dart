import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/tick_button.dart';

class AmountTicker extends StatelessWidget {
  TextEditingController controller;
  final String label;
  final enabled;
  final List<TextInputFormatter>? inputFormatters;
  AmountTicker(
      {required this.controller,
      required this.label,
      this.enabled,
      this.inputFormatters});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(
        //   child:enabled == true ? Padding(
        //     padding: const EdgeInsets.only(bottom:15.0),
        //     child: TickButton(
        //       ontap: postive,
        //       widgeticon: Icons.keyboard_arrow_up_outlined,
        //     ),
        //   ):Container()
        // ),
        Expanded(child: Container()),
        Expanded(
          child: Container(
            width: 70.0,
            child: GestureDetector(
              onTap: enabled == true
                  ? () {
                      showDialog(
                          context: context,
                          builder: (context) => Stack(
                                children: [
                                  Positioned(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.white,
                                      height: 50.0,
                                      child: Material(
                                        child: CustomTextBox(
                                          inputFormatters: inputFormatters,
                                          keyboardType: TextInputType.number,
                                          autoFocus: true,
                                          controller: controller,
                                          hintText: "Type Amount....",
                                          onChanged: (String text) {
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
                                                          new RegExp(","),
                                                          "")) >
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
                    // controller: controller,
                    maxLines: 1,
                    maxLength: 4,
                    onChanged: (text) {
                      try {
                        if (int.parse(text) < 0) {
                          controller.text = "0";
                        } else if (int.parse(text) > 999) {
                          controller.text = "999";
                        }
                      } catch (e) {
                        print(e);
                      }
                    }),
              ),
            ),
          ),
        ),
        // Expanded(
        //   child: enabled == true ? Padding(
        //     padding: const EdgeInsets.only(top:15.0),
        //     child: TickButton(
        //       ontap: negative,
        //       widgeticon: Icons.keyboard_arrow_down_outlined,
        //     ),
        //   ):Container()
        // ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text("${label}"),
        )
      ],
    );
  }
}
