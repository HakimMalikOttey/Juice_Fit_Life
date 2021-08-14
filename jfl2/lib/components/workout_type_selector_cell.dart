import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutTypeSelectorCell extends StatelessWidget{
  final title;
  final description;
  final ontap;
  WorkoutTypeSelectorCell({@required this.title, @required this.description, @required this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          color: Theme.of(context).cardColor,
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$title",style: Theme.of(context).textTheme.headline6,),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(child: Text("$description"))
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).accentColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}