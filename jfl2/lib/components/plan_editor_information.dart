import 'dart:io';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'custom_alert_box.dart';
import 'dialog_quill_container.dart';
import 'dialog_typer.dart';
import 'image_selector_box.dart';

class PlanEditorInformation extends StatefulWidget {
  final type;
  final banner;
  PlanEditorInformation({@required this.type, @required this.banner});
  @override
  _PlanEditorInformationState createState() => _PlanEditorInformationState();
}

class _PlanEditorInformationState extends State<PlanEditorInformation> {
  final picker = ImagePicker();
  late ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer<PlanEditorData>(builder: (context, data, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Plan Pictures",
                style: Theme.of(context).textTheme.headline6,
              ),
              DragAndDropGridView(
                  // controller: _scrollController,
                  itemCount: data.pictures.length,
                  onWillAccept: (oldIndex, newIndex) {
                    if (data.pictures[oldIndex].cloudImage == null &&
                        data.pictures[newIndex].cloudImage == null) {
                      return false;
                    } else if (data.pictures[oldIndex].cloudImage != null &&
                        data.pictures[newIndex].cloudImage == null) {
                      return false;
                    } else if (data.pictures[newIndex].cloudImage != null &&
                        data.pictures[oldIndex].cloudImage == null) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  onReorder: (oldIndex, newIndex) {
                    var _temp = data.pictures[newIndex];
                    data.pictures[newIndex] = data.pictures[oldIndex];
                    data.pictures[oldIndex] = _temp;
                    setState(() {});
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 4 / 4.5),
                  itemBuilder: (context, index) => Padding(
                        key: Key('$index'),
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(builder: (context) {
                          if (data.pictures[index].cloudImage == null) {
                            return GestureDetector(
                              onTap: () {
                                data.retrieveImage(index, context);
                              },
                              child: Container(
                                height: 150.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3.0, color: Colors.purple),
                                ),
                                child: Center(
                                  child: Text(
                                    "Image ${index + 1}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: PlanMakerPopUp(
                                            name: "",
                                            listview: [
                                              Expanded(child: Container())
                                            ],
                                            remove: () {
                                              return Provider.of<
                                                          PlanEditorData>(
                                                      context,
                                                      listen: false)
                                                  .removeImage(index, context);
                                              // Navigator.pop(context);
                                            },
                                          ),
                                        ));
                                // data.retrieveImage(index, context);
                              },
                              child: Container(
                                height: 150.0,
                                width: 150.0,
                                child: Center(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "assets/no_pic.png",
                                    image: data.pictures[index].cloudImage as String,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      )),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: CustomTextBox(
                  controller: data.name,
                  active: true,
                  labelText: 'Your Plan Name (Required)',
                  onChanged: (text) {
                    data.forceUpdate();
                  },
                  maxlength: 20,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomTextBox(
                controller: data.description,
                active: true,
                hintText: "Quick Description (Required)",
                onChanged: (text) {
                  data.forceUpdate();
                },
                lines: 3,
                maxlength: 150,
              ),
            ],
          );
        })
      ],
    );
  }
}
