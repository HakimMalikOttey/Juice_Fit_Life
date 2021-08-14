import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTimer {
  int sec = 0;
  int min = 0;
  int hour = 0;
  StateSetter? setStateFromOutside;
 Future OpenTimerDialog(BuildContext context){
   return showDialog(context: context,builder: (context)=>StatefulBuilder(
     builder: (context, StateSetter setState) {
       setStateFromOutside = setState;
       return WillPopScope(
          onWillPop: (){
            return Future.value(false);
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$hour:$min:$sec",style: Theme.of(context).textTheme.headline3?.copyWith( fontSize: 40.0),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LinearProgressIndicator(
                      minHeight: 10.0,
                      value: 1.0,
                      backgroundColor: Theme.of(context).accentColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      // strokeWidth: 10.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                           return Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Text("Cancel",style: Theme.of(context).textTheme.headline6,),
                                Icon(Icons.close, color: Colors.red,)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                           return Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Text("Pause",style: Theme.of(context).textTheme.headline6),
                                Icon(Icons.pause, color: Colors.blue,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
     }
   ));
  }
}
