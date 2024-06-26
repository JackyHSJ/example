import 'package:frechat/system/app_config/app_config.dart';

import '../../../../models/profile/personal_setting_notification_model.dart';

class PersonalSettingNotificationViewModel {
  List<PersonalSettingNotificationModel> cellList = [
    PersonalSettingNotificationModel(title: '推薦設置', notificationList: [
      NotificationInfo(title: '個性化推薦', des: '關閉後，將無法使用緣分頁的推薦以及動態頁的推薦和關注功能'),
      NotificationInfo(title: '緣份牽線', des: '開啟後，${AppConfig.appName}將用大數據為您匹配有緣人，牽線成功會發送緣分消息，關閉後，將不會收到緣分牽線'),
      NotificationInfo(title: '隱藏所在地', des: '開啟後，將隱藏您多惡成是所在第，其他人無法看到'),
      NotificationInfo(title: '點贊通知', des: '動態消息的貼文點贊通知開關'),
    ]),
    PersonalSettingNotificationModel(title: '提示設置', notificationList: [
      NotificationInfo(title: '聲音'),
      NotificationInfo(title: '震動'),
    ]),
  ];
}
