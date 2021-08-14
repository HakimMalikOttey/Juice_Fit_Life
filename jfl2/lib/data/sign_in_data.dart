import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jfl2/data/hash.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/main.dart';

class CheckAccount {
  static Future checkUser(String user, String pass) async {
    final send = await HttpCallRequest.postRequest(
        "/signin", {'name': user, 'password': pass});
    return send;
    // final http.Response response = await http.post(Uri.https('$link', "/"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, String>{'name': user, 'password': pass}));
    // return jsonDecode(response.body);
  }
}
