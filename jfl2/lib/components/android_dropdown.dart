import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class DropListButton extends StatelessWidget {
  final change;
  final startingData;
  final dataList;
  final butColor;
  final color;
  final width;
  DropListButton({@required this.change,@required this.startingData, @required this.dataList,@required this.butColor,@required this.color,@required this.width});
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>>dropdownItems = [];
    for (String data in dataList){
      var newitem = DropdownMenuItem(
        child: Text(data,style: TextStyle(color: Colors.black)),
        value: data,
      );
      dropdownItems.add(newitem);
    }
    return  Container(
      alignment: Alignment.bottomCenter,
      width:width,
      height: 40.0,
      color: butColor,
      child: DropdownButton<String>(
        icon: Icon(Icons.arrow_drop_down,color: color),
        underline: SizedBox(),
        selectedItemBuilder: (BuildContext context){
          return dataList.map<Widget>((value){
            return Center(child: Text( value, style: TextStyle(color:Colors.white)));
          }).toList();
        },
        value: startingData,
        items:dropdownItems,
        onChanged: change
      ),
    );
  }
}