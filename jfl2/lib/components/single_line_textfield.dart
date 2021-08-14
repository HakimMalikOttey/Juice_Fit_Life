import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextBox extends StatelessWidget {
  final onChanged;
  final TextEditingController controller;
  final String? hintText;
  final int? maxlength;
  final bool? show;
  final bool? active;
  final int? lines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autoFocus;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? enableSuggestions;
  final bool? autoCorrect;
  final String? labelText;
  CustomTextBox(
      {required this.onChanged,
      required this.controller,
      this.hintText,
      this.maxlength,
      this.show,
      this.active,
      this.lines,
      this.inputFormatters,
      this.autoFocus,
      this.keyboardType,
      this.obscureText,
      this.enableSuggestions,
      this.autoCorrect,
      this.labelText});
  @override
  Widget build(BuildContext context) {
    final InputBorder border = OutlineInputBorder(
        borderSide: show == false
            ? BorderSide(color: Colors.transparent)
            : BorderSide(color: Theme.of(context).accentColor),
        borderRadius: const BorderRadius.all(
          Radius.zero,
        ));
    return Theme(
      data: ThemeData(
        disabledColor: Colors.white,
        hintColor: Colors.white,
      ),
      child: TextField(
          autocorrect: autoCorrect ?? true,
          enableSuggestions: enableSuggestions ?? true,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          style: Theme.of(context).textTheme.headline1,
          autofocus: autoFocus ?? false,
          inputFormatters: inputFormatters,
          maxLengthEnforcement: maxlength == null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          maxLength: maxlength,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            fillColor: Colors.white,
            alignLabelWithHint: true,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            disabledBorder: border,
            border: border,
          ),
          controller: controller,
          maxLines: lines == null ? 1 : lines,
          enabled: active == null || active == true ? true : active,
          onChanged: onChanged),
    );
  }
}
