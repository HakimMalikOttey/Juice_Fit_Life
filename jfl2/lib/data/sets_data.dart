import 'package:flutter/cupertino.dart';

class SetsData {
  static List<String> workoutTypeList = ["workout", "rest"];
  static List<String> timeTypeList = ["secs.", "mins."];
  static List<String> repTypeList = ["Rep", "Timed"];
  String? type;
  String? reptype;
  TextEditingController? reps;
  TextEditingController? pounds;
  TextEditingController? timeCieling;
  String? timeType;
  SetsData(
      {this.type,
      this.reps,
      this.pounds,
      this.timeCieling,
      this.timeType,
      this.reptype});
}
