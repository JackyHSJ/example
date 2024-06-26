import 'package:zego_zpns/zego_zpns.dart';

class ZegoSetting {
  /// dev
  static int devAppID = 1684123630;
  static String devAppSign = '7d7bd1f86f262e94fb8ad7742c12f3005afc81dc0258c6681f2e270159a58214';
  static String devServerSecret = '';

  /// qa
  static int qaAppID = 1332643940;
  static String qaAppSign = '28bddd2cc77558b66b4b89ca080cb5fad41f48a9b0c0137921f04dcacbd7dcc5';
  static String qaServerSecret = '';

  /// uat
  static int uatAppID = 1332643940;
  static String uatAppSign = '28bddd2cc77558b66b4b89ca080cb5fad41f48a9b0c0137921f04dcacbd7dcc5';
  static String uatServerSecret = '';

  /// pro
  static int proAppID = 1300911646;
  static String proAppSign = '3f9dd1a210609f24a0daa19482feed19353773a5b2b5653865369287eb7ada56';
  static String proServerSecret = '';

  /// review
  static int reviewAppID = 1300911646;
  static String reviewAppSign = '3f9dd1a210609f24a0daa19482feed19353773a5b2b5653865369287eb7ada56';
  static String reviewServerSecret = '';

  // static ZPNsIOSEnvironment zpnsIOSAutoEnvironment = ZPNsIOSEnvironment.Automatic;
  static String resourceId_message = 'message_resource';
  static String resourceId_call = 'call_resource';
}
