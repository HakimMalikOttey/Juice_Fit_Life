import 'package:flutter/material.dart';
class RadioButton extends StatelessWidget {
  final text;
  final color;
  final pressed;
  RadioButton({@required this.text, @required this.color, @required this.pressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0,bottom:10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: FloatingActionButton(
                backgroundColor: color,
                child: null,
                onPressed: pressed,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
  }
}
