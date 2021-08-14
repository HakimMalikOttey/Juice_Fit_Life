import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class YoutubePresentation extends StatefulWidget{
//   static String id = "YoutubePresentation";
//   @override
//   final String? link;
//   YoutubePresentation({this.link});
//   _YoutubePresentationState createState() => _YoutubePresentationState();
// }
//
// class _YoutubePresentationState extends State<YoutubePresentation> {
//   late YoutubePlayerController youtubecontroller;
//   @override
//   void initState() {
//      youtubecontroller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(
//           "${widget.link}"),
//       flags: YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text('Stretch Example'),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: YoutubePlayer(
//             controller: youtubecontroller,
//             liveUIColor: Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
// }