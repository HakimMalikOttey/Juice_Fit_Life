import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/data/firebase_function.dart' as firebasefunction;
import 'package:http/http.dart' as http;
import 'package:jfl2/data/picture_data.dart';
import 'package:jfl2/data/plan_partition_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PlanEditorData extends ChangeNotifier {
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _description = new TextEditingController();
  QuillController _controller = QuillController.basic();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<PictureData> _pictures = [
    new PictureData(cloudImage: null),
    new PictureData(cloudImage: null),
    new PictureData(cloudImage: null),
    new PictureData(cloudImage: null)
  ];
  List<PlanPartitionData> _Partitions = [];
  final String _plancall = "/plans";

  TextEditingController get name => _name;
  TextEditingController get description => _description;
  QuillController get controller => _controller;
  set controller(QuillController value) {
    _controller = value;
    notifyListeners();
  }

  ImagePicker get picker => _picker;
  List<PictureData> get pictures => _pictures;
  set pictures(List<PictureData> value) {
    _pictures = value;
    notifyListeners();
  }

  File? get image => _image;

  set Image(File? value) {
    _image = value;
    notifyListeners();
  }

  List<PlanPartitionData> get Partitions => _Partitions;

  set Partitions(List<PlanPartitionData> value) {
    _Partitions = value;
    notifyListeners();
  }

  forceUpdate() {
    notifyListeners();
  }

  void addPartition(String name, String id) {
    _Partitions.add(new PlanPartitionData(name: name, id: id));
    notifyListeners();
  }

  void removePartition(int index) {
    Partitions.removeAt(index);
    notifyListeners();
  }

  getlink(TaskSnapshot image) async {
    return await image.ref.getDownloadURL();
  }

  fetchData(int cell, TaskSnapshot image) async {
    _pictures[cell].cloudImage = await image.ref.getDownloadURL();
    print(_pictures[cell].cloudImage);
    notifyListeners();
  }

  clearData() {
    _name.clear();
    _description.clear();
    _Partitions.clear();
    _pictures.forEach((element) {
      element.cloudImage = null;
    });
    _controller = QuillController.basic();
  }

  Future refCopy(FirebaseStorage instance, String url) async {
    final Uint8List pictureData = await instance.refFromURL(url).getData() as Uint8List;
    final File Uint8File = File.fromRawPath(pictureData);
    String fileName = basename(Uint8File.path);
    Reference firebaseStorageRef =
        instance.ref().child("folderName").child("$fileName");
    return firebaseStorageRef.putFile(Uint8File);
  }

  Future refDelete(FirebaseStorage instance, String url) {
    return instance.refFromURL(url).delete().then((value) {
      return "finished";
    });
  }

  removeImage(int index, BuildContext context) async {
    final tempPic = _pictures[index].cloudImage;
    print(_pictures[index].cloudImage);
    FirebaseStorage _storage = FirebaseStorage.instance;
    Navigator.pop(context);
    notifyListeners();
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
            future: refDelete(_storage, _pictures[index].cloudImage as String),
            successRoutine: (data) {
              _pictures[index].cloudImage = null;
              return WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                notifyListeners();
                Navigator.pop(context);
              });
            },
            failedRoutine: (data) {
              return CustomAlertBox(
                infolist: <Widget>[
                  Text(
                      "There was an error while removing this image. Please try again later.")
                ],
                actionlist: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Ok"))
                ],
              );
            },
            errorRoutine: (data) {
              return CustomAlertBox(
                infolist: <Widget>[
                  Text(
                      "There was a major error while removing this image. Please try again later.")
                ],
                actionlist: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Ok"))
                ],
              );
            }));
  }

  retrieveImage(int index, BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [CropAspectRatioPreset.ratio16x9]) as File;
      if (croppedFile != null) {
        File _image;
        FirebaseStorage _storage = FirebaseStorage.instance;
        _image = croppedFile;
        String fileName = basename(_image.path);
        Reference firebaseStorageRef =
            _storage.ref().child("folderName").child("$fileName");
        showDialog(
            context: context,
            builder: (context) => LoadingDialog(
                future: firebaseStorageRef.putFile(_image),
                successRoutine: (linkData) {
                  TaskSnapshot uploadTask = linkData.data;
                  return WidgetsBinding.instance
                      ?.addPostFrameCallback((timeStamp) {
                    fetchData(index, uploadTask);
                    notifyListeners();
                    Navigator.pop(context);
                  });
                },
                failedRoutine: (data) {
                  return CustomAlertBox(
                    infolist: <Widget>[
                      Text(
                          "There was an error while uploading this image. Please try again later.")
                    ],
                    actionlist: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
                },
                errorRoutine: (data) {
                  return CustomAlertBox(
                    infolist: <Widget>[
                      Text(
                          "There was a major error in uploading this image. Please try again later.")
                    ],
                    actionlist: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Ok"))
                    ],
                  );
                }));
      }
    } else {
      print("Image not selected");
    }
  }

  Future createPlan(String id, Map body) async {
    final plan = await HttpCallRequest.postRequest("$_plancall/$id", body);
    return plan;
  }

  Future retrievePlanData(String id) async {
    final plan = await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return plan;
  }

  Future editPlan(String id, Map body) async {
    final plan = await HttpCallRequest.putRequest("$_plancall/$id", body);
    return plan;
  }

  Future copyPlan(String id, Map body) async {
    final plans =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return plans;
  }

  Future getPlan(String id, Map<String, dynamic> query) async {
    final plan = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return plan;
  }

  Future deletePlan(String id, Map body) async {
    final plan = await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return plan;
  }

  planValidation(int type, BuildContext context, String id) {
    List<String> PartitionIds = [];
    List<String> pictureURLs = [];
    _Partitions.forEach((element) {
      PartitionIds.add(element.id);
    });
    _pictures.forEach((element) {
      if(element.cloudImage != null) {
        pictureURLs.add(element.cloudImage as String);
      }
    });
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(
              future: type == 1
                  ? createPlan(Provider.of<UserData>(context).id as String, {
                      "name": _name.text,
                      "description": _description.text,
                      "explanation":
                          jsonEncode(_controller.document.toDelta().toJson()),
                      "pictures": pictureURLs,
                      "partitions": PartitionIds,
                    })
                  : Provider.of<PlanEditorData>(context).editPlan(id, {
                      "name": _name.text,
                      "description": _description.text,
                      "explanation":
                          jsonEncode(_controller.document.toDelta().toJson()),
                      "pictures": pictureURLs,
                      "partitions": PartitionIds,
                    }),
              successRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[Text("Plan has been saved.")],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          clearData();
                          WidgetsBinding.instance
                              ?.addPostFrameCallback((timeStamp) {
                            Navigator.pop(context);
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Ok"))
                  ],
                );
              },
              failedRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was an error saving this plan. Please try again later.")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              },
              errorRoutine: (data) {
                return CustomAlertBox(
                  infolist: <Widget>[
                    Text(
                        "There was a major error saving this plan. Please try again later.")
                  ],
                  actionlist: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Ok"))
                  ],
                );
              },
            ));
  }
}
