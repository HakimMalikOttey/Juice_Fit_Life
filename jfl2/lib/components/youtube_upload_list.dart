import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/youtube_presentation.dart';
import 'package:jfl2/components/youtube_presentation.dart';

// class YoutubeUploadList extends StatefulWidget{
//   final ScrollController scrollController;
//   final List<TextEditingController> youtubeLinks;
//   final bool menu;
//   VoidCallback? callback;
//   YoutubeUploadList({
//     required this.scrollController,
//     required this.youtubeLinks,
//     required this.menu,
//     this.callback
//   });
//
//   @override
//   _YoutubeUploadListState createState() => _YoutubeUploadListState();
// }
//
// class _YoutubeUploadListState extends State<YoutubeUploadList> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 400.0,
//       child: ReorderableListView(
//         scrollController: widget.scrollController,
//         children: <Widget>[
//           for (int index = 0;
//           index < widget.youtubeLinks.length;
//           index++)
//             Builder(
//               key:Key('$index'),
//               builder: (context){
//                 return YoutubePresentationBox(
//                   callback: widget.callback,
//                   active: widget.menu,
//                   delete: GestureDetector(
//                       onTap: (){
//                         widget.callback!();
//                           widget.youtubeLinks.removeAt(index);
//                       },
//                       child: Icon(Icons.delete,color: Colors.red,)),
//                   youtubeLink: widget.youtubeLinks[index],
//                   change: (text) {
//                       widget.callback!();
//                       widget.youtubeLinks[index].text = widget.youtubeLinks[index].text.trim();
//                   },
//                   youtubeWindow: Builder(
//                       builder: (context) {
//                         var uint8list;
//                         // String validate = getIdFromUrl("${widget.youtubeLinks[index].text.trim()}");
//                         print(validate);
//                         uint8list = "https://img.youtube.com/vi/$validate/0.jpg";
//                         if(validate != null){
//                           return GestureDetector(
//                             onTap: (){
//                               Navigator.pushNamed(context, YoutubePresentation.id,arguments: {
//                                 "link":widget.youtubeLinks[index].text
//                               });
//                             },
//                             child: Container(
//                               height: 200.0,
//                               width: MediaQuery.of(context).size.width,
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(image: NetworkImage(uint8list),fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.black.withOpacity(0.5),
//                                     ),
//                                   ),
//                                   Container(
//                                       child: Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 100.0,)))
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//                         else{
//                           return Container(
//                             height: 200.0,
//                             width: MediaQuery.of(context).size.width,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   color: Colors.grey,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withOpacity(0.5),
//                                   ),
//                                 ),
//                                 Container(
//                                     child: Center(child: Icon(Icons.error,color: Colors.white,size: 100.0,)))
//                               ],
//                             ),
//                           );
//                         }
//                       }
//                   ),
//                 );
//               },
//             )
//         ],
//         onReorder: (int oldIndex, int newIndex) {
//           setState(() {
//             if (oldIndex < newIndex) {
//               newIndex -= 1;
//             }
//             final item = widget.youtubeLinks.removeAt(oldIndex);
//             widget.youtubeLinks.insert(newIndex, item);
//           });
//         },
//       ),
//     );
//   }
// }