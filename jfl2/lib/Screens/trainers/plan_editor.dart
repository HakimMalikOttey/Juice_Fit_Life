import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/Screens/trainers/partition_editor.dart';
import 'package:jfl2/Screens/trainers/partition_editor_launch.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/dialog_quill_container.dart';
import 'package:jfl2/components/dialog_typer.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/mini_plan_view.dart';
import 'package:jfl2/components/partition_container.dart';
import 'package:jfl2/components/partition_list.dart';
import 'package:jfl2/components/plan_editor_explanation.dart';
import 'package:jfl2/components/plan_editor_information.dart';
import 'package:jfl2/components/plan_editor_partitions.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/firebase_function.dart' as firebasefunction;
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';
import 'package:jfl2/components/image_selector_box.dart';

class TrainerPlanEditor extends StatefulWidget {
  static String id = "TrainerPlanEditor";
  //0 - edit, 1 - create, 2 - view
  final int? type;
  final String? name;
  final String? planId;
  final explanation;
  final hook;
  final String? banner;
  final List? partitions;
  TrainerPlanEditor(
      {this.type,
      this.name,
      this.planId,
      this.explanation,
      this.banner,
      this.partitions,
      this.hook});
  _TrainerPlanEditor createState() => _TrainerPlanEditor();
}

class _TrainerPlanEditor extends State<TrainerPlanEditor>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool didchange = false;
  @override
  void initState() {
    // FocusManager.instance.primaryFocus.unfocus();
    controller = TabController(length: 3, vsync: this);
    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                  future: Provider.of<PlanEditorData>(context, listen: false)
                      .retrievePlanData(widget.planId as String),
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
                    final planData = jsonDecode(data.data);
                    List pictureList = planData["pictures"];
                    List partitionList = planData["partitions"];
                    Provider.of<PlanEditorData>(context, listen: false)
                        .name
                        .text = planData["name"];
                    Provider.of<PlanEditorData>(context, listen: false)
                        .description
                        .text = planData["description"];
                    Provider.of<PlanEditorData>(context, listen: false)
                        .controller = new QuillController(
                      document: Document.fromJson(
                          jsonDecode(planData["explanation"])),
                      selection: TextSelection.collapsed(offset: 0),
                    );
                    for (int i = 0; i < pictureList.length; i++) {
                      Provider.of<PlanEditorData>(context, listen: false)
                          .pictures[i]
                          .cloudImage = pictureList[i];
                    }
                    for (int i = 0; i < partitionList.length; i++) {
                      Provider.of<PlanEditorData>(context, listen: false)
                          .addPartition(partitionList[i]["name"],
                              partitionList[i]["_id"]);
                    }
                    return WidgetsBinding.instance
                        ?.addPostFrameCallback((timeStamp) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  },
                ));
      });
    }
    // if (widget.type == 0 || widget.type == 2) {
    //   nameController.text = widget.name;
    //   quickExplanationController.text = widget.hook;
    //   _controller = new QuillController(
    //     document: Document.fromJson(widget.explanation),
    //     selection: TextSelection.collapsed(offset: 0),
    //   );
    //   // planExplanationController.text = widget.explanation;
    //   Provider.of<PlanEditorData>(context, listen: false)
    //       .Partitions
    //       .addAll(widget.partitions);
    //   log(Provider.of<PlanEditorData>(context, listen: false)
    //       .Partitions
    //       .toString());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanEditorData>(builder: (context, data, child) {
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
                    Text("Do you want to quit out of the Plan Editor?"),
                  ],
                  actionlist: <Widget>[
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Provider.of<PlanEditorData>(context, listen: false)
                            .clearData();
                        Navigator.pop(context);
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
            title: Text('Plan Editor'),
            bottom: TabBar(
              controller: controller,
              tabs: [
                Tab(
                  child: Text(
                    "Basic Information",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Tab(
                  child: Text("Partitions"),
                ),
                Tab(
                  child: Text("Explanation"),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              controller: controller,
              children: [
                PlanEditorInformation(
                  type: widget.type,
                  banner: widget.banner,
                ),
                PlanEditorPartitions(
                  type: widget.type,
                ),
                PlanEditorExplanation(type: widget.type)
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                Expanded(
                    child: Provider.of<PlanEditorData>(context, listen: false).name.text.trim() != "" &&
                            Provider.of<PlanEditorData>(context, listen: false)
                                    .description
                                    .text
                                    .trim() !=
                                "" &&
                            Provider.of<PlanEditorData>(context, listen: false)
                                .Partitions
                                .isNotEmpty &&
                            Provider.of<PlanEditorData>(context, listen: false)
                                    .pictures
                                    .indexWhere((element) =>
                                        element.cloudImage != null) !=
                                -1
                        ? FooterButton(
                            text: Text(widget.type == 1 ? "Submit Plan" : "Edit Plan",
                                style: Theme.of(context).textTheme.headline6),
                            color: Colors.green,
                            action: () {
                              return Provider.of<PlanEditorData>(context,
                                      listen: false)
                                  .planValidation(
                                      widget.type as int, context, widget.planId as String);
                            })
                        : FooterButton(
                            text: Text(
                                widget.type == 1 ? "Submit Plan" : "Edit Plan",
                                style: Theme.of(context).textTheme.headline6),
                            color: Colors.grey))
              ],
            ),
          ),
        ),
      );
    });
  }

  void StateChange() {
    setState(() {});
  }
}
