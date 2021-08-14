import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/data/member_sign_up_data.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/main.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainerSignUpData extends ChangeNotifier {
  MemberSignupData _trainerData = new MemberSignupData();
  AssetImage? _Profpic;
  bool? _trainerValidation;

  bool? get trainerValidation => _trainerValidation;

  set trainerValidation(bool? value) {
    _trainerValidation = value;
    notifyListeners();
  }

  bool? _isNetwork;
  File? _Certpic;
  PickedFile? pick;
  String? _trainerCode;
  TextEditingController _piclink = new TextEditingController();

  TextEditingController get piclink => _piclink;

  set piclink(TextEditingController value) {
    _piclink = value;
  }

  bool? get isNetwork => _isNetwork;

  set isNetwork(bool? value) {
    _isNetwork = value;
    notifyListeners();
  }

  TrainerSignUpData() {
    _trainerData.callback = () => notifyListeners();
  }
  File? get Certpic => _Certpic;

  set Certpic(File? value) {
    _Certpic = value;
    notifyListeners();
  }

  AssetImage? get Profpic => _Profpic;

  set Profpic(AssetImage? value) {
    _Profpic = value;
    notifyListeners();
  }

  MemberSignupData get trainerData => _trainerData;

  set trainerData(MemberSignupData value) {
    _trainerData = value;
    _trainerData.callback = () => notifyListeners();
    notifyListeners();
  }

  Future userImageUpload(File image) async {
    try {
      var response = await http.post(Uri.https(link, "/sendFile"),
          body: {"pic": image.readAsBytesSync()});
      return response;
    } catch (e) {
      throw ('Error getting url');
    }
  }

  imgFromGallery(bool size) async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50) as PickedFile;
    pick = image;
    File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: size == true
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.ratio16x9]) as File;
    // notifyListeners();
    return cropped;
  }

  String? get trainercode => _trainerCode;

  set trainercode(String? value) {
    _trainerCode = value;
    notifyListeners();
  }

  void resetData() {
    trainerData = new MemberSignupData();
    // Profpic = null;
    // Certpic = null;
    notifyListeners();
  }

  trainerValidator() {
    if (_Profpic != null) {
      trainerValidation = true;
    } else {
      trainerValidation = false;
    }
  }
}
