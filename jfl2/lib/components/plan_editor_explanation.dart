import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:provider/provider.dart';

class PlanEditorExplanation extends StatefulWidget {
  final type;
  PlanEditorExplanation({@required this.type});
  @override
  _PlanEditorExplanationState createState() => _PlanEditorExplanationState();
}

class _PlanEditorExplanationState extends State<PlanEditorExplanation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanEditorData>(builder: (context, data, child) {
      return Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.black))),
            child: Theme(
                data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(color: Colors.white)),
                child: QuillToolbar.basic(
                  controller: data.controller,
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
                  controller: data.controller,
                  readOnly: widget.type != 2 ? false : true,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
