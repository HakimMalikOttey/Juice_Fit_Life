import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewBox extends StatelessWidget {
  final String label;
  final Widget items;
  final VoidCallback edit;
  // final int index;
  ReviewBox({
    required this.label,
    required this.items,
    required this.edit,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$label", style: Theme.of(context).textTheme.headline6),
            GestureDetector(
                onTap: edit,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.edit, color: Colors.yellow),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}
