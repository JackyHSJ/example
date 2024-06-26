

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/notification/notification_handler.dart';
import 'package:frechat/system/notification/notification_manager.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:zego_zpns/zego_zpns.dart';

class ZPNsCallBack {
  ZPNsCallBack({required this.ref});
  ProviderRef ref;

  @pragma('vm:entry-point')
  static Future<void> zpnsMessagingBackgroundHandler(ZPNsMessage zpnsMessage) async {
    final ZPNsPushSourceType type = zpnsMessage.pushSourceType;
    final bool isCall = zpnsMessage.content == '通话邀请';
    switch(type) {
      case ZPNsPushSourceType.APNs:
        Map aps = Map.from(zpnsMessage.extras['aps'] as Map);
        String payload = aps['payload'];
        print("My payload is $payload");
        break;
      case ZPNsPushSourceType.ZEGO:
        print("My payload is ZEGO");
        break;
      case ZPNsPushSourceType.FCM:
        print("My payload is FCM");
        break;
      case ZPNsPushSourceType.HuaWei:
      case ZPNsPushSourceType.Oppo:
      case ZPNsPushSourceType.XiaoMi:
      case ZPNsPushSourceType.Vivo:
        print("My payload is $type");
        if(isCall) {
          // NotificationManager.showIncomingFullScreen(zpnsMessage: zpnsMessage);
          NotificationManager.showIncomingBanner(zpnsMessage: zpnsMessage);
        }
        break;
      default:
        break;
    }
    print("user clicked the offline push notification,title is ${zpnsMessage.title},content is ${zpnsMessage.content}");
  }

  onRegistered (ZPNsRegisterMessage registerMessage) {
    if(registerMessage.errorCode == 0) {
      print('onRegistered pushId: ${registerMessage.pushID}');
    }
  }

  onNotificationClicked(ZPNsMessage zpnsMessage) {
    if (zpnsMessage.pushSourceType == ZPNsPushSourceType.APNs) {
      Map aps = Map.from(zpnsMessage.extras['aps'] as Map);
      String payload = aps['payload'];
      print("My payload is $payload");
    } else if (zpnsMessage.pushSourceType == ZPNsPushSourceType.FCM) {
      // FCM does not support this interface,please use Intent get payload at Android Activity.
    }
    print("user clicked the offline push notification,title is ${zpnsMessage.title},content is ${zpnsMessage.content}");
  }

  onNotificationArrived(ZPNsMessage zpNsMessage) {
    print('zpNsMessage.extras: ${zpNsMessage.extras}');
  }

  // performAnswerCallAction(CXAction action) {
  //   print('answter');
  //   action.fulfill();
  // }
  //
  // didReceiveIncomingPush(Map extras, UUID uuid) {
  //   Map payload = extras['payload'];
  //   print('didReceive VoIP: $payload');
  // }
}