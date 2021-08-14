import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownBox extends StatefulWidget {
  String value;
  final List<String> items;
  final Function(String?) onChanged;
  CustomDropdownBox(
      {required this.value, required this.items, required this.onChanged});
  @override
  _CustomDropdownBoxState createState() => _CustomDropdownBoxState();
}

class _CustomDropdownBoxState extends State<CustomDropdownBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).accentColor, style: BorderStyle.solid)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: widget.value,
            underline: Container(),
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: widget.onChanged
            // onChanged: (value) {
            //   setState(() {
            //     widget.value = value;
            //   });
            // },
            ),
      ),
    );
  }
}
