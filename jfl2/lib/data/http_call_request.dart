import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jfl2/main.dart';

class HttpCallRequest {
  static Future postRequest(String call, Map body) async {
    final http.Response response = await http.post(Uri.https('$link', "$call"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  static Future postRequestVimeo(
      Uri call, Map body, Map<String, String> headers) async {
    final http.Response response =
        await http.post(call, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  static Future getRequest(String call, Map<String, dynamic> query) async {
    print(call);
    final http.Response response = await http.get(
      Uri.https('$link', "$call", query),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  static Future vimeogetRequest(Uri call, Map<String, String> headers) async {
    print(call);
    final http.Response response = await http.get(
      call,
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  static Future putRequest(String call, Map body) async {
    final http.Response response = await http.put(Uri.https('$link', "$call"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  static Future deleteRequest(String call, Map body) async {
    final http.Response response =
        await http.delete(Uri.https('$link', "$call"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${response.statusCode}');
    }
  }
}
