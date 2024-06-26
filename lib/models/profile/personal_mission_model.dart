
class PersonalMissionModel {
  PersonalMissionModel({
    required this.title,
    required this.des,
    required this.missionListList
  });

  String title;
  String des;
  List<MissionInfo> missionListList;
}

class MissionInfo {
  MissionInfo({
    required this.awardNum,
    required this.missionTitle,
    required this.missionDes,
    this.isDone = false
  });

  int awardNum;
  String missionTitle;
  String missionDes;
  bool isDone;
}