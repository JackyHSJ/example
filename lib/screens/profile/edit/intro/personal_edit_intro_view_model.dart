
import 'package:flutter/cupertino.dart';

class PersonalEditIntroViewModel{
  late TextEditingController controller;

  init(){
    controller = TextEditingController();
  }

  dispose() {
    controller.dispose();
  }
}