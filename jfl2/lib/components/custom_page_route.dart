import 'package:flutter/material.dart';

class CustomPageRoute extends MaterialPageRoute{
  CustomPageRoute({builder,settings}): super(builder:builder);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}