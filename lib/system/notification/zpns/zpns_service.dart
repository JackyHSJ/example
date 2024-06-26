
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/notification/zpns/zpns_callback.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:zego_zpns/zego_zpns.dart';

class ZPNsService {
  ZPNsService({required this.ref});
  ProviderRef ref;

  Future<void> init() async {
    await _zpnsRegister();
    _zpnsEventHandler();
  }

  Future<void> disconnect() async {
  }

  _initZPNsConfig() async {
    ZPNsNotificationChannel zpNsNotificationChannel =
    ZPNsNotificationChannel()..channelID = 'message_resource'..channelName = '聊天消息';
    await ZPNs.getInstance().createNotificationChannel(zpNsNotificationChannel);
    ZPNsConfig config = AppConfig.zpNsConfig;
    await ZPNs.setPushConfig(config);
    // ZPNs.enableDebug(true);
  }

  _zpnsEventHandler() {
    final ZPNsCallBack callback = ref.read(zpnsCallBackProvider);
    ZPNsEventHandler.onRegistered = callback.onRegistered;
    ZPNsEventHandler.onNotificationClicked = callback.onNotificationClicked;
    ZPNsEventHandler.onNotificationArrived = callback.onNotificationArrived;

  }

  static void setBackGroundMode() {
    ZPNs.setBackgroundMessageHandler(ZPNsCallBack.zpnsMessagingBackgroundHandler);
  }

  _zpnsRegister() async {
    await _initZPNsConfig();
    // Request notification rights from the user when appropriate,iOS only
    await ZPNs.getInstance().applyNotificationPermission();
    // Select an ZPNsIOSEnvironment value based on the iOS development/Distribution certificate.Change this enum when switching certificates
    ZPNs.getInstance()
        .registerPush(iOSEnvironment: AppConfig.pushNotificationEnv, enableIOSVoIP: false)
        .catchError((onError) {
      if (onError is PlatformException) {
        //Notice exception here
        print('registerPush error');
        print(onError.message ?? "");
      }
    });
  }
}