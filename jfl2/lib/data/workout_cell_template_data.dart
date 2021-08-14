import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/data/rep_data.dart';

class workoutCelltemplateData {
  TextEditingController name = new TextEditingController();
  List<RepData> reps = [];
  PickedFile? video;
  Uint8List? thumbnail;
  ValueNotifier<bool> legal = ValueNotifier<bool>(false);
}