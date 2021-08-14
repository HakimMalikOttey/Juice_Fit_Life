import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/background_image_container.dart';

class AnimatedBackground extends StatefulWidget{
  AnimatedBackground();

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin{
  late Timer timerobj;

  late Timer scaleTimer;
  int curindex = 0;
  int time = 0;
  late Widget _index;
  double scale = 1.0;
  Random random = new Random();
  var tempnum = 0;
  List<Widget> backgroundImages = [];
  @override
  void initState() {
    super.initState();
    backgroundImages = [
      Container(
        key: ValueKey<int>(0),
        child: BackgroundImageContainer(
          img: "assets/jf_1.jpg",
        ),
      ),
      Container(
        key: ValueKey<int>(1),
        child: BackgroundImageContainer(
          img: "assets/jf_2.jpg",
        ),
      ),
      Container(
        key: ValueKey<int>(2),
        child: BackgroundImageContainer(
          img: "assets/jf_3.jpg",
        ),
      ),
      Container(
        key: ValueKey<int>(3),
        child: BackgroundImageContainer(
          img: "assets/jf_4.jpg",
        ),
      ),
      Container(
        key: ValueKey<int>(4),
        child: BackgroundImageContainer(
          img: "assets/jf_5.jpg",
        ),
      ),
      Container(
        key: ValueKey<int>(5),
        child: BackgroundImageContainer(
          img: "assets/jf_6.jpg",
        ),
      ),
    ];
    _index = backgroundImages[curindex];
    timerobj  = Timer.periodic(const Duration(seconds: 1), (timer){
      if(time != 10){
        time++;
        if (this.mounted){
          setState(() {
            time++;
          });
        }
      }
      else{
        time = 0;
        scale = 1.0;
        List<int> numbers = [];
        for(int i = 0; i != backgroundImages.length;i++){
          numbers.add(i);
        }
        numbers.shuffle();
        numbers.removeWhere((element) => element == tempnum);
        tempnum = numbers[0];
        if(this.mounted){
          setState(() {
            _index = backgroundImages[tempnum];
          });
        }
      }
      // if(widget.timerobj != null) widget.timerobj.cancel();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timerobj.cancel();
    super.dispose();
  }
  @override
  void deactivate() {
    timerobj.cancel();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (child,animation){
              return FadeTransition(child: child,opacity: animation,);
            },
            child: _index
          ),
        ],
      ),
    );
  }
}