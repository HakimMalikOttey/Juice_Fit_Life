import 'package:flutter/material.dart';
import 'package:jfl2/components/square_button.dart';

class AddButton extends StatelessWidget{
  final action;
  final String? text;
  AddButton({@required this.action,@required this.text});
  @override
  Widget build(BuildContext context) {
    return SquareButton(
        color: Colors.black,
        pressed: action,
        butContent: Row(
          children: [
            Text("$text",style: Theme.of(context).textTheme.headline1,),
            SizedBox(
              width: 10.0,
            ),
            Icon(Icons.add_circle_outline_outlined)
          ],
        ),
        buttonwidth: MediaQuery.of(context).size.width);
  }
}