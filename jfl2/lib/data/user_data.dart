import 'package:flutter/cupertino.dart';
import 'package:jfl2/data/http_call_request.dart';
import 'dart:convert';
import 'filter_actions.dart';

class UserData extends ChangeNotifier {
  String? _id;
  String? _encapsulatedNav;
  bool queryReload = false;
  Map<String, dynamic> sort = filters[0];
  //Is used to authenticate a user who has authed Vimeo inside of Juice Fit Life to the Vimeo API
  String access_token = "";
  String scope = "";
  String name = "";
  TextEditingController search = new TextEditingController();
  Function()? searchAction;
  Function()? miniSearchAction;
  String? get encapsulatedNav => this._encapsulatedNav;

  set encapsulatedNav(String? value) {
    this._encapsulatedNav = value;
    notifyListeners();
  }

  ValueNotifier<bool> _batchOperation = new ValueNotifier(false);
  ValueNotifier<List> _QueryIds = new ValueNotifier([]);
  ValueNotifier<bool> _QueryIdsLength = new ValueNotifier(false);

  ValueNotifier<bool> get QueryIdsLength => this._QueryIdsLength;

  set QueryIdsLength(ValueNotifier<bool> value) {
    this._QueryIdsLength = value;
    notifyListeners();
  }

  Future getVimeoId() async {
    final vimeo = await HttpCallRequest.getRequest("vimeo/$id", {});
    return vimeo;
  }

// 'basic base64_encode($id:$secret)'
  Future createVimeoId(String authcode, String redirect) async {
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    final String id = "6d6a413a6f0e83c3b0c82a105d7f26f93f4724b2";
    final String secret =
        "TZdIuK/k2PMwRmFlKmJPZhn2DfYvFW0XfPOz8o7TkqKPeUJ75wmm0b7J0A34u4vLiQCwFnc2qZVcCfpxPxC5b+TRlJyq18cMSXNKnoGBTZxGZZj6NL2zevv80T+YRpxH";
    final String cred = "$id:$secret";
    final vimeo = await HttpCallRequest.postRequestVimeo(
        Uri.https("api.vimeo.com", "/oauth/access_token"), {
      "grant_type": "authorization_code",
      "code": "$authcode",
      "redirect_uri": "hakimottey.juicefitlife://login-callback"
    }, {
      'Authorization': 'basic ${stringToBase64Url.encode(cred)})',
      'Content-Type': 'application/json',
      'Accept': 'application/vnd.vimeo.*+json;version=3.4'
    });
    return vimeo;
  }

  Future submitVimeoRequest(String id, Map<String, dynamic> body) async {
    final meal = await HttpCallRequest.putRequest("/vimeo/$id", body);
    return meal;
  }

  Future getVimeoVideos() async {
    final videos = await HttpCallRequest.vimeogetRequest(
        Uri.https("api.vimeo.com", "/me/videos",), {
      'Authorization': 'bearer $access_token',
      'Content-Type': 'application/json',
      'Accept': 'application/vnd.vimeo.*+json;version=3.4'
    });
    print("---------------------");
    print(videos);
    print("---------------------");
    return videos;
  }
  // Future submitVimeoRequest(String user, String pass) async {
  //   final send = await HttpCallRequest.postRequest(
  //       "/vimeo", {'name': user, 'password': pass});
  //   return send;
  //   // final http.Response response = await http.post(Uri.https('$link', "/"),
  //   //     headers: <String, String>{
  //   //       'Content-Type': 'application/json; charset=UTF-8',
  //   //     },
  //   //     body: jsonEncode(<String, String>{'name': user, 'password': pass}));
  //   // return jsonDecode(response.body);
  // }
  // List _QueryIds = [];

  ValueNotifier<bool> get BatchOperation => this._batchOperation;

  set BatchOperation(ValueNotifier<bool> batchOperation) {
    this._batchOperation = batchOperation;
    notifyListeners();
  }

  String? get id => this._id;

  set id(String? value) {
    this._id = value;
    notifyListeners();
  }

  ValueNotifier<List> get QueryIds => this._QueryIds;

  set QueryIds(ValueNotifier<List> value) {
    this._QueryIds = value;
    notifyListeners();
  }
}
