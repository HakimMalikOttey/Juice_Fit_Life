import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/Screens/trainers/level_editor.dart';
import 'package:jfl2/Screens/trainers/level_editor_launch.dart';
import 'package:jfl2/Screens/trainers/meal_plan_editor_launch.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/fill_in_block.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/level_container.dart';
import 'package:jfl2/components/level_list.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/meal_container.dart';
import 'package:jfl2/components/meal_list.dart';
import 'package:jfl2/components/mini_plan_view.dart';
import 'package:jfl2/components/partition_editor_info.dart';
import 'package:jfl2/components/partition_editor_level.dart';
import 'package:jfl2/components/partition_editor_meal.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/stretch_list.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'meal_plan_maker.dart';

class TrainerPartitionEditor extends StatefulWidget {
  static String id = "TrainerPartitionEditor";
  //0 - edit, 1 - create, 2 - view
  final int? type;
  final String? name;
  final String? explanation;
  final String? partitionId;
  final List? levels;
  final Map? meal;
  TrainerPartitionEditor(
      {this.type,
      this.explanation,
      this.name,
      this.partitionId,
      this.levels,
      this.meal});
  _TrainerPartitionEditor createState() => _TrainerPartitionEditor();
}

class _TrainerPartitionEditor extends State<TrainerPartitionEditor>
    with SingleTickerProviderStateMixin {
  ScrollController levelController = ScrollController();
  late ScrollController myController;
  late TabController controller;
  TextEditingController nameController = new TextEditingController();
  TextEditingController partitionExplanationController =
      new TextEditingController();
  bool didchange = false;
  @override
  void initState() {
    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                  future: Provider.of<TrainerPartitionEditorData>(context,
                          listen: false)
                      .retrievePartitionData(widget.partitionId as String),
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
                    final partData = jsonDecode(data.data);
                    final List progressionList = partData["progression"];
                    print(partData["meal"]);
                    final Map meal = partData["meal"];
                    Provider.of<TrainerPartitionEditorData>(context,
                            listen: false)
                        .name
                        .text = partData["name"];
                    Provider.of<TrainerPartitionEditorData>(context,
                            listen: false)
                        .description
                        .text = partData["description"];
                    if (meal != null) {
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .addMeal(meal["name"], meal["_id"], meal);
                    }
                    for (int i = 0; i < progressionList.length; i++) {
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .appendLevel(progressionList[i]["name"],
                              progressionList[i]["_id"]);
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
    controller = TabController(length: 3, vsync: this);
    myController = ScrollController();
    // if (widget.type != 1) {
    //   nameController.text = widget.name;
    //   partitionExplanationController.text = widget.explanation;
    //   Provider.of<TrainerPartitionEditorData>(context, listen: false)
    //       .Levels
    //       .addAll(widget.levels);
    //   Provider.of<TrainerPartitionEditorData>(context, listen: false).meal =
    //       widget.meal;
    // }
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
                  Text("Do you want to quit out of the Partition Editor?"),
                ],
                actionlist: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .meal = null;
                      Provider.of<UserData>(context, listen: false)
                          .BatchOperation
                          .value = false;
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .Levels
                          .clear();
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .name
                          .clear();
                      Provider.of<TrainerPartitionEditorData>(context,
                              listen: false)
                          .description
                          .clear();
                      Navigator.of(context, rootNavigator: true).pop(true);
                      // Navigator.pushReplacementNamed(context, Start.id);
                      Navigator.pop(context);
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
          title: Text('Partition Editor'),
          bottom: TabBar(
            controller: controller,
            tabs: [
              Tab(
                child: Text("Info"),
              ),
              Tab(
                child: Text("Levels"),
              ),
              Tab(
                child: Text("Meal Explanation"),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: controller,
            children: [
              PartitionEditorInfo(
                active: widget.type != 2 ? true : false,
              ),
              PartitionEditorLevel(
                active: widget.type != 2 ? true : false,
              ),
              PartitionEditorMeal(active: widget.type != 2 ? true : false)
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                  child: Provider.of<TrainerPartitionEditorData>(context)
                                  .name
                                  .text
                                  .trim() !=
                              "" &&
                          Provider.of<TrainerPartitionEditorData>(context)
                              .Levels
                              .isNotEmpty &&
                          widget.type != 2
                      ? FooterButton(
                          text: Text(
                              widget.type == 1
                                  ? "Submit Partition"
                                  : "Edit Partition",
                              style: Theme.of(context).textTheme.headline6),
                          color: Colors.green,
                          action: () {
                            Provider.of<TrainerPartitionEditorData>(context,
                                    listen: false)
                                .validatePartition(
                                    context, widget.type as int, widget.partitionId as String);
                          })
                      : FooterButton(
                          text: Text(
                              widget.type == 1
                                  ? "Submit Partition"
                                  : "Edit Partition",
                              style: Theme.of(context).textTheme.headline6),
                          color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }
}
