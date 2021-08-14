import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadChoices extends StatefulWidget{
  @override
  _UploadChoicesState createState() => _UploadChoicesState();
}

class _UploadChoicesState extends State<UploadChoices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView(
         children:ListTile.divideTiles(
           context: context,
             tiles: [
               ListTile(
                 title: Padding(
                   padding: const EdgeInsets.only(bottom: 10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Save and Push To The Store",style: Theme.of(context).textTheme.headline6,),
                       SizedBox(
                         height: 10.0,
                       ),
                       Text("Save this plan and create a usable plan and make it live on the app store for everyone to purchase and use.",style: Theme.of(context).textTheme.headline1)
                     ],
                   ),
                 ),
                 onTap: (){

                 },
               ),
               ListTile(
                 title: Padding(
                   padding: const EdgeInsets.only(bottom: 10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Save This Plan",style: Theme.of(context).textTheme.headline6,),
                       SizedBox(
                         height: 10.0,
                       ),
                       Text("Save this plan so that you can edit it later.",style: Theme.of(context).textTheme.headline1)
                     ],
                   ),
                 ),
                 onTap: (){

                 },
               ),
             ],
         ).toList()
      ),
    );
  }
}