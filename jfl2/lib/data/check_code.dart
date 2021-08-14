import 'package:http/http.dart' as http;
import 'package:jfl2/data/http_call_request.dart';

import '../main.dart';

class checkCode {
  static Future codeCheck(String code) async {
    final send = await HttpCallRequest.getRequest('/code/$code',{});
    return send;
  }
}
