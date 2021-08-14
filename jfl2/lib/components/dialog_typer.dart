import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/single_line_textfield.dart';

class DialogTyper extends StatelessWidget {
  final List<TextInputFormatter>? formatters;
  final TextEditingController controller;
  final String hint;
  final Function changed;
  final TextInputType? keyboard;
  final int? maxLength;
  final int? lines;
  DialogTyper(
      {this.formatters,
      required this.controller,
      required this.hint,
      required this.changed,
      this.keyboard,
      this.maxLength,
      this.lines});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            height: 100.0,
            child: Material(
              child: CustomTextBox(
                keyboardType: keyboard as TextInputType,
                inputFormatters: formatters,
                autoFocus: true,
                controller: controller,
                hintText: hint,
                onChanged: changed,
                maxlength: maxLength as int,
                lines: lines,
              ),
            ),
          ),
        )
      ],
    );
  }
}
