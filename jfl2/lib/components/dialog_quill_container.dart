import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:jfl2/components/single_line_textfield.dart';

class DialogQuillContainer extends StatelessWidget{
  final QuillController controller;
  DialogQuillContainer({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom:
          MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: Container(
            height: 250.0,
            child: Column(
              children: [
                Container(
                  height:50.0,
                  child: Theme(
                      data: Theme.of(context).copyWith(iconTheme: IconThemeData(
                          color: Colors.white
                      )),
                      child: QuillToolbar.basic(
                        controller: controller,
                      )),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        border: Border.all(
                        )
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(brightness: Brightness.light),
                      child: QuillEditor.basic(
                        autoFocus: false,
                        controller: controller,
                        readOnly: false,
                        // autoFocus: true,
                        // readOnly: widget.type !=2 ? false: true,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        )
      ],
    );
  }
}