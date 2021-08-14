import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/week_editor_launch.dart';
import 'package:jfl2/components/amount_ticker.dart';
import 'package:jfl2/components/amount_ticker_sideways.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/mini_plan_view.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/week_container.dart';
import 'package:jfl2/components/week_list.dart';
import 'package:jfl2/components/workout_list.dart';
import 'package:jfl2/data/level_part_data.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class TrainerLevelEditor extends StatefulWidget {
  static String id = "TrainerLevelEditor";
  final String? level;
  final String? levelid;
  final String? name;
  //0 - edit, 1 - create, 2 - view
  final int? type;
  TrainerLevelEditor({this.type, this.level, this.name, this.levelid});
  _TrainerLevelEditor createState() => _TrainerLevelEditor();
}

class _TrainerLevelEditor extends State<TrainerLevelEditor> {
  TextEditingController blockAmount = new TextEditingController();
  ScrollController _myController = ScrollController();
  bool didchange = false;
  @override
  void initState() {
    if (widget.type == 1) {
      blockAmount.text = "1.0";
    } else {
      if (didchange == false) {
        didchange = true;
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          await showDialog(
              context: context,
              builder: (context) => LoadingDialog(
                    future: Provider.of<TrainerLevelEditorData>(context,
                            listen: false)
                        .retrieveLevelData(widget.levelid as String),
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
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
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
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
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
                      Provider.of<TrainerLevelEditorData>(context).id =
                          widget.levelid;
                      final levelData = jsonDecode(data.data);
                      Provider.of<TrainerLevelEditorData>(context)
                          .repetition
                          .text = levelData["repeat"];
                      Provider.of<TrainerLevelEditorData>(context,
                              listen: false)
                          .levelname
                          .text = levelData["name"];
                      // log(widget.level.toString());
                      levelData["level"].forEach((element) {
                        Provider.of<TrainerLevelEditorData>(context,
                                listen: false)
                            .levelparts
                            .add(LevelPartData(
                                id: element["_id"], name: element["name"]));
                      });
                      return WidgetsBinding.instance?.addPostFrameCallback((_) {
                        setState(() {
                          Navigator.pop(context);
                        });
                      });
                    },
                  ));
        });
      }
    }
    super.initState();
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
                  Text("Do you want to quit out of the Day Editor?"),
                ],
                actionlist: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Provider.of<TrainerLevelEditorData>(context,
                              listen: false)
                          .levelparts
                          .clear();
                      Provider.of<UserData>(context, listen: false)
                          .BatchOperation
                          .value = false;
                      Provider.of<TrainerLevelEditorData>(context,
                              listen: false)
                          .levelname
                          .clear();
                      Navigator.of(context, rootNavigator: true).pop(true);
                      Navigator.pop(context);
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
          title: Text('Level Editor'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Consumer<TrainerLevelEditorData>(
                builder: (context, data, child) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: CustomTextBox(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9 ]'))
                          ],
                          active: widget.type != 2 ? true : false,
                          controller: data.levelname,
                          labelText: 'Your Level Name...(Required)',
                          onChanged: (text) {
                            setState(() {});
                          },
                          maxlength: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: AmountTickerSideWays(
                                controller:
                                    Provider.of<TrainerLevelEditorData>(context)
                                        .repetition,
                                // postive: () {
                                //   double decrease = blockAmount
                                //           .text.isEmpty
                                //       ? 1.0
                                //       : double.parse(blockAmount.text);
                                //   if (decrease != 1.0) {
                                //     decrease = decrease - 0.50;
                                //     setState(() {
                                //       blockAmount.text =
                                //           decrease.toString();
                                //     });
                                //   }
                                // },
                                // negative: () {
                                //   double increase = blockAmount
                                //           .text.isEmpty
                                //       ? 1.0
                                //       : double.parse(blockAmount.text);
                                //   if (increase != 999.0) {
                                //     increase = increase + 0.50;
                                //     blockAmount.text =
                                //         increase.toString();
                                //     print(blockAmount.text);
                                //   }
                                // },
                                // controller: blockAmount,
                                label: "Level Repetition #",
                                enabled: widget.type != 2 ? true : false),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: widget.type != 2
                            ? SquareButton(
                                padding: EdgeInsets.only(top: 0),
                                color: widget.type != 2
                                    ? Colors.black
                                    : Colors.grey,
                                pressed: () {
                                  if (widget.type != 2) {
                                    return showDialog(
                                        context: context,
                                        builder: (context) => MiniPlanView(
                                            windowName: 'Select a Week',
                                            dataWindow: TrainerWeekEditorLaunch(
                                                menuType: false)));
                                    // showModalBottomSheet(
                                    //     isScrollControlled: true,
                                    //     context: context,
                                    //     builder: (context) => WeekList());
                                  }
                                },
                                butContent: Text(
                                  "Insert a Week",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                buttonwidth: MediaQuery.of(context).size.width,
                                height: 50.0,
                              )
                            : Divider(
                                height: 1.0,
                                thickness: 1.0,
                              ),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Consumer<TrainerLevelEditorData>(
                    builder: (context, data, child) {
                  return ReorderableListView(
                    scrollController: _myController,
                    children: [
                      for (int index = 0;
                          index < data.levelparts.length;
                          index++)
                        Row(
                          key: Key('$index'),
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  WeekContainer(
                                    name: data.levelparts[index].name,
                                    reset: null,
                                    elements: {},
                                    index: index,
                                    mainMenu: false,
                                    added: true,
                                    weekId: data.levelparts[index].id,
                                    other: null,
                                    view: widget.type != 2 ? true : false,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ],
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = data.levelparts.removeAt(oldIndex);
                        data.levelparts.insert(newIndex, item);
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Provider.of<TrainerLevelEditorData>(context,
                            listen: false)
                        .levelname
                        .text
                        .trim() !=
                    "" &&
                Provider.of<TrainerLevelEditorData>(context).repetition.text !=
                    "" &&
                widget.type != 2 &&
                Provider.of<TrainerLevelEditorData>(context, listen: false)
                    .levelparts
                    .isNotEmpty
            ? BottomAppBar(
                child: Row(
                  children: [
                    Expanded(
                      child: FooterButton(
                          text: Text(
                            widget.type == 1 ? "Submit Level" : "Edit Level",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          color: Colors.green,
                          action: () {
                            Provider.of<TrainerLevelEditorData>(context,
                                    listen: false)
                                .levelValidation(context, widget.type as int);
                          }),
                    )
                  ],
                ),
              )
            : BottomAppBar(
                child: Row(
                  children: [
                    Expanded(
                      child: FooterButton(
                        text: Text(
                          widget.type == 1 ? "Submit Level" : "Edit Level",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        color: Colors.grey,
                        action: () {},
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
