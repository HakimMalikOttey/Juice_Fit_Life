import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/user_data.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:jfl2/components/loading_dialog.dart';

class TrainerMealPlanMaker extends StatefulWidget {
  static String id = "TrainerMealPlanMaker";
  final mealid;
  //0 - edit, 1 - create, 2 - view
  final int? type;
  TrainerMealPlanMaker({this.mealid, this.type});

  _TrainerMealPlanMaker createState() => _TrainerMealPlanMaker();
}

class _TrainerMealPlanMaker extends State<TrainerMealPlanMaker> {
  var typerep;
  QuillController _controller = QuillController.basic();
  TextEditingController name = new TextEditingController();
  var time;
  late Timer clock;
  late ValueNotifier<TextEditingValue> doc;
  late int _sId;
  // KeyboardVisibilityNotification _kvn;
  late FocusNode _mealFocusNode;
  String text = " ";
  bool didchange = false;

  @override
  void initState() {
    super.initState();
    doc = new ValueNotifier(_controller.plainTextEditingValue);
    time = const Duration(milliseconds: 1);
    typerep = widget.type;
    _mealFocusNode = FocusNode();
    clock = new Timer.periodic(time, (timer) {
      doc.value = _controller.plainTextEditingValue;
    });
    if (widget.type != 1 && didchange == false) {
      didchange = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                  future: Provider.of<MealPlanMakerData>(context, listen: false)
                      .retrieveMealData(widget.mealid),
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
                    print(data);
                    final meal = jsonDecode(data.data);
                    print(meal);
                    name.text = meal["name"];
                    _controller = new QuillController(
                      document: Document.fromJson(jsonDecode(meal["meal"])),
                      selection: TextSelection.collapsed(offset: 0),
                    );
                    print("this is fine");
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

  void dispose() {
    clock.cancel();
    super.dispose();
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
                  Text("Do you want to quit out of the Meal Plan Editor?"),
                ],
                actionlist: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Provider.of<MealPlanMakerData>(context, listen: false)
                          .mealname
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
          title: Text('Meal Plan Editor'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: CustomTextBox(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-zA-Z0-9 ]'))
                ],
                active: widget.type != 2 ? true : false,
                controller: name,
                hintText: 'Type Meal Plan Name...(Required)',
                onChanged: (text) {
                  setState(() {});
                },
                maxlength: 20,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2.0, color: Colors.black))),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(color: Colors.white)),
                  child: QuillToolbar.basic(
                    controller: _controller,
                  )),
            ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(brightness: Brightness.light),
                          child: QuillEditor.basic(
                            autoFocus: false,
                            controller: _controller,
                            readOnly: widget.type != 2 ? false : true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        bottomNavigationBar: BottomAppBar(
            child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: doc,
                // valueListenable: _controller.info,
                builder: (BuildContext context, value, _) {
                  if (name.text.trim() != "" &&
                      value.text.trim() != "" &&
                      typerep != 2 &&
                      value != "") {
                    return Row(
                      children: [
                        Expanded(
                          child: FooterButton(
                            color: Colors.green,
                            text: Text(
                                typerep == 1
                                    ? "Submit Meal Plan"
                                    : "Edit Meal Plan",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            action: () async {
                              final mealplan = Provider.of<MealPlanMakerData>(
                                  context,
                                  listen: false);
                              showDialog(
                                  context: context,
                                  builder: (context) => LoadingDialog(
                                        future: typerep == 1
                                            ? mealplan.sendMeal(
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .id as String,
                                                {
                                                    'name': name.text,
                                                    'meal': jsonEncode(
                                                        _controller.document
                                                            .toDelta()
                                                            .toJson()),
                                                  })
                                            : mealplan.editMeal(widget.mealid, {
                                                'name': name.text,
                                                'meal': jsonEncode(_controller
                                                    .document
                                                    .toDelta()
                                                    .toJson()),
                                              }),
                                        failedRoutine: (data) {
                                          return CustomAlertBox(
                                            infolist: <Widget>[
                                              Text(
                                                  "There was an error saving this meal plan. Please try again later.")
                                            ],
                                            actionlist: <Widget>[
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(true);
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          );
                                        },
                                        errorRoutine: (data) {
                                          return CustomAlertBox(
                                            infolist: <Widget>[
                                              Text(
                                                  "There was a major error saving this meal plan. Please try again later.")
                                            ],
                                            actionlist: <Widget>[
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(true);
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          );
                                        },
                                        successRoutine: (data) {
                                          return CustomAlertBox(
                                            infolist: <Widget>[
                                              Text(
                                                  "Meal plan has been successfully saved.")
                                            ],
                                            actionlist: <Widget>[
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                  onPressed: () {
                                                    Provider.of<MealPlanMakerData>(
                                                            context,
                                                            listen: false)
                                                        .mealname
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
                                      ));
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: FooterButton(
                            color: Colors.grey,
                            text: Text(
                                typerep == 1
                                    ? "Submit Meal Plan"
                                    : "Edit Meal Plan",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            action: () async {},
                          ),
                        ),
                      ],
                    );
                  }
                })),
      ),
    );
  }
}
