import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/single_line_textfield.dart';

class NutritionField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final Function onChanged;
  final bool active;
  NutritionField(
      {required this.name,
      required this.controller,
      required this.onChanged,
      required this.active});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("$name"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomTextBox(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                controller: controller,
                active: active,
                labelText: '$name',
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
