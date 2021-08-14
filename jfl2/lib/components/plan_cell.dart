import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PlanCell extends StatelessWidget{
  final title;
  final content;
  final action;
  final  completed;
  final year;
  final date;
  final time;
  PlanCell({@required this.title, @required this.content,this.action,this.completed,this.year,this.date,this.time});
  Widget build(BuildContext context){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        height: 85.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("$title",style: Theme.of(context).textTheme.headline3,),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Divider(
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0,right:5.0 ),
                    child: Text("10 workouts"),
                  ),
                  Expanded(
                    child: Divider(
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: content != null ? content: Text("")),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Click To Learn More ...",style: Theme.of(context).textTheme.headline1)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
