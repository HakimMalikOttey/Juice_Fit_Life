import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class FireBaseFunction {

  Future uploadFirebaseFile(File image) async{
    var uuid = new Uuid();
    final String id = uuid.v4();
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot = await _firebaseStorage.ref().child('folderName/$id').putFile(image);
    var downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}