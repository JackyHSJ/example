
import 'package:flutter/cupertino.dart';

class PersonalEditNickNameViewModel {

  late TextEditingController nickNameTextController;

  init() {
    nickNameTextController = TextEditingController();
  }

  dispose() {
    nickNameTextController.dispose();
  }
}