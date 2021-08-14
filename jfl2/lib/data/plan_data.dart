import 'package:flutter/cupertino.dart';

class PlanData extends ChangeNotifier{
  List<Map> _plans = [
    {"name":"Get Big",
      "author":"Hakim Ottey",
      "picture": "assets/PlanPlaceholderImage.jpg"
    },
    {"name":"Get Skinny",
      "author":"Trainer Name",
      "picture": "assets/PlanPlaceholderImage.jpg"
    },
    {"name":"Get Skinny",
      "author":"Trainer Name",
      "picture": "assets/PlanPlaceholderImage.jpg"
    }
    ];

  List<Map> get plans => _plans;

  set plans(List<Map> value) {
    _plans = value;
    notifyListeners();
  }
}