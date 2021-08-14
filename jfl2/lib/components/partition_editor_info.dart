import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:provider/provider.dart';

class PartitionEditorInfo extends StatefulWidget {
  final bool active;
  PartitionEditorInfo({required this.active});
  @override
  _PartitionEditorInfoState createState() => _PartitionEditorInfoState();
}

class _PartitionEditorInfoState extends State<PartitionEditorInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainerPartitionEditorData>(
        builder: (context, data, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              child: CustomTextBox(
                active: widget.active,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                ],
                controller: data.name,
                labelText: 'Your Partition Name...(Required)',
                onChanged: (text) {
                  setState(() {});
                },
                maxlength: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              child: CustomTextBox(
                active: widget.active,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                ],
                controller: data.description,
                labelText: 'Explain Your Partition...',
                onChanged: (text) {
                  setState(() {});
                },
                maxlength: 200,
                lines: 5,
              ),
            ),
          ),
        ],
      );
    });
  }
}
