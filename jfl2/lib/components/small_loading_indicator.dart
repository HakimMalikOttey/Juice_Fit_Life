import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13.0,
      height: 13.0,
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).accentColor,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        strokeWidth: 1.0,
      ),
    );
  }
}
