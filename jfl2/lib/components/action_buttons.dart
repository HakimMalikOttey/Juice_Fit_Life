import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget{
  final delete;
  final copy;
  final edit;
  final VoidCallback? upload;
  final bool? validData;
  ActionButtons({@required this.delete, @required this.copy, @required this.edit,this.upload,this.validData});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: delete,
            child: Icon(Icons.delete,color: Colors.red,)),
        SizedBox(
          width: 10.0,
        ),
        Container(
          child: validData == true ? GestureDetector(
              onTap: copy,
              child: Icon(Icons.copy, color:Colors.blue)): Icon(Icons.copy, color:Colors.grey),
        ),
        SizedBox(
          width: 10.0,
        ),
        GestureDetector(
            onTap: edit,
            child: Icon(Icons.edit, color:Colors.yellow)),
        Container(
          child: upload != null ? Container(
            child: validData == true? GestureDetector(
              onTap: upload,
              child: Icon(Icons.upload_rounded,color: Colors.green,),
            ):Icon(Icons.upload_rounded,color: Colors.grey,),
          ):Container(),
        )
      ],
    );
  }
}