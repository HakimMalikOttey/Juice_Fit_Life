import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/level_part_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class TrainerLevelEditorData extends ChangeNotifier {
  TextEditingController _levelname = new TextEditingController();
  TextEditingController _repetition = new TextEditingController();
  List<LevelPartData> _levelparts = [];
  String? id;
  final String _plancall = "/levels";
  List<LevelPartData> get levelparts => _levelparts;

  set levelparts(List<LevelPartData> value) {
    _levelparts = value;
    notifyListeners();
  }

  TextEditingController get repetition => _repetition;

  set repetition(TextEditingController value) {
    _repetition = value;
    notifyListeners();
  }

  TextEditingController get levelname => _levelname;

  set levelname(TextEditingController value) {
    _levelname = value;
    notifyListeners();
  }

  appendpart(String id, String name) {
    _levelparts.add(new LevelPartData(id: id, name: name));
    notifyListeners();
  }

  removepart(int index) {
    levelparts.removeAt(index);
    notifyListeners();
  }

  Future getLevels(String id, Map<String, dynamic> query) async {
    final level = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return level;
  }

  Future createLevel(String id, Map body) async {
    final level = await HttpCallRequest.postRequest("$_plancall/$id", body);
    return level;
  }

  Future editLevel(String id, Map body) async {
    final level = await HttpCallRequest.putRequest("$_plancall/$id", body);
    return level;
  }

  Future deleteLevel(String id, Map body) async {
    final level = await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return level;
  }

  Future retrieveLevelData(String id) async {
    final level = await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return level;
  }

  Future copyLevel(String id, Map body) async {
    final workouts =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return workouts;
  }

  levelValidation(BuildContext context, int type) {
    List<String> data = [];

    for (int i = 0; i < _levelparts.length; i++) {
      data.add(_levelparts[i].id);
    }
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
              future: type == 1
                  ? createLevel(Provider.of<UserData>(context).id as String, {
                      "name": _levelname.text,
                      "level": data,
                      "repeat": _repetition.text,
                    })
                  : editLevel('$id', {
                      "name": _levelname.text,
                      "level": data,
                      "repeat": _repetition.text,
                    }),
              failedRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was an error saving this level. Please try again later.")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          _levelparts.clear();
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
              successRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[Text("Level has been saved.")],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          _levelparts.clear();
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
              errorRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was a major error saving this level. Please try again later.")
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
