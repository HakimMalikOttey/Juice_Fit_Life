import 'http_call_request.dart';

class ChangePassword {
  static Future changePass(String id, String pass) async {
    final send = await HttpCallRequest.postRequest(
        '/password', {"id": id, "password": pass});
    return send;
  }
}
