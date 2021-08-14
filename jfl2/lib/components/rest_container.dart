import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/single_line_textfield.dart';

import 'amount_ticker_sideways.dart';
import 'custom_dropdown_box.dart';

class RestContainer extends StatelessWidget {
  TextEditingController controller;
  String timeType;
  int index;
  final List<String> timeTypeList;
  final Function(String data, int index) changeTimeType;
  final VoidCallback delete;
  final bool active;
  RestContainer(
      {required this.controller,
      required this.delete,
      required this.active,
      required this.timeType,
      required this.changeTimeType,
      required this.timeTypeList,
      required this.index});
  @override
  Widget build(BuildContext context) {
    print("----------------");
    print(active);
    print("----------------");
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        color: Theme.of(context).disabledColor,
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: AmountTickerSideWays(
                              enabled: active,
                              controller: controller,
                              label: "Rest Timer",
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                  locale: 'ko',
                                  decimalDigits: 0,
                                  symbol: '',
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text("Time Type:"),
                            Expanded(
                              child: active == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: CustomDropdownBox(
                                          value: timeType,
                                          items: timeTypeList, onChanged: (String? data) {

                                      changeTimeType(data as String, index);

                                      },

                                          ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("$timeType"),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 15.0),
              child: active == true
                  ? GestureDetector(
                      onTap: delete,
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
