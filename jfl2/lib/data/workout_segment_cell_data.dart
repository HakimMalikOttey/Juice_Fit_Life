import 'package:flutter/cupertino.dart';

class WorkoutSegmentCellData {
  static List<String> daySegmentTypeList = ["workout", "rest"];
  static List<String> timeTypeList = ["secs.", "mins."];
  final String type;
  final String name;
  final String id;
  TextEditingController? timeCieling;
  String? timeType;
  WorkoutSegmentCellData(
      {required this.type,
      required this.name,
      required this.id,
      this.timeCieling,
      this.timeType});
}
