class PersonalSettingIAPModel {
  PersonalSettingIAPModel({
    required this.title,
    required this.unit,
    required this.phraseNum,
  });
  String title;
  String unit;
  int phraseNum;
}

class PersonalSettingIAPIntroModel {
  PersonalSettingIAPIntroModel({
    required this.title,
    this.enableAction = false,
  });
  String title;
  bool enableAction;
}