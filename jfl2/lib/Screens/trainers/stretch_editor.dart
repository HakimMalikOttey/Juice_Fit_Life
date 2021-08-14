import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/youtube_presentation.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/loading_indicator.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/youtube_presentation.dart';
import 'package:jfl2/components/youtube_upload_list.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

class StretchEditor extends StatefulWidget {
  static String id = "StretchEditor";
  //0 - edit, 1 - create, 2 - view
  final int? type;
  final String? stretchId;
  final List? youtubeLink;
  final String? name;
  StretchEditor({this.type, this.stretchId, this.name, this.youtubeLink});
  _StretchEditor createState() => _StretchEditor();
}

class _StretchEditor extends State<StretchEditor> {
  late ScrollController _workoutController;
  // TextEditingController _youtubelink = new TextEditingController();
  TextEditingController _youtubelink = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  late ScrollController _myController;
  @override
  void initState() {
    _myController = new ScrollController();
    if (widget.type == 0 || widget.type == 2) {
      for (int i = 0; i < widget.youtubeLink!.length; i++) {
        Provider.of<StretchMakerData>(context, listen: false).appendLink();
        Provider.of<StretchMakerData>(context, listen: false)
            .youtubeLinks[i]
            .text = widget.youtubeLink![i];
      }
      // _youtubelink.text = widget.youtubeLink;
      _nameController.text = widget.name as String;
    } else {
      // _youtubelink = new TextEditingController();
      _nameController = new TextEditingController();
    }
    // TODO: implement initState
    super.initState();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              var baseDialog = CustomAlertBox(
                infolist: <Widget>[
                  Text("Do you want to quit out of the Stretch Editor?"),
                ],
                actionlist: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Provider.of<StretchMakerData>(context, listen: false)
                          .youtubeLinks
                          .clear();
                      // Provider.of<TrainerWorkoutEditorData>(context, listen: false).WorkoutSets.clear();
                      Navigator.of(context, rootNavigator: true).pop(true);
                      // Navigator.pushReplacementNamed(context, Start.id);
                      Navigator.pop(context);
                      // _mealController = new ZefyrController(
                      //     NotusDocument.fromDelta(Delta()..insert("\n")));
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
          actions: <Widget>[],
          title: Text('Stretch Editor'),
        ),
        body: ListView(
          controller: _myController,
          // reverse: true,
          children: [
            Consumer<StretchMakerData>(builder: (context, data, child) {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        child: CustomTextBox(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9 ]'))
                          ],
                          active: widget.type == 2 ? false : true,
                          controller: _nameController,
                          hintText: 'Your Stretch Name...(Required)',
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxlength: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SquareButton(
                      padding: EdgeInsets.only(top: 0),
                      color: Colors.black,
                      pressed: () {
                        setState(() {
                          data.appendLink();
                        });
                        // data.appendWorkout();
                      },
                      butContent: Row(
                        children: [
                          Text(
                            "Create New Video",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.add_circle_outline_outlined)
                        ],
                      ),
                      buttonwidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // YoutubeUploadList(
                    //     scrollController: _myController,
                    //     callback: this.callback,
                    //     youtubeLinks: data.youtubeLinks,
                    //     menu: widget.type == 2 ? false : true),
                  ],
                ),
              );
            })
          ],
        ),
        bottomNavigationBar: _nameController.text != "" &&
                widget.type != 2 &&
                Provider.of<StretchMakerData>(context).youtubeLinks.length !=
                    0
            // &&
            //     Provider.of<StretchMakerData>(context).youtubeLinks.indexWhere(
            //             (element) =>
            //                 getIdFromUrl(element.text.trim()) == null) ==
            //         -1
            ? BottomAppBar(
                child: Row(children: [
                Expanded(
                  child: FooterButton(
                      color: Colors.green,
                      text: Text(
                          widget.type != 0 ? "Submit Stretch" : "Save Changes",
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)),
                      action: () async {
                        List elements = [];
                        elements.addAll(Provider.of<StretchMakerData>(context,
                                listen: false)
                            .youtubeLinks);
                        for (int i = 0; i < elements.length; i++) {
                          final ink = elements[i].text;
                          elements.removeAt(i);
                          elements.insert(i, ink);
                        }
                        showDialog(
                            context: context,
                            builder: (context) => LoadingDialog(
                                  future: widget.type == 1
                                      ? Provider.of<StretchMakerData>(context,
                                              listen: false)
                                          .createstrecth(
                                              "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
                                              {
                                              "type": "stretch",
                                              "name": _nameController.text,
                                              "media": elements,
                                              "date": DateTime.now().toString()
                                            })
                                      : Provider.of<StretchMakerData>(context,
                                              listen: false)
                                          .editstretch("${widget.stretchId}", {
                                          "name": _nameController.text,
                                          "media": elements,
                                        }),
                                  successRoutine: (data) {
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text("Stretch has been saved")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              Provider.of<StretchMakerData>(
                                                      context,
                                                      listen: false)
                                                  .youtubeLinks
                                                  .clear();
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback(
                                                      (timeStamp) {
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
                                            "There was an error saving this stretch. Try again later")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
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
                                            "There was a major error saving this stretch. Try again later")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                ));
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
              ),
      ),
    );
  }
}
