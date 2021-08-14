// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// class Thumbnail {
//  static Future  getthumb(String file) async{
//     final uint8list = await VideoThumbnail.thumbnailData(
//       video: file,
//       imageFormat: ImageFormat.WEBP,
//       maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//       quality: 75,
//     );
//     // final file = File(uint8list);
//     // final bytes = file.readAsBytesSync();
//     return uint8list;
//   }
// }