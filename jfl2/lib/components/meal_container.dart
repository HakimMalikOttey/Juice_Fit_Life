import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/components/confirm_load.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/batch_delete.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/plan_segement_cell.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'loading_dialog.dart';
import 'meal_copy.dart';

class MealContainer extends StatefulWidget {
  final elements;
  final bool mainMenu;
  final bool? added;
  final bool? view;
  final FutureOr Function(dynamic value)? reset;
  // final Function(String id, bool checkboxActive) batch;
  // final bool checkbox;
  MealContainer(
      {required this.elements,
      required this.mainMenu,
      required this.reset,
       this.added,
      this.view});
  @override
  _MealContainerState createState() => _MealContainerState();
}

class _MealContainerState extends State<MealContainer> {
  bool _selected = false;
  var myJSON;
  late FocusNode _mealFocusNode;
  late QuillController _controller;
  @override
  void initState() {
    myJSON = jsonDecode(widget.elements["meal"]);
    _controller = new QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlanSegmentCell(
        name: Text(
          "${widget.elements["name"]}",
          style: Theme.of(context).textTheme.headline6,
        ),
        id: "${widget.elements["_id"]}",
        onLongPressActive: () {},
        onTapActive: () {
          setState(() {
            if (Provider.of<UserData>(context, listen: false)
                .QueryIds
                .value
                .contains("${widget.elements["_id"]}")) {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .removeWhere(
                      (element) => element == "${widget.elements["_id"]}");
            } else {
              Provider.of<UserData>(context, listen: false)
                  .QueryIds
                  .value
                  .add("${widget.elements["_id"]}");
            }
            Provider.of<UserData>(context, listen: false).QueryIdsLength.value =
                Provider.of<UserData>(context, listen: false)
                    .QueryIds
                    .value
                    .isNotEmpty;
          });
        },
        onLongPressInactive: widget.mainMenu == true
            ? () {
                setState(() {
                  Provider.of<UserData>(context, listen: false)
                      .BatchOperation
                      .value = true;
                });
              }
            : () {},
        onTapInactive: () {
          showDialog(
              context: context,
              builder: (context) => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PlanMakerPopUp(
                    name: "${widget.elements["name"]}",
                    listview: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QuillEditor.basic(
                            autoFocus: false,
                            controller: _controller,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ],
                    remove: widget.mainMenu == false &&
                            widget.added == true &&
                            widget.view != false
                        ? () {
                            Provider.of<TrainerPartitionEditorData>(context,
                                    listen: false)
                                .removeMeal();
                            Navigator.pop(context);
                          }
                        : null,
                    add: widget.mainMenu == false && widget.added != true
                        ? () {
                            Provider.of<TrainerPartitionEditorData>(context,
                                    listen: false)
                                .addMeal(widget.elements["name"],
                                    widget.elements["_id"], widget.elements);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null,
                    view: widget.mainMenu == false
                        ? () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerMealPlanMaker.id, arguments: {
                              "title": widget.elements["name"],
                              "mealid": widget.elements["_id"],
                              "mealPlan": myJSON,
                              "type": 2
                            });
                          }
                        : null,
                    delete: widget.mainMenu == true
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmLoad(
                                    request:
                                        "This will permanently delete this meal: ${widget.elements["name"]}. Are you sure?",
                                    confirm: () {
                                      Navigator.pop(context);
                                       showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              BatchDelete(
                                                errorMessage:
                                                    "There was a major error while deleting this meal. Please try again later.",
                                                successMessage:
                                                    "Meal has been deleted!",
                                                failedMessage:
                                                    "There was an error while deleting this meal. Please try again later.",
                                                deleteRequest: Provider.of<
                                                            MealPlanMakerData>(
                                                        context)
                                                    .deleteMeal(
                                                        Provider.of<UserData>(
                                                                context)
                                                            .id as String,
                                                        {
                                                      'mealIDs': [
                                                        "${widget.elements["_id"]}"
                                                      ]
                                                    }),
                                              ));
                                    },
                                    deny: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(true);
                                    }));
                          }
                        : null,
                    copy: widget.mainMenu == true
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmLoad(
                                    request:
                                        "Do you want to copy this meal: ${widget.elements["name"]}?",
                                    confirm: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              MealCopy(
                                                mealIds: [
                                                  "${widget.elements["_id"]}"
                                                ],
                                              ));
                                    },
                                    deny: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(true);
                                    }));
                          }
                        : null,
                    edit: widget.mainMenu == true
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(TrainerMealPlanMaker.id, arguments: {
                              "title": widget.elements["name"],
                              "mealid": widget.elements["_id"],
                              "mealPlan": myJSON,
                              "type": 0
                            }).then(widget.reset as FutureOr<dynamic> Function(Object?));
                          }
                        : null,
                    // add: () {},
                  )));
        });
  }
}
