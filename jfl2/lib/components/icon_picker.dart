import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

class IconPicker extends StatefulWidget{
  @override
  _IconPicker createState() => _IconPicker();
}
class _IconPicker extends State<IconPicker> {
  final fileList = ["icon_1.jpg","icon_2.jpg","icon_3.jpg","icon_4.jpg","icon_5.jpg","icon_6.jpg","icon_7.jpg"];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      // color: Theme.of(context).,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: Row(
              children: List.generate(fileList.length, (index) => Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      Provider.of<TrainerSignUpData>(context,listen: false).Profpic = AssetImage("assets/${fileList[index]}");
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/${fileList[index]}"),
                            fit: BoxFit.fill
                        )
                    ),
                    height: 80.0,
                    width: 80.0,
                  ),
                ),
              ),)
            ),
          ),
        ),
      ),
    );
  }
}