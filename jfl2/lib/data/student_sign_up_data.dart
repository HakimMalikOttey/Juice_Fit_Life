import 'package:flutter/cupertino.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'dart:ffi';

class StudentSignUpData extends ChangeNotifier {
  MemberSignupData _studentData = new MemberSignupData();
  TextEditingController _weight = new TextEditingController();
  TextEditingController _height = new TextEditingController();
  TextEditingController _inches = new TextEditingController();
  bool? _studentValidate;
  String? _activelevel;
  String? _goalChoice;
  final List<String> activeMeasure = [
    "- Pick One -",
    "1 - Not Active At All",
    "2 - Barely Active",
    "3 - Somewhat Active",
    "4 - Pretty Active",
    "5 - Really Active",
    "6 - Extremely Active"
  ];
  final List<String> _goalList = [
    "- Pick One -",
    "Put on muscle mass",
    "Slim down",
    "Perfect form",
    "Stretch more",
    "Gain strength",
    "Increase stamina"
  ];
  StudentSignUpData() {
    _studentData.callback = () => notifyListeners();
    _activelevel = activeMeasure[0];
    _goalChoice = _goalList[0];
  }
  bool? get studentValidate => _studentValidate;

  set studentValidate(bool? value) {
    _studentValidate = value;
    notifyListeners();
  }

  MemberSignupData get studentData => _studentData;

  set studentData(MemberSignupData value) {
    _studentData = value;
    _studentData.callback = () => notifyListeners();
    // notifyListeners();
  }

  TextEditingController get weight => _weight;

  set weight(TextEditingController value) {
    _weight = value;
    notifyListeners();
  }

  // String get heightType => _heightType;

  // set heightType(String value) {
  //   _heightType = value;
  //   notifyListeners();
  // }

  String? get goalChoice => _goalChoice;

  set goalChoice(String? value) {
    _goalChoice = value;
    notifyListeners();
  }

  TextEditingController get height => _height;

  set height(TextEditingController value) {
    _height = value;
    notifyListeners();
  }

  TextEditingController get inches => _inches;

  set inches(TextEditingController value) {
    _inches = value;
    notifyListeners();
  }

  String? get activelevel => _activelevel;

  set activelevel(String? value) {
    _activelevel = value;
    notifyListeners();
  }

  List<String> get goalList => _goalList;

  // set goalList(List<String> value) {
  //   _goalList = value;
  //   notifyListeners();
  // }

  void resetData() {
    studentData = new MemberSignupData();
    _weight.clear();
    _height.clear();
    _inches.clear();
    _activelevel = null;
    _goalChoice = null;
    notifyListeners();
  }

  bool goalValidator() {
    if (weight.text != "" &&
        height.text != "" &&
        activelevel != activeMeasure[0] &&
        goalChoice != goalList[0])
      return true;
    else
      return false;
  }

  studentValidator() {
    if (_weight != 0 &&
        _height != 0 &&
        _activelevel != null &&
        _goalList.length != 0 &&
        _goalList.length != null) {
      _studentValidate = true;
    } else {
      _studentValidate = false;
    }
    print(_studentValidate);
  }
}
