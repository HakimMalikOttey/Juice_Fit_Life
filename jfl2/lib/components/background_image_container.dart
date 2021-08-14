import 'package:flutter/cupertino.dart';

class BackgroundImageContainer extends StatefulWidget{
  final String img;
  BackgroundImageContainer({required this.img});
  @override
  _BackgroundImageContainerState createState() => _BackgroundImageContainerState();
}

class _BackgroundImageContainerState extends State<BackgroundImageContainer> with TickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _controller1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 20000));
    _animation = new Tween<double>(begin:0.5 ,end:1.0).animate(
        new CurvedAnimation(
            parent: _controller1,
            curve: Curves.easeIn.flipped,
        )
    );
    // _controller1.repeat();
  }
  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _controller1.repeat();
    return ScaleTransition(
      scale:_animation ,
      child: Transform.scale(
          scale: 2.0,
          child: Container(
              decoration: BoxDecoration(
                image:DecorationImage(
                  image: AssetImage("${widget.img}"),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, -55,
                    0.2126, 0.7152, 0.0722, 0, -55,
                    0.2126, 0.7152, 0.0722, 0, -55,
                    0, 0, 0, 1, 0,
                  ]),
                ),
              ))),
    );
  }
}