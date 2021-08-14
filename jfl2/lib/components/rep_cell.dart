

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepCell extends StatefulWidget {
  @override
  _RepCellState createState() => _RepCellState();
}

class _RepCellState extends State<RepCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color:Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
          ),
          Text("Set X"),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                )),
          )),
          Text("x"),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                )),
          )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Expected"),
                Text("X * Y"),
              ],
            ),
          )

        ],
      ),
    );
  }

}