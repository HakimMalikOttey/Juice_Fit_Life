import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/data/http_call_request.dart';
import 'package:jfl2/main.dart';

class MealPlanMakerData extends ChangeNotifier {
  TextEditingController _writeup = new TextEditingController();

  TextEditingController get mealname => _writeup;

  set mealname(TextEditingController value) {
    _writeup = value;
    notifyListeners();
  }

  final String _plancall = "/meals";
  Future sendMeal(String id, Map<String, dynamic> body) async {
    final meal = await HttpCallRequest.postRequest('$_plancall/$id', body);
    return meal;
  }

  Future copyMeal(String id, Map body) async {
    final meal =
        await HttpCallRequest.postRequest('$_plancall/duplicate/$id', body);
    return meal;
  }

  Future editMeal(String id, Map body) async {
    final meal = await HttpCallRequest.putRequest('$_plancall/$id', body);
    return meal;
  }

  Future deleteMeal(String id, Map body) async {
    final meal = await HttpCallRequest.deleteRequest("$_plancall/$id", body);
    return meal;
  }

  Future getMeal(String id, Map<String, dynamic> query) async {
    print("$_plancall/$id$query");
    final meal = await HttpCallRequest.getRequest("$_plancall/$id", query);
    return meal;
  }

  Future retrieveMealData(String id) async {
    final meal = await HttpCallRequest.getRequest("$_plancall/create/$id", {});
    return meal;
  }
}
