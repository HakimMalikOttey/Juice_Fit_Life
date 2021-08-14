import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';
import 'custom_alert_box.dart';

class MealListView extends StatefulWidget {
  final dropdownValue;
  final TextEditingController searchcontroller;
  final bool mainMenu;
  MealListView(
      {required this.dropdownValue,
      required this.searchcontroller,
      required this.mainMenu});
  @override
  _MealListViewState createState() => _MealListViewState();
}

class _MealListViewState extends State<MealListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<MealPlanMakerData>(context, listen: false).getMeal(
            Provider.of<TrainerSignUpData>(context, listen: false)
                .trainerData
                .data["_id"],
            {}),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List decoded = json.decode(snapshot.data as String);
            if (widget.dropdownValue == filters[0]) {
              decoded.sort((a, b) =>
                  (a["name"].toLowerCase()).compareTo(b["name"].toLowerCase()));
            } else if (widget.dropdownValue == filters[1]) {
              decoded.sort((a, b) =>
                  (b["name"].toLowerCase()).compareTo(a["name"].toLowerCase()));
            } else if (widget.dropdownValue == filters[2]) {
              decoded.sort((a, b) =>
                  (DateFormat(a["date"]).format(DateTime.now()))
                      .compareTo(DateFormat(b["date"]).format(DateTime.now())));
            } else if (widget.dropdownValue == filters[3]) {
              decoded.sort((a, b) =>
                  (DateFormat(b["date"]).format(DateTime.now()))
                      .compareTo(DateFormat(a["date"]).format(DateTime.now())));
            }
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: decoded.length,
                itemBuilder: (context, index) {
                  if (decoded[index]["name"]
                      .contains(widget.searchcontroller.text)) {
                    var myJSON = jsonDecode(decoded[index]["meal"]);
                    FocusNode _mealFocusNode;
                    QuillController _controller = new QuillController(
                        document: Document.fromJson(myJSON),
                        selection: TextSelection.collapsed(offset: 0));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        height: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "${decoded[index]["name"]}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
                                ],
                              ),
                              Expanded(
                                child: QuillEditor.basic(
                                  autoFocus: false,
                                  controller: _controller,
                                  readOnly: true,
                                ),
                              ),
                              Container(
                                child: widget.mainMenu == true
                                    ? ActionButtons(
                                        delete: () {},
                                        copy: () async {
                                          var result = await Provider.of<
                                                      MealPlanMakerData>(
                                                  context,
                                                  listen: false)
                                              .sendMeal(
                                                  Provider.of<TrainerSignUpData>(
                                                          context,
                                                          listen: false)
                                                      .trainerData
                                                      .data["_id"],
                                                  {
                                                'name': decoded[index]["name"],
                                                'meal': jsonEncode(myJSON),
                                              });
                                          var baseDialog;
                                          if (result != true) {
                                            baseDialog = CustomAlertBox(
                                              infolist: <Widget>[
                                                Text(
                                                    "There was an error submitting your workout. Try again later."),
                                              ],
                                              actionlist: <Widget>[
                                                FlatButton(
                                                  child: Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(true);
                                                    // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                                                    // Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          } else {
                                            baseDialog = CustomAlertBox(
                                              infolist: <Widget>[
                                                Text(
                                                    "Document has been saved."),
                                              ],
                                              actionlist: <Widget>[
                                                FlatButton(
                                                  child: Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(true);
                                                    setState(() {});
                                                    // Provider.of<TrainerSignUpData>(context,listen: false).resetData();
                                                    // Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  baseDialog);
                                        },
                                        edit: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushNamed(
                                                  TrainerMealPlanMaker.id,
                                                  arguments: {
                                                "title": decoded[index]["name"],
                                                "mealid": decoded[index]["_id"],
                                                "mealPlan": myJSON,
                                                "type": 0
                                              });
                                        },
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          } else {
            return SizedBox();
          }
        });
  }
}
