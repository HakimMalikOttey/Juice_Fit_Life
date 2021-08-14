import 'dart:collection';
import 'package:flutter/foundation.dart';

class GoalData extends ChangeNotifier{
  List<Map> _SelectedGoals = [
  ];
  List<Map> get goals => _SelectedGoals;
  // List<Map> get goals{
  //   return UnmodifiableListView(_SelectedGoals);
  // }
  int get goalCount {
    return _SelectedGoals.length;
  }
  void addGoal(Map newGoal){
    _SelectedGoals.add(newGoal);
    notifyListeners();
  }

  void deleteGoal(Map goal){
    _SelectedGoals.remove(goal);
    notifyListeners();
  }
  void findAndDeleteGoal(dynamic x){
    _SelectedGoals.removeWhere(x);
    notifyListeners();
  }
}
