import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpFields extends StatelessWidget {
  final String hinttext;
  final event;
  final obscure;
  final suggestions;
  final autocorrect;
  final keyboardtype;
  final TextEditingController controller;
  TextEditingController test = new TextEditingController();
  SignUpFields({required this.hinttext, required this.event,this.obscure,this.suggestions,this.autocorrect,this.keyboardtype, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller:  test,
      keyboardType:keyboardtype != null? keyboardtype: TextInputType.text,
        obscureText: obscure != null ? obscure: false,
        enableSuggestions: suggestions != null ? suggestions:true,
        autocorrect: autocorrect != null ? autocorrect: true,
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme
                      .of(context)
                      .accentColor, width: 3.0)),
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme
                      .of(context)
                      .accentColor, width: 3.0)),
          hintText: hinttext,
          hintStyle: TextStyle(color: Theme
              .of(context)
              .accentColor)),
      style: TextStyle(
          color: Theme
              .of(context)
              .accentColor, fontWeight: FontWeight.bold),
      onChanged: event,
    );
  }
}