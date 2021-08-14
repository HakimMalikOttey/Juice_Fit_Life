import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSelectorBox extends StatelessWidget{
  final Widget image;
  ImageSelectorBox({required this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180.0,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          // alignment: Alignment.center,
          fit:StackFit.expand,
          children: [
            image,
            Container(
              color: Colors.grey.withOpacity(0.3),
            ),
            Center(
              child: Icon(Icons.camera_alt,color: Colors.white,),
            ),
          ],
        )
    );
  }
}