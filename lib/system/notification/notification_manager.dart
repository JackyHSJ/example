
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/notification/call_kit/call_keep.dart';
import 'package:frechat/system/notification/notification_handler.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_zpns/zego_zpns.dart';

class NotificationManager {

  static void init() async {
    NotificationHandler.initNotificationAppLaunch();
    NotificationHandler.initialize();
    NotificationHandler.addListener();

  }

  static void dispose() {
    NotificationHandler.disposeListener();
  }

  static void showIncomingFullScreen({
    required ZPNsMessage zpnsMessage,
  }) {
    /// keep call
    // CallKeepHandler.showIncomingCall(zpnsMessage: zpnsMessage);
  }

  static void showIncomingBanner({
    required ZPNsMessage zpnsMessage,
  }) {
    NotificationHandler.showIncomingCallNotification(zpnsMessage: zpnsMessage);
  }

  /// full screen use.
  static Future<void> checkAndNavigationCallingPage() async {
    // await CallKeepHandler.checkAndNavigationCallingPage();
  }

  static void clearStatus() {
    ZegoCallBack.type = OfflineCallType.none;
    // CallKeepHandler.endAllCalls();
  }
}