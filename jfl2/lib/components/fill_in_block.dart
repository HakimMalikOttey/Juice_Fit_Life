import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FillInBlock extends StatelessWidget {
  final String day;
  final VoidCallback addworkout;
  final VoidCallback addrest;
  FillInBlock(
      {required this.day, required this.addworkout, required this.addrest});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$day", style: Theme.of(context).textTheme.headline6),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: addworkout,
                    child: Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 3.0, color: Colors.purple)),
                      child: Column(
                        children: [
                          Expanded(
                              child: Icon(
                            Icons.add,
                            color: Theme.of(context).accentColor,
                            size: 35.0,
                          )),
                          Expanded(
                              child: Text(
                            "Fill Day",
                            style: Theme.of(context).textTheme.headline1,
                            softWrap: true,
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
