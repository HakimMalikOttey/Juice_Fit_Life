import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class StretchMakerData extends ChangeNotifier {
  List<TextEditingController> _youtubeLinks = [];

  List<TextEditingController> get youtubeLinks => _youtubeLinks;

  set youtubeLinks(List<TextEditingController> value) {
    _youtubeLinks = value;
    notifyListeners();
  }

  appendLink() {
    TextEditingController _youtubelink = new TextEditingController();
    _youtubeLinks.add(_youtubelink);
    notifyListeners();
  }

  Future createstrecth(String id, Map body) async {
    final http.Response response =
        await http.post(Uri.https('$link', "/stretch/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body));
    return jsonDecode(response.body);
  }

  Future editstretch(String id, Map body) async {
    final http.Response response =
        await http.put(Uri.https('$link', "/stretch/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body));
    return jsonDecode(response.body);
  }

  Future getstretches(String id, Map<String, dynamic> query) async {
    final http.Response response = await http.get(
      Uri.https('$link', "/stretch/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.body;
  }

  Future deletestretch(String id) async {
    final http.Response response = await http.delete(
      Uri.https('$link', "/stretch/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.body;
  }
}
