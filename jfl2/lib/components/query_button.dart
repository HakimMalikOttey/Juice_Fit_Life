import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QueryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget icon;
  final MaterialColor? color;
  QueryButton({@required this.onTap, required this.icon, this.color});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      child: InkWell(
        highlightColor: Colors.grey[850]?.withOpacity(0.3),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: icon,
        ),
      ),
    );
  }
}
