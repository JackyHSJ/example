class PersonalSettingNotificationModel {
  PersonalSettingNotificationModel({
    required this.title,
    required this.notificationList,
  });
  String title;
  List<NotificationInfo> notificationList;
}

class NotificationInfo {
  NotificationInfo({
    required this.title,
    this.des,
    this.enableSwitch = false,
  });
  String title;
  String? des;
  bool enableSwitch;
}