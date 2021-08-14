import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_textfield.dart';
import 'package:jfl2/components/single_line_textfield.dart';

class YoutubePresentationBox extends StatelessWidget {
  final bool active;
  final TextEditingController youtubeLink;
  final Function change;
  final youtubeWindow;
  final Widget? delete;
  VoidCallback? callback;
  YoutubePresentationBox(
      {required this.active,
      required this.youtubeLink,
      required this.change,
      required this.youtubeWindow,
      this.delete,
      this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      child: GestureDetector(
                        onTap: active == true
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
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
                                                    autoFocus: true,
                                                    controller: youtubeLink,
                                                    hintText:
                                                        "Type Youtube Link...",
                                                    onChanged: (text) {
                                                      callback!();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                              }
                            : () {},
                        child: CustomTextBox(
                          active: false,
                          controller: youtubeLink,
                          hintText: 'Input Youtube Video Link...(Required)',
                          onChanged: change,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: delete == null ? Container() : delete,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: youtubeWindow,
          ),
        ],
      ),
    );
  }
}
