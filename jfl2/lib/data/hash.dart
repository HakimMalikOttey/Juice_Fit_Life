import 'package:crypto/crypto.dart';
import 'dart:convert';
class hasher {
   hashpass(String hashstring){
    var bytes = utf8.encode(hashstring); // data being hashed
    var digest = sha256.convert(bytes);
    return digest;
  }
}