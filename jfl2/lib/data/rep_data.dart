import 'package:flutter/cupertino.dart';

class RepData {
  TextEditingController reps = new TextEditingController();
  TextEditingController pounds = new TextEditingController();
  TextEditingController timer = new TextEditingController();
  ValueNotifier<bool> iscomplete = ValueNotifier<bool>(false);

  void completestatus(){
    bool status = reps.text.isEmpty ||timer.text.isEmpty || pounds.text.isEmpty;
    print(status);
    if(!status){
      iscomplete.value = true;
    }
    else{
      iscomplete.value = false;
    }
  }
}