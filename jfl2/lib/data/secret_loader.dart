import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jfl2/data/secret.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class SecretLoader {
  final String secretPath;
  SecretLoader({ required this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData(this.secretPath, (jsonString) async {
      final secret = Secret.fromJson(json.decode(jsonString));
      return secret;
    });
  }
}
