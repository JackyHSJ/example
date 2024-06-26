import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/res/member_login_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/notification/notification_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ws_res/member/ws_member_info_res.dart';

/// 只需要初始化一次但是到處都會用到的全域物件收集。
/// 如果你想要用某個第三方的東西，先來這邊找找看。

bool _hasInitialized = false;

//Initialize all global things here.
initializeGlobalStuffs(WidgetRef ref) async {
  //Get the only one sharedPreferences...
  sharedPreferences = await SharedPreferences.getInstance();
  //Read the PackageInfo...
  /// 切換環境envType: AppEnvType { Dev, QA, Production, UAT}
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // String env = await FcPrefs.getEnv();

  AppEnvType? envType;
  final String envStr = GlobalData.cacheEnvStr;
  if(envStr == AppEnvType.QA.name){
    envType = AppEnvType.QA;
  } else if(envStr == AppEnvType.Review.name){
    envType = AppEnvType.Review;
  } else if(envStr == AppEnvType.Production.name){
    envType = AppEnvType.Production;
  } else if(envStr == AppEnvType.Dev.name) {
    envType = AppEnvType.Dev;
  }
  AppConfig.init(ref, packageInfo: packageInfo, envType: envType ?? AppEnvType.Dev);
  _hasInitialized = true;
}

bool globalStuffsHasInitialized() {
  return _hasInitialized;
}

//-- Shared Pref --
late SharedPreferences sharedPreferences;

// -- navi bar page controller --
PageController? naviBarController;
TabController? messageTabController;

//-- Shared Pref key --
class FcPrefsKey {
  // TODO: Add Prefs Key Here
  static String commToken = 'commToken';
  static String rtcToken = 'rtcToken';
  static String device = 'device';
  static String phoneNumber = 'phoneNumber';
  static String verificationCode = 'verificationCode';
  static String loginData = 'loginData';
  static String userId = 'userId';
  static String userName = 'userName';
  static String nickName = 'nickName';
  static String callStatus  = 'callStatus';
  static String cancelCallInfo  = 'cancelCallInfo';
  static String inviteCode  = 'inviteCode';
  static String isNotFirstLogin  = 'isNotFirstLogin';
  static String env  = 'env';
  static String isShowGoPersonalSettingIAPDialog  = 'isShowGoPersonalSettingIAPDialog';
  static String isCheckPrivcyAgreement  = 'isCheckPrivcyAgreement';
  static String isClosePersonalizedRecommendations  = 'isClosePersonalizedRecommendations';

  /// personal edit
  static const submittedNickName = 'submittedNickName';

  // beauty
  static const beautyStatus = 'beautyStatus';

  // 記最新一次貼文時間
  static String lastPostTime = 'lastPostTime';

  // theme
  static String theme = 'theme';

  // 記審核前的暱稱
  static String keepNickNameInReview = 'keepNickNameInReview';

  // 紀錄青少年狀態
  static String teenMode = 'teenMode';

  // 紀錄登入类型
  static String loginType = 'loginType';

  // 紀錄登入类型
  static String isCheckedNotificationPermission = 'isCheckedNotificationPermission';

}

//-- Logger --
Logger logger = Logger(
  printer: PrettyPrinter(
      methodCount: 8, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

class GlobalData {
  static const logFileName = 'debugLogs.txt';

  /// for calling 對方資訊
  static GlobalKey<NavigatorState> globalKey = GlobalKey();
  static ZegoCallData? cacheCallData;
  static ZegoUserInfo? cacheOtherUserInfo;
  static String? cacheToken;
  static String? cacheChannel;
  static num? cacheRoomID;
  static WsMemberInfoRes? cacheMemberInfoRes;
  static SearchListInfo? cacheSearchListInfo;
  static String cacheEnvStr = AppEnvType.QA.name;
  static List<ActivityPostInfo>? cacheUserPostActivityPostInfoList = [] ;

  /// 其他專案用
  static Widget? launch;
  static Widget? chatRoom;

  /// 自己的資料
  static WsMemberInfoRes? memberInfo;

  /// for logs
  static List<String> cacheLogs = [];

  ///判斷是否關閉任務功能（暫時配合『汪版』需求）
  static bool? isCloseTask;


}