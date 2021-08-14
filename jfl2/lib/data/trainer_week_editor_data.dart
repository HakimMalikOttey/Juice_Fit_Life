import 'package:flutter/cupertino.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/week_data.dart';

import '../main.dart';

class TrainerWeekEditorData extends ChangeNotifier {
  TextEditingController name = new TextEditingController();
  // List _week = [
  //   {"day": "Sunday", "element": []},
  //   {"day": "Monday", "element": []},
  //   {"day": "Tuesday", "element": []},
  //   {"day": "Wednesday", "element": []},
  //   {"day": "Thursday", "element": []},
  //   {"day": "Friday", "element": []},
  //   {"day": "Saturday", "element": []},
  // ];
  final List<WeekData> _week = [
    WeekData(weekday: "Sunday", dayElement: null),
    WeekData(weekday: "Monday", dayElement: null),
    WeekData(weekday: "Tuesday", dayElement: null),
    WeekData(weekday: "Wednesday", dayElement: null),
    WeekData(weekday: "Thursday", dayElement: null),
    WeekData(weekday: "Friday", dayElement: null),
    WeekData(weekday: "Saturday", dayElement: null),
  ];
  int? currentIndex;
  final String _plancall = "/week";
  List<WeekData> get week => _week;

  set week(List<WeekData> value) {
    week = value;
    notifyListeners();
  }

  addElement(int index, String name, String id, List elements, String type) {
    _week[index].dayElement =
        new DayData(name: name, id: id, elements: elements, type: type);
    notifyListeners();
  }

  removeElement(int index) {
    _week[index].dayElement = null;
    notifyListeners();
  }

  removeId(String id) {
    _week[_week.indexWhere((element) => element.dayElement!.id == id)]
        .dayElement = null;
    notifyListeners();
  }

  Future retrieveWeekData(String id) async {
    final week = await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return week;
  }

  Future createWeek(String id, Map data) async {
    final week = await HttpCallRequest.postRequest("$_plancall/$id", data);
    return week;
    // final http.Response response =
    //     await http.post(Uri.https("$link", "/week/$id"),
    //         headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: jsonEncode(data));
    // return jsonDecode(response.body);
  }

  Future editWeek(String id, Map data) async {
    final week = await HttpCallRequest.putRequest("$_plancall/$id", data);
    return week;
    // final http.Response response =
    //     await http.put(Uri.https("$link", "/week/$id"),
    //         headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: jsonEncode(data));
    // return jsonDecode(response.body);
  }

  Future copyWeek(String id, Map body) async {
    final workouts =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return workouts;
  }

  Future getWeek(String id, Map<String, dynamic> query) async {
    final week = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return week;
    // final http.Response response = await http.get(
    //   Uri.https("$link", "/week/$id"),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    // return response.body;
  }

  Future deleteWeek(String id, Map body) async {
    final week = await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return week;
    //   final http.Response response = await http.delete(
    //     Uri.https("$link", "/week/$id"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //   );
    //   return response.body;
    // }
  }
}
