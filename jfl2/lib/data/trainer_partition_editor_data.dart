import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/partition_level_data.dart';
import 'package:jfl2/data/partition_meal_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class TrainerPartitionEditorData extends ChangeNotifier {
  List<PartitionLevelData> _Levels = [];
  PartitionMealData? _meal;
  final TextEditingController name = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  ScrollController levelController = ScrollController();
  final String _plancall = "/partitions";
  List<PartitionLevelData> get Levels => _Levels;

  set Levels(List<PartitionLevelData> value) {
    _Levels = value;
    notifyListeners();
  }

  PartitionMealData? get meal => _meal;

  set meal(PartitionMealData? value) {
    _meal = value;
    notifyListeners();
  }

  Future retrievePartitionData(String id) async {
    final partition =
        await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return partition;
  }

  Future createPartition(String id, Map body) async {
    final partition = await HttpCallRequest.postRequest("$_plancall/$id", body);
    return partition;
  }

  appendLevel(String name, String id) {
    Levels.add(PartitionLevelData(name: name, id: id));
    notifyListeners();
  }

  addMeal(String name, String id, Map element) {
    _meal = new PartitionMealData(name: name, id: id, element: element);
    notifyListeners();
  }

  removeMeal() {
    _meal = null;
    notifyListeners();
  }

  removeLevel(var index) {
    Levels.removeAt(index);
    notifyListeners();
  }

  Future editPartition(String id, Map body) async {
    final partition = await HttpCallRequest.putRequest("$_plancall/$id", body);
    return partition;
  }

  Future getPartition(String id, Map<String, dynamic> query) async {
    final partition = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return partition;
  }

  Future deletePartition(String id, Map body) async {
    final partition =
        await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return partition;
  }

  Future copyPartition(String id, Map body) async {
    final workouts =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return workouts;
  }

  validatePartition(BuildContext context, int type, String id) {
    List data = [];
    String mealId;
    if (_meal != null) {
      // mealId = Provider.of<TrainerPartitionEditorData>(
      //         context,
      //         listen: false)
      //     .meal["_id"];
    }
    for (int i = 0; i < _Levels.length; i++) {
      data.add(_Levels[i].id);
    }
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
              future: type == 1
                  ? createPartition(Provider.of<UserData>(context).id as String, {
                      "name": "${name.text}",
                      "description": "${description.text}",
                      "progression": data,
                      "meal": _meal!.id,
                    })
                  : Provider.of<TrainerPartitionEditorData>(context)
                      .editPartition(id, {
                      "name": "${name.text}",
                      "description": "${description.text}",
                      "progression": data,
                      "meal": _meal != null ? _meal!.id : "",
                    }),
              successRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[Text("Partition has been saved.")],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          _Levels.clear();
                          name.clear();
                          description.clear();
                          _meal = null;
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
                    Text(
                        "There was an error saving this partition. Please try again later.")
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
                        "There was a major error saving this partition. Please try again later.")
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
