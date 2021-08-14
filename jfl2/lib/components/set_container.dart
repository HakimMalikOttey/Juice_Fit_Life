import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_dropdown_box.dart';

import 'amount_ticker.dart';

class SetContainer extends StatelessWidget {
  int setnumber;
  final List<String> repTypeList;
  final List<String> timeTypeList;
  String repType;
  String timeType;
  final Function(String data, int index) changeRepType;
  final Function(String data, int index) changeTimeType;
  final VoidCallback delete;
  int index;
  final TextEditingController rep;
  final TextEditingController pound;
  final TextEditingController time;
  final bool active;
  SetContainer(
      {required this.setnumber,
      required this.rep,
      required this.delete,
      required this.pound,
      required this.active,
      required this.repType,
      required this.repTypeList,
      required this.index,
      required this.changeRepType,
      required this.time,
      required this.timeTypeList,
      required this.timeType,
      required this.changeTimeType});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        color: Theme.of(context).cardColor,
        height: 170.0,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Set $setnumber",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: repType == repTypeList[0] ? 0 : 1,
                          child: repType == repTypeList[0]
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: CustomDropdownBox(
                                      value: timeType,
                                      items: timeTypeList, onChanged: (String? data) {

                                  changeTimeType(data as String, index);

                                  },
                                      ),
                                ),
                        ),
                        //Reps Container. Should not use decimals, as there is no such thing as a half rep
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: repType == repTypeList[0]
                                  ? AmountTicker(
                                      inputFormatters: [
                                        CurrencyTextInputFormatter(
                                          locale: 'ko',
                                          decimalDigits: 0,
                                          symbol: '',
                                        )
                                      ],
                                      enabled: active,
                                      controller: rep,
                                      label: "Reps",
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: AmountTicker(
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                locale: 'ko',
                                                decimalDigits: 0,
                                                symbol: '',
                                              )
                                            ],
                                            enabled: active,
                                            controller: time,
                                            label: "Timer",
                                          ),
                                        ),
                                      ],
                                    )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AmountTicker(
                                inputFormatters: [
                                  CurrencyTextInputFormatter(
                                    locale: 'ko',
                                    decimalDigits: 1,
                                    symbol: '',
                                  )
                                ],
                                enabled: active,
                                controller: pound,
                                label: "Pounds",
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Set Type:",
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: active == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        child: CustomDropdownBox(
                                            value: repType,
                                            items: repTypeList,
                                            onChanged: (String? data) {
                                              changeRepType(data as String, index);
                                            }),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("$repType"),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
            )
          ],
        ),
      ),
    );
  }
}
