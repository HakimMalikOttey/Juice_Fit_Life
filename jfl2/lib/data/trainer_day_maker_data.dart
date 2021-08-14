import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/workout_cell_template_data.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/data/workout_segment_cell_data.dart';
import 'package:jfl2/main.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class TrainerDayMakerData extends ChangeNotifier {
  TextEditingController _dayname = TextEditingController();
  TextEditingController _description = TextEditingController();
  String? id;
  List<WorkoutSegmentCellData> _dayworkouts = [];
  final String _plancall = "/days";
  List<WorkoutSegmentCellData> get dayworkouts => _dayworkouts;

  set dayworkouts(List<WorkoutSegmentCellData> value) {
    dayworkouts = value;
    notifyListeners();
  }

  TextEditingController get description => _description;

  set description(TextEditingController value) {
    _description = value;
    notifyListeners();
  }

  TextEditingController get dayname => _dayname;

  set dayname(TextEditingController value) {
    _dayname = value;
    notifyListeners();
  }

  void changeTimeType(String data, int index) {
    _dayworkouts[index].timeType = data;
    notifyListeners();
  }

  appendWorkout(String name, String id, String type) {
    _dayworkouts.add(new WorkoutSegmentCellData(
        type: type,
        timeType: WorkoutSegmentCellData.timeTypeList[0],
        timeCieling: new TextEditingController(),
        name: name,
        id: id));
    notifyListeners();
  }

  Future retrieveDayData(String id) async {
    final day = await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return day;
  }

  Future createDay(String id, Map data) async {
    final day = await HttpCallRequest.postRequest("$_plancall/$id", data);
    return day;
  }

  Future deleteDay(String id, Map body) async {
    final day = await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return day;
  }

  Future editDay(String id, Map data) async {
    final day = await HttpCallRequest.putRequest("$_plancall/$id", data);
    return day;
  }

  Future copyDay(String id, Map body) async {
    final day =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return day;
  }

  Future getDay(String id, Map<String, dynamic> query) async {
    final day = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return day;
  }

  removeWorkout(String check) {
    dayworkouts.removeWhere((element) => element.id == check);
    notifyListeners();
  }

  removeRest(int index) {
    dayworkouts.removeAt(index);
    notifyListeners();
  }

  mapdata(var point, var info) {
    dayworkouts[point] = info;
    notifyListeners();
  }

  void cleardata() {
    dayworkouts.clear();
    dayname.clear();
  }

  void DayValidator(BuildContext context, int type) {
    List<WorkoutSegmentCellData> convert = [];
    List<Map> day = [];
    convert.addAll(_dayworkouts);
    print(convert);
    for (int i = 0; i < convert.length; i++) {
      final Map data = {
        "segmentType": convert[i].type,
        "id": convert[i].id,
        "time": convert[i].timeCieling!.text,
        "timeType": convert[i].timeType,
      };
      day.add(data);
    }
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
              future: type == 1
                  ? createDay(
                      "${Provider.of<UserData>(context, listen: false).id}", {
                      "name": _dayname.text,
                      "description": _description.text,
                      "day": day,
                    })
                  : Provider.of<TrainerDayMakerData>(context, listen: false)
                      .editDay("$id", {
                      "name": _dayname.text,
                      "description": _description.text,
                      "day": day,
                    }),
              successRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[Text("Day has been saved")],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Provider.of<TrainerDayMakerData>(context,
                                  listen: false)
                              .dayworkouts
                              .clear();
                          Provider.of<TrainerDayMakerData>(context,
                                  listen: false)
                              .dayname
                              .clear();
                          WidgetsBinding.instance
                              ?.addPostFrameCallback((timeStamp) {
                            Navigator.pop(context);
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Ok"))
                  ],
                );
              },
              failedRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text("There was an error saving this day. Try again later")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              },
              errorRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was a major error saving this day. Try again later")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              },
            ));
  }
}
