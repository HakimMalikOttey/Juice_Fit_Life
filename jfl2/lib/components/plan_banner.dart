import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanBanner extends StatelessWidget {
  final name;
  final author;
  final img;
  final pressed;
  final description;
  final calltoaction;
  final boughtdate;
  PlanBanner(
      {@required this.name,
      @required this.author,
      @required this.img,
      @required this.pressed,
      this.description,
      this.calltoaction,
      this.boughtdate});
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        height: 270.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 10.0,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(img), fit: BoxFit.fill)),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$name",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        child: boughtdate != null ? boughtdate : Text(""),
                      )
                    ],
                  ),
                  Text("By $author"),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(child: description != null ? description : Text("")),
                  Container(
                      child: calltoaction != null ? calltoaction : Text("")),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
