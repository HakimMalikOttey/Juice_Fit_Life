// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:export_video_frame/export_video_frame.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// class GetThumbnail {
//
//   Future<Uint8List> createthumb(String path) async{
//     final thumbnail = await VideoThumbnail.thumbnailData(
//         video: path,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight:3,
//       maxWidth: 2,
//       quality: 10
//     );
//     print("----------------------------${thumbnail}");
//     return thumbnail;
//   }
// }