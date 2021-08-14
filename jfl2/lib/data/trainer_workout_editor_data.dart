import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/rep_data.dart';
import 'package:jfl2/data/sets_data.dart';
import 'package:jfl2/data/thumbnail.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/vimeo_data.dart';
import 'package:jfl2/data/workout_cell_template_data.dart';
import 'package:jfl2/data/workout_data.dart';
import 'package:jfl2/data/workout_data.dart';
import 'package:jfl2/main.dart';
import 'package:provider/provider.dart';

class TrainerWorkoutEditorData extends ChangeNotifier {
  List<SetsData> _SetsList = [];
  final String _plancall = "/workout";
  List<VimeoData> _youtubeLinks = [];
  List<VimeoData> get youtubeLinks => _youtubeLinks;
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  set youtubeLinks(List<VimeoData> value) {
    _youtubeLinks = value;
    notifyListeners();
  }

  void appendLink(VimeoData data) {
    // TextEditingController _youtubelink = new TextEditingController();
    _youtubeLinks.add(data);
    notifyListeners();
  }

  Future retrieveWorkoutData(String id) async {
    final workout =
        await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return workout;
  }

  void refresh() {
    notifyListeners();
  }

  List<SetsData> get SetsList => _SetsList;

  set sets(var value) {
    _SetsList = value;
    notifyListeners();
  }

  void removeSegment(int index) {
    _SetsList.removeAt(index);
    notifyListeners();
  }

  void appendWorkout(int workoutType) {
    final SetsData Sets = new SetsData(
        type: SetsData.workoutTypeList[workoutType],
        reps: new TextEditingController(),
        pounds: new TextEditingController(),
        timeCieling: new TextEditingController(),
        reptype: SetsData.repTypeList[0],
        timeType: SetsData.timeTypeList[0]);
    Sets.reps!.text = "0";
    Sets.pounds!.text = "0";
    Sets.timeCieling!.text = "0";
    _SetsList.add(Sets);
    notifyListeners();
  }

  void changeRepType(String data, int index) {
    _SetsList[index].reptype = data;
    notifyListeners();
  }

  void changeTimeType(String data, int index) {
    _SetsList[index].timeType = data;
    notifyListeners();
  }

  Future getworkouts(String id, Map<String, dynamic> query) async {
    final workouts = await HttpCallRequest.getRequest('$_plancall/$id', query);
    return workouts;
  }

  Future deleteworkout(String id, Map body) async {
    final workouts =
        await HttpCallRequest.deleteRequest('$_plancall/$id', body);
    return workouts;
  }

  Future createworkouts(String id, Map body) async {
    final workouts = await HttpCallRequest.postRequest('$_plancall/$id', body);
    return workouts;
  }

  Future copyWorkout(String id, Map body) async {
    final workouts =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return workouts;
  }

  Future editworkouts(String id, Map body) async {
    final workouts = await HttpCallRequest.putRequest('$_plancall/$id', body);
    return workouts;
  }

  void ValidateWorkout(BuildContext context, int type, String id) {
    List vimeoVideos = [];
    youtubeLinks.forEach((element) {
      final Map videos = {
        "name": element.name,
        "thumbnail": element.thumbnail,
        "link": element.link,
      };
      vimeoVideos.add(videos);
    });
    //converting workouts into json string. can be read to be turned back  into widget form
    List<Map> send = [];
    SetsList.forEach((element) {
      final Map workout = {
        "workoutType": element.type,
        "repType": element.reptype,
        "reps": element.reps!.text.toString(),
        "pounds": element.pounds!.text.toString(),
        "time": element.timeCieling!.text.toString(),
        "timeType": element.timeType,
      };
      send.add(workout);
    });
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
              future: type == 1
                  ? createworkouts(
                      "${Provider.of<UserData>(context, listen: false).id}", {
                      "name": name.text,
                      "planPortionType": "workoutunit",
                      "description": description.text,
                      "media": jsonEncode(vimeoVideos),
                      "workout": jsonEncode(send),
                    })
                  : editworkouts("$id", {
                      "name": name.text,
                      "description": description.text,
                      "media": jsonEncode(vimeoVideos),
                      "workout": jsonEncode(send),
                    }),
              successRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[Text("Workout has been saved.")],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          SetsList.clear();
                          youtubeLinks.clear();
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
                        "There was an error saving this workout. Try again later.")
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
                        "There was a major error saving this workout. Try again later.")
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

  setVideo() async {
    // final pointer = _WorkoutSets[index];
    PickedFile video =
        await ImagePicker().getVideo(source: ImageSource.gallery) as PickedFile;
    // pointer.thumbnail = await Thumbnail.getthumb(pointer.video.path);
    // checkCellStatus(index);
    return video;
  }
}
