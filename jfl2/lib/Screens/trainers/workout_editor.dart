import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/Screens/trainers/youtube_presentation.dart';
import 'package:jfl2/components/trainer_workout_blocks.dart';
import 'package:jfl2/components/trainer_workout_info.dart';
import 'package:jfl2/data/sets_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jfl2/components/amount_ticker.dart';
import 'package:jfl2/components/amount_ticker_sideways.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_textfield.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/radio_button.dart';
import 'package:jfl2/components/rep_cell.dart';
import 'package:jfl2/components/rest_container.dart';
import 'package:jfl2/components/set_container.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/vimeo_query_button.dart';
import 'package:jfl2/components/workout_example_cell.dart';
import 'package:jfl2/components/workout_timer.dart';
import 'package:jfl2/components/youtube_presentation.dart';
import 'package:jfl2/components/youtube_upload_list.dart';
import 'package:jfl2/data/rep_data.dart';
import 'package:jfl2/data/thumbnail.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/vimeo_data.dart';
import 'package:jfl2/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TrainerWorkoutMakerStraight extends StatefulWidget {
  static String id = "TrainerWorkoutMakerStraight";
  //0 - edit, 1 - create, 2 - view
  final int? type;
  final workoutid;

  TrainerWorkoutMakerStraight({this.workoutid, this.type});

  _TrainerWorkoutMakerStraight createState() => _TrainerWorkoutMakerStraight();
}

class _TrainerWorkoutMakerStraight extends State<TrainerWorkoutMakerStraight>
    with SingleTickerProviderStateMixin {
  TextEditingController description = new TextEditingController();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  late StreamSubscription _onDestroy;
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  TextEditingController test = new TextEditingController();
  late ScrollController _myController;
  TextEditingController _youtubelink = new TextEditingController();
  late TextEditingController _nameController;
  late TabController controller;
  late String code;
  bool didchange = false;
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    flutterWebviewPlugin.close();
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((event) {
      print("destroy");
    });
    _myController = ScrollController();
    _nameController = new TextEditingController();
    controller = TabController(length: 2, vsync: this);

    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                  future: Provider.of<TrainerWorkoutEditorData>(context,
                          listen: false)
                      .retrieveWorkoutData(widget.workoutid),
                  errorRoutine: (data) {
                    return CustomAlertBox(
                      infolist: <Widget>[
                        Text(
                            "There was a major error in rendering this page. Please try again later.")
                      ],
                      actionlist: <Widget>[
                        // ignore: deprecated_member_use
                        FlatButton(
                            onPressed: () {
                              WidgetsBinding.instance?.addPostFrameCallback((_) {
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
                            "We had a problem rendering this page. Please try again later.")
                      ],
                      actionlist: <Widget>[
                        // ignore: deprecated_member_use
                        FlatButton(
                            onPressed: () {
                              WidgetsBinding.instance?.addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Ok"))
                      ],
                    );
                  },
                  successRoutine: (data) {
                    final Map jsonData = jsonDecode(data.data);
                    final List media = jsonData["media"];
                    final List workouts = jsonData["workout"];
                    TrainerWorkoutEditorData template =
                        Provider.of<TrainerWorkoutEditorData>(context,
                            listen: false);
                    template.name.text = jsonData["name"];
                    template.description.text = jsonData["description"];
                    for (int i = 0; i < media.length; i++) {
                      template.appendLink(VimeoData(
                          link: media[i]["link"],
                          thumbnail: media[i]["thumbnail"],
                          name: media[i]["name"]));
                    }
                    for (int i = 0; i < workouts.length; i++) {
                      template.appendWorkout(0);
                      template.SetsList[i].type = SetsData.workoutTypeList
                              .firstWhere((element) =>
                                  element == workouts[i]["workoutType"]);
                          // ??
                          // SetsData.workoutTypeList[0];
                      template.SetsList[i].reptype = workouts[i]["repType"];
                      template.SetsList[i].reps?.text = workouts[i]["reps"];
                      template.SetsList[i].pounds?.text = workouts[i]["pounds"];
                      template.SetsList[i].timeCieling?.text =
                          workouts[i]["time"];
                      template.SetsList[i].timeType = workouts[i]["timeType"];
                    }
                    return WidgetsBinding.instance?.addPostFrameCallback((_) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  },
                ));
      });
    }
    controller.addListener(() {
      if (controller.indexIsChanging) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              var baseDialog = CustomAlertBox(
                infolist: <Widget>[
                  Text("Do you want to quit out of the Workout Editor?"),
                ],
                actionlist: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Provider.of<TrainerWorkoutEditorData>(context,
                              listen: false)
                          .SetsList
                          .clear();
                      Provider.of<TrainerWorkoutEditorData>(context,
                              listen: false)
                          .youtubeLinks
                          .clear();
                      Provider.of<TrainerWorkoutEditorData>(context,
                              listen: false)
                          .name
                          .clear();
                      Provider.of<TrainerWorkoutEditorData>(context,
                              listen: false)
                          .description
                          .clear();
                      // Provider.of<TrainerWorkoutEditorData>(context, listen: false).WorkoutSets.clear();
                      Navigator.pop(context);
                      Navigator.of(context, rootNavigator: true).pop(true);
                      // Navigator.pushReplacementNamed(context, Start.id);
                      // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                  )
                ],
              );
              showDialog(
                  context: context,
                  builder: (BuildContext context) => baseDialog);
            },
          ),
          title: Text('Workout Editor'),
          bottom: TabBar(
            controller: controller,
            tabs: [
              Tab(
                child: Text("Info"),
              ),
              Tab(
                child: Text("Workout"),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(controller: controller, children: [
            TrainerWorkoutInfo(
                name: _nameController,
                type: widget.type as int,
                description: description),
            TrainerWorkoutBlocks(
                 type: widget.type as int)
          ]),
        ),
        bottomNavigationBar:
            Consumer<TrainerWorkoutEditorData>(builder: (context, data, child) {
          return data.name.text != "" &&
                  widget.type != 2 &&
                  data.SetsList.isNotEmpty
              ? BottomAppBar(
                  child: Row(children: [
                  Expanded(
                    child: FooterButton(
                        color: Colors.green,
                        text: Text(
                            widget.type != 0
                                ? "Submit Workouts"
                                : "Save Changes",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                        action: () async {
                          Provider.of<TrainerWorkoutEditorData>(context,
                                  listen: false)
                              .ValidateWorkout(
                                  context, widget.type as int, widget.workoutid);
                        }),
                  )
                ]))
              : BottomAppBar(
                  child: Row(
                    children: [
                      Expanded(
                        child: FooterButton(
                            color: Colors.grey,
                            text: Text(
                                widget.type != 0 || widget.type != 2
                                    ? "Submit Workouts"
                                    : "Save Changes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            action: () {}),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
