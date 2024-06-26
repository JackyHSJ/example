//
//
// import 'package:jpush_flutter/jpush_flutter.dart';
//
// class JPushService {
//   JPushService._internal();
//
//   factory JPushService() => instance;
//   static final JPushService instance = JPushService._internal();
//
//   static Future<void> initJPush() async {
//     JPush jPush = JPush();
//
//     /// api get registration id
//     String channel = 'defaultChannel';
//
//     ///配置应用 Key
//     jPush.setup(
//       appKey: "22abe8a9db7e16b7be863a37",
//       channel: channel,
//       production: true,
//       debug: true,
//     );
//
//     jPush.setAlias("jPushDev").then((map) {
//       print('--------設置成功-----');
//     });
//
//     jPush.getRegistrationID().then((token) {
//       print("notification Token $token");
//       // Prefs.setNotiToken(token);
//     }).onError((error, stackTrace) {
//       print('notification error');
//       print(error);
//     });
//
//     jPush.setAuth(enable: true);
//
//     jPush.applyPushAuthority(NotificationSettingsIOS(sound: true, alert: true, badge: true));
//     try {
//       jPush.addEventHandler(
//         onReceiveNotification: (Map<String, dynamic> message) async {
//           print("flutter onReceiveNotification: $message");
//         },
//         onOpenNotification: (Map<String, dynamic> message) async {
//           print("flutter onOpenNotification: $message");
//           _clickNotificationToPushPage(message);
//         },
//         onReceiveMessage: (Map<String, dynamic> message) async {
//           print("flutter onReceiveMessage: $message");
//         },
//       );
//     } on Exception {
//       print("Failed to get platform version");
//     }
//   }
//
//   static _clickNotificationToPushPage(Map<String, dynamic> message) {
//     // BaseViewModel viewModel = BaseViewModel();
//     // var list = message.values.toList();
//     // print('點推播進來：' + list[1]['cn.jpush.android.EXTRA']);
//     // var body = json.decode(list[1]['cn.jpush.android.EXTRA']);
//     // String type = body['type'];
//     // String roomId = body['roomId'];
//     // if (type == 'chat') {
//     //   print('跳聊天室頁面');
//     //   // String roomId = 'CSR20220929143324992LAKA';
//     //   UserInfoData userInfoData = UserInfoData(avatar: '');
//     //   Navigator.push(viewModel.getGlobalContext(), MaterialPageRoute(
//     //       builder: (context) => MessagePrivateMessagePage(userData: userInfoData, roomId: roomId)));
//     // }
//
//     // Map<String, dynamic> json = list[1]['cn.jpush.android.EXTRA']; // test 待測試如何放進Data
//     // NotificationData notificationData = NotificationData.fromJson(json);
//   }
// }