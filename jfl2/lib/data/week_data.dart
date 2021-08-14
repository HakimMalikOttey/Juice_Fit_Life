import 'package:flutter/cupertino.dart';

class WeekData {
  final String weekday;
  DayData? dayElement;
  WeekData({required this.weekday, this.dayElement});
}

class DayData {
  static List<String> dayType = ["workout", "rest"];
  final String type;
  final String name;
  final String id;
  final List elements;
  DayData(
      {required this.name,
      required this.id,
      required this.elements,
      required this.type});
}
