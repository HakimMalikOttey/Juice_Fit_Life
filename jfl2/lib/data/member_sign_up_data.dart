import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/main.dart';

class MemberSignupData {
  TextEditingController _fName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _userName = new TextEditingController();
  TextEditingController _nickName = new TextEditingController();
  bool? _freeusername;
  String _extension = '+39';
  int? _bDay;
  int? _bMonth;
  int? _bYear;
  String _gender = "";
  final List<String> genderList = [
    "- Select Gender -",
    "Male",
    "Female",
    "Other",
    "Prefer Not To Say"
  ];
  TextEditingController _email = new TextEditingController();
  bool? _freeemail;
  TextEditingController _password = new TextEditingController();
  bool? _freepassword;
  bool _hasspecial = false;
  bool _haslower = false;
  bool _hasUpper = false;
  bool _hasDigits = false;
  bool _islong = false;
  bool? _validEmail;
  TextEditingController _rPassword = new TextEditingController();

  TextEditingController _strName = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  String _memberid = "";
  TextEditingController _state = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  TextEditingController _zip = new TextEditingController();
  CancelableOperation? emailOperation;
  CancelableOperation? userNameOperation;
  bool _agreed = false;
  VoidCallback? callback;
  bool? _valid;

  bool? get valid => _valid;

  set valid(bool? value) {
    _valid = value;
    if (callback != null) callback!();
  }

  String get extension => _extension;

  set extension(String value) {
    _extension = value;
    if (callback != null) callback!();
  }

  // set genderList(List<String> value) {
  //   _genderList = value;
  //   if (callback != null) callback!();
  // }

  var _data;

  get data => _data;

  set data(value) {
    _data = value;
    if (callback != null) callback!();
  }

  bool? get validEmail => _validEmail;

  set validEmail(bool? value) {
    _validEmail = value;
    if (callback != null) callback!();
  }

  String get memberid => _memberid;

  MemberSignupData({this.callback}) {
    _gender = genderList[0];
    // var callback = this.callback
  }

  set memberid(String value) {
    _memberid = value;
    if (callback != null) callback!();
  }

  TextEditingController get state => _state;

  set state(TextEditingController value) {
    _state = value;
    if (callback != null) callback!();
  }

  bool get hasspecial => _hasspecial;

  set hasspecial(bool value) {
    _hasspecial = value;
    if (callback != null) callback!();
  }

  bool? get freepassword => _freepassword;

  set freepassword(bool? value) {
    _freepassword = value;
    if (callback != null) callback!();
  }

  bool? get freeusername => _freeusername;

  set freeusername(bool? value) {
    _freeusername = value;
    if (callback != null) callback!();
  }

  bool? get freeemail => _freeemail;

  set freeemail(bool? value) {
    _freeemail = value;
    if (callback != null) callback!();
  }

  bool get agreed => _agreed;

  set agreed(bool value) {
    _agreed = value;
    if (callback != null) callback!();
  }

  TextEditingController get fName => _fName;

  set fName(TextEditingController value) {
    _fName = value;
    if (callback != null) callback!();
  }

  TextEditingController get lName => _lName;

  set lName(TextEditingController value) {
    _lName = value;
    if (callback != null) callback!();
  }

  TextEditingController get userName => _userName;

  set userName(TextEditingController value) {
    _userName = value;
    if (callback != null) callback!();
  }

  TextEditingController get nickName => _nickName;

  set nickName(TextEditingController value) {
    nickName = value;
    if (callback != null) callback!();
  }

  TextEditingController get phone => _phone;

  set phone(TextEditingController value) {
    phone = value;
    if (callback != null) callback!();
  }

  int? get bDay => _bDay;

  set bDay(int? value) {
    _bDay = value;
    if (callback != null) callback!();
  }

  int? get bMonth => _bMonth;

  set bMonth(int? value) {
    _bMonth = value;
    if (callback != null) callback!();
  }

  int? get bYear => _bYear;

  set bYear(int? value) {
    _bYear = value;
    if (callback != null) callback!();
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
    if (callback != null) callback!();
  }

  TextEditingController get email => _email;

  set email(TextEditingController value) {
    _email = value;
    if (callback != null) callback!();
  }

  TextEditingController get password => _password;

  set password(TextEditingController value) {
    _password = value;
    checkpassword();
    if (callback != null) callback!();
  }

  TextEditingController get rPassword => _rPassword;

  set rPassword(TextEditingController value) {
    _rPassword = value;
    if (callback != null) callback!();
  }

  TextEditingController get strName => _strName;

  set strName(TextEditingController value) {
    _strName = value;
    if (callback != null) callback!();
  }

  TextEditingController get city => _city;

  set city(TextEditingController value) {
    _city = value;
    if (callback != null) callback!();
  }

  TextEditingController get country => _country;

  set country(TextEditingController value) {
    _country = value;
    if (callback != null) callback!();
  }

  TextEditingController get zip => _zip;

  set zip(TextEditingController value) {
    _zip = value;
    if (callback != null) callback!();
  }

  Future checkUsername(Map<String, dynamic> json) async {
    try {
      final http.Response response = await http
          .post(Uri.https('$link', "/username"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(json))
          .timeout(const Duration(minutes: 1), onTimeout: () {
        throw TimeoutException("Timed out");
      });
      return jsonDecode(response.body);
    } on SocketException {
      return null;
    }
  }

  Future checkEmail(Map<String, dynamic> json) async {
    try {
      final http.Response response = await http
          .post(Uri.https('$link', "/email"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(json))
          .timeout(const Duration(minutes: 1), onTimeout: () {
        throw TimeoutException("Timed out");
      });
      return jsonDecode(response.body);
    } on SocketException {
      return null;
    }
  }

  Future eulaaccept(Map<String, dynamic> json) async {
    final http.Response response =
        await http.put(Uri.https('$link', "/acceptEULA"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(json));
    return jsonDecode(response.body);
  }

  Future uploadfile(Map<String, dynamic> data) async {
    final send = await HttpCallRequest.postRequest("/register", data);
    return send;
    // final http.Response response =
    //     await http.post(Uri.https('$link', "/register"),
    //         headers: <String, String>{
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: jsonEncode(data));
    // // request.fields['data'] = json.encode(data);
    // // var res = await request.send();
    // List responsedata = [response.statusCode, jsonDecode(response.body)];
    // return responsedata;
  }

  bool get haslower => _haslower;

  set haslower(bool value) {
    _haslower = value;
    if (callback != null) callback!();
  }

  bool get hasUpper => _hasUpper;

  set hasUpper(bool value) {
    _hasUpper = value;
    if (callback != null) callback!();
  }

  bool get hasDigits => _hasDigits;

  set hasDigits(bool value) {
    _hasDigits = value;
    if (callback != null) callback!();
  }

  bool get islong => _islong;

  set islong(bool value) {
    _islong = value;
    if (callback != null) callback!();
  }

  void checkpassword() {
    var repeatednum = 0;
    var repeatedupper = 0;
    var repeatedlower = 0;
    if (_password.text != "") {
      //first check
      _hasspecial =
          _password.text.contains(new RegExp(r'[\[\]!@#$%^&*(),.?":{}|<>]'));
      //second check
      for (int i = 0; i < _password.text.length; i++) {
        var char = _password.text.substring(i, i + 1);
        if (char.contains(new RegExp(r'[0-9]'))) {
          repeatednum++;
        } else {
          if (char == char.toUpperCase()) {
            if (!char.contains(new RegExp(r'[\[\]!@#$%^&*(),.?":{}|<>]'))) {
              repeatedupper++;
            }
          } else if (char == char.toLowerCase()) {
            repeatedlower++;
          }
        }
      }
      if (repeatednum > 3) {
        _hasDigits = true;
        print(_hasDigits);
      } else {
        _hasDigits = false;
      }
      if (repeatedupper > 0) {
        _hasUpper = true;
      } else {
        _hasUpper = false;
      }
      if (repeatedlower >= 1) {
        _haslower = true;
      } else {
        _haslower = false;
      }
      if (_password.text.length >= 12) {
        _islong = true;
      } else {
        _islong = false;
      }
      // print("-------------------------------");
      // print("hasDigits:$_hasDigits");
      // print("hasUpper:$_hasUpper");
      // print("hasLower:$_haslower");
      // print("isLong:$_islong");
      // print("hasSpecial:$_hasspecial");
      // print("-------------------------------");

      //third check
      // print(_hasspecial);
    } else {
      resetstring();
    }
    if (callback != null) callback!();
  }

  void resetstring() {
    _hasDigits = false;
    _hasUpper = false;
    _haslower = false;
    _islong = false;
    _hasspecial = false;
  }

  bool PersonalValidator() {
    if (fName.text != "" &&
        lName.text != "" &&
        nickName.text != "" &&
        gender != genderList[0] &&
        bDay != null &&
        bMonth != null &&
        bYear != null &&
        strName.text != "" &&
        city.text != "" &&
        state.text != "" &&
        country.text != "" &&
        zip.text != "") {
      return true;
    } else {
      return false;
    }
  }

  bool ContactValidator() {
    if (email.text != "" &&
        phone.text != "" &&
        emailOperation!.isCompleted &&
        freeemail == false) {
      return true;
    } else {
      return false;
    }
  }

  bool UsernameValidator() {
    if (userName.text != "" &&
        freeusername == false &&
        emailOperation!.isCompleted) {
      return true;
    } else {
      return false;
    }
  }

  bool PasswordValidator() {
    if (password.text != "" &&
        rPassword.text != "" &&
        haslower &&
        hasUpper &&
        hasDigits &&
        hasspecial &&
        islong &&
        password.text == rPassword.text) {
      return true;
    } else {
      return false;
    }
  }

  void generalValidator() {
    if (fName.text != "" &&
        lName.text != "" &&
        _freeusername != true &&
        _userName != null &&
        _userName.text != "" &&
        _bDay != null &&
        _gender != "" &&
        _email != "" &&
        _haslower &&
        _hasUpper &&
        _hasDigits &&
        _hasspecial &&
        _islong &&
        _strName.text != "" &&
        _city.text != "" &&
        _country.text != "" &&
        _freeemail != true &&
        _zip.text != "" &&
        _state.text != "" &&
        _password != "" &&
        _rPassword != "" &&
        _password == _rPassword) {
      valid = true;
    } else {
      valid = false;
    }
    print(valid);
  }
}
