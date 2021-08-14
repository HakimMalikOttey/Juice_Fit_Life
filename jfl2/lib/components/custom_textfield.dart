import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hint;
  final onchange;
  final borderColor;
  final maxlength;
  CustomTextField({required this.controller,required this.hint,required this.onchange,this.borderColor,this.maxlength});
  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: new ThemeData(
          primaryColor: Colors.black,
          backgroundColor: Colors.grey
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
        child: TextField(
            maxLength: maxlength != null ? maxlength : null,
          controller:controller ,
          decoration: InputDecoration(
            isDense: true,
              contentPadding: EdgeInsets.only(top:10.0,bottom: 10.0,left: 10.0),
              fillColor: Color(0xFFF5F5F5),
              filled:true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.black,width: 2.0),
                borderRadius: BorderRadius.all(Radius.zero),
              ),
              errorBorder:InputBorder.none,
              hintText: hint,
              hintStyle:
              TextStyle(color: Colors.black)),
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
          onChanged: onchange
        ),
      ),
    );
  }
}