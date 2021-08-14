import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 252.0,
          bottom: 252.0,
          left: 100.0,
          right: 100.0),
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).accentColor,
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor),
        strokeWidth: 10.0,
      ),
    );
  }
}