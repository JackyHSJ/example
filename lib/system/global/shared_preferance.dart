import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

/// singleton class
class FcPrefs {
  static final FcPrefs _singleton = FcPrefs._internal();
  FcPrefs._internal();

  factory FcPrefs() {
    return _singleton;
  }

  /// for unit test use
  static void mockInitial() {
    SharedPreferences.setMockInitialValues({});
  }

  /// instance
  static Future<SharedPreferences> _prefsInstance() async {
    return await SharedPreferences.getInstance();
  }

  /// commToken
  static Future<void> setCommToken(String token) async {
    await _setString(FcPrefsKey.commToken, token);
  }

  static Future<String> getCommToken() async {
    return await _getString(FcPrefsKey.commToken);
  }

  /// rtcToken
  static Future<void> setRtcToken(String token) async {
    await _setString(FcPrefsKey.rtcToken, token);
  }

  static Future<String> getRtcToken() async {
    return await _getString(FcPrefsKey.rtcToken);
  }

  /// loginData
  static Future<void> setLoginData(String data) async {
    await _setString(FcPrefsKey.loginData, data);
  }

  static Future<String> getLoginData() async {
    return await _getString(FcPrefsKey.loginData);
  }

  /// userId
  static Future<void> setUserId(num id) async {
    await _setInt(FcPrefsKey.userId, id.toInt());
  }

  static Future<int> getUserId() async {
    return await _getInt(FcPrefsKey.userId);
  }

  /// userName
  static Future<void> setUserName(String name) async {
    await _setString(FcPrefsKey.userName, name);
  }

  static Future<String> getUserName() async {
    return await _getString(FcPrefsKey.userName);
  }

  /// nickName
  static Future<void> setNickName(String name) async {
    await _setString(FcPrefsKey.nickName, name);
  }

  static Future<String> getNickName() async {
    return await _getString(FcPrefsKey.nickName);
  }

  /// device
  static Future<void> setDevice(String device) async {
    await _setString(FcPrefsKey.device, device);
  }

  static Future<String> getDevice() async {
    return await _getString(FcPrefsKey.device);
  }

  /// verificationCode
  static Future<void> setVerificationCode(String verificationCode) async {
    await _setString(FcPrefsKey.verificationCode, verificationCode);
  }

  static Future<String> getVerificationCode() async {
    return await _getString(FcPrefsKey.verificationCode);
  }

  /// phoneNumber
  static Future<void> setPhoneNumber(String phoneNumber) async {
    await _setString(FcPrefsKey.phoneNumber, phoneNumber);
  }

  static Future<String> getPhoneNumber() async {
    return await _getString(FcPrefsKey.phoneNumber);
  }

  /// customCommonLanguage
  static Future<void> setCustomCommonLanguage(String key, List<String> value) async {
    await _setStringList(key, value);
  }

  static Future<List<String>> getCustomCommonLanguage(String key) async {
    return await _getStringList(key);
  }

  /// defaultCommonLanguage
  static Future<void> setDefaultCommonLanguage(String key, List<String> value) async {
    await _setStringList(key, value);
  }

  static Future<List<String>> getDefaultCommonLanguage(String key) async {
    return await _getStringList(key);
  }

  /// submittedNickName
  static Future<void> setSubmittedNickName(String name) async {
    await _setString(FcPrefsKey.submittedNickName, name);
  }

  static Future<String> getSubmittedNickName() async {
    return await _getString(FcPrefsKey.submittedNickName);
  }

  /// beautyStatus
  static Future<void> setBeautyStatus(bool status) async {
    await _setBool(FcPrefsKey.beautyStatus, status);
  }

  static Future<bool> getBeautyStatus() async {
    return await _getBool(FcPrefsKey.beautyStatus);
  }

  // ===========local func===========
  static Future<void> _setString(String key, String value) async {
    SharedPreferences pref = await _prefsInstance();
    await pref.setString(key, value);
  }

  static Future<String> _getString(String key, {String defaultValue = ''}) async {
    SharedPreferences pref = await _prefsInstance();
    if (pref.containsKey(key)) {
      return pref.getString(key)!;
    } else {
      return defaultValue;
    }
  }

  static Future<void> _setStringList(String key, List<String> value) async {
    SharedPreferences pref = await _prefsInstance();
    await pref.setStringList(key, value);
  }

  static Future<List<String>> _getStringList(String key) async {
    SharedPreferences pref = await _prefsInstance();
    if (pref.containsKey(key)) {
      return pref.getStringList(key)!;
    } else {
      return [];
    }
  }

  static Future<void> _setBool(String key, bool value) async {
    SharedPreferences pref = await _prefsInstance();
    await pref.setBool(key, value);
  }

  static Future<bool> _getBool(String key, {bool defaultValue = false}) async {
    SharedPreferences pref = await _prefsInstance();
    if (pref.containsKey(key)) {
      return pref.getBool(key)!;
    } else {
      return defaultValue;
    }
  }

  static Future<void> _setDouble(String key, double value) async {
    SharedPreferences pref = await _prefsInstance();
    await pref.setDouble(key, value);
  }

  static Future<double> _getDouble(String key, {double defaultValue = 0}) async {
    SharedPreferences pref = await _prefsInstance();
    if (pref.containsKey(key)) {
      return pref.getDouble(key)!;
    } else {
      return defaultValue;
    }
  }

  static Future<void> _setInt(String key, int value) async {
    SharedPreferences pref = await _prefsInstance();
    await pref.setInt(key, value);
  }

  static Future<int> _getInt(String key, {int defaultValue = 0}) async {
    SharedPreferences pref = await _prefsInstance();
    if (pref.containsKey(key)) {
      return pref.getInt(key)!;
    } else {
      return defaultValue;
    }
  }

  static Future<void> setTeenTips(bool value) async {
    await _setBool('NoTip', value);
  }

  static Future<bool> getTeenTips() async {
    return await _getBool('NoTip');
  }

  static Future<void> setProtocolReaded(bool value) async {
    await _setBool('ProtocolReaded', value);
  }

  static Future<bool> getProtocolReaded() async {
    return await _getBool('ProtocolReaded');
  }

  static Future<void> setMissionCheck(num target, bool value) async {
    await _setBool('MissionCheck_$target', value);
  }

  static Future<bool> getMissionCheck(num target) async {
    return await _getBool('MissionCheck_$target');
  }

  /// device
  static Future<void> setCallStatus(String json) async {
    await _setString(FcPrefsKey.callStatus, json);
  }

  static Future<String> getCallStatus() async {
    return await _getString(FcPrefsKey.callStatus);
  }

  static Future<void> setCancelCallInfo(String json) async {
    await _setString(FcPrefsKey.cancelCallInfo, json);
  }

  static Future<String> getCancelCallInfo() async {
    return await _getString(FcPrefsKey.cancelCallInfo);
  }

  static Future<void> setInviteCode(String inviteCode) async {
    await _setString(FcPrefsKey.inviteCode, inviteCode);
  }

  static Future<String> getInviteCode() async {
    return await _getString(FcPrefsKey.inviteCode);
  }

  static Future<void> setIsNotFirstLogin(bool value) async {
    await _setBool(FcPrefsKey.isNotFirstLogin, value);
  }

  static Future<bool> getIsNotFirstLogin() async {
    return await _getBool(FcPrefsKey.isNotFirstLogin);
  }

  static Future<void> setEnv(String env) async {
    await _setString(FcPrefsKey.env, env);
  }

  static Future<String> getEnv() async {
    return await _getString(FcPrefsKey.env);
  }

  static Future<void> setIsShowGoPersonalSettingIAPDialog(bool value) async {
    await _setBool(FcPrefsKey.isShowGoPersonalSettingIAPDialog, value);
  }

  static Future<bool> getIsShowGoPersonalSettingIAPDialog() async {
    return await _getBool(FcPrefsKey.isShowGoPersonalSettingIAPDialog);
  }

  static Future<void> setIsCheckPrivcyAgreement(bool value) async {
    await _setBool(FcPrefsKey.isCheckPrivcyAgreement, value);
  }

  static Future<bool> getIsCheckPrivcyAgreement() async {
    return await _getBool(FcPrefsKey.isCheckPrivcyAgreement);
  }

  ///个性化推荐状态
  static Future<void> setIsClosePersonalizedRecommendations(bool value) async {
    await _setBool(FcPrefsKey.isClosePersonalizedRecommendations, value);
  }

  static Future<bool> getIsClosePersonalizedRecommendations() async {
    return await _getBool(FcPrefsKey.isClosePersonalizedRecommendations);
  }

  ///个性化推荐状态
  static Future<void> setTheme(String value) async {
    await _setString(FcPrefsKey.theme, value);
  }

  static Future<String> getTheme() async {
    return await _getString(FcPrefsKey.theme);
  }

  /// 取得 最新動態貼文發文時間（針對每個不同 userName 去取得）
  static Future<int> getLastPostTime() async {
    String userId = await getUserName();
    String key = FcPrefsKey.lastPostTime+userId;
    return await _getInt(key);
  }
  /// 紀錄 最新動態貼文發文時間（針對每個不同 userName 去紀錄）
  static Future<void> setLastPostTime(int timestamp) async {
    String userId = await getUserName();
    String key = FcPrefsKey.lastPostTime+userId;
    return await _setInt(key, timestamp);
  }

  /// 編輯暱稱保留原本的 nickName
  static Future<void> setKeepNickNameInReview(String name) async {
    await _setString(FcPrefsKey.keepNickNameInReview, name);
  }

  static Future<String> getKeepNickNameInReview() async {
    return await _getString(FcPrefsKey.keepNickNameInReview);
  }

  /// 紀錄 teenMode 狀態
  static Future<void> setTeenMode(bool status) async {
    await _setBool(FcPrefsKey.teenMode, status);
  }

  static Future<bool> getTeenMode() async {
    return await _getBool(FcPrefsKey.teenMode);
  }

  ///记录登入类型
  static Future<void> setLoginType(String token) async {
    await _setString(FcPrefsKey.loginType, token);
  }

  static Future<String> getLoginType() async {
    return await _getString(FcPrefsKey.loginType);
  }


  /// 紀錄是否已檢查推播通知權限
  static Future<void> setIsCheckedNotificationPermission(bool status) async {
    await _setBool(FcPrefsKey.isCheckedNotificationPermission, status);
  }

  static Future<bool> getIsCheckedNotificationPermission() async {
    return await _getBool(FcPrefsKey.isCheckedNotificationPermission);
  }
}
