import 'package:http/http.dart' as http;
import 'package:jfl2/data/http_call_request.dart';

import '../main.dart';

class emailPassword {
  static Future emailpass(String email) async {
    final send = await HttpCallRequest.postRequest('/reset', {
      "email": "$email",
    });
    return send;
    // final http.Response response = await http.g(Uri.https('$link', "/register"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(data));
    // // request.fields['data'] = json.encode(data);
    // // var res = await request.send();
    // List responsedata = [response.statusCode, jsonDecode(response.body)];
    // return responsedata;
  }
}
