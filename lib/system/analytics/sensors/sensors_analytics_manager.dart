//
//
// import 'package:flutter/services.dart';
// import 'package:frechat/system/analytics/analytics_setting.dart';
// import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
//
// class SensorsAnalyticsManager {
//   static String? _distinctId = '';
//
//   static init() {
//     _startSensorsAnalyticsSDK();
//     initPlatformState();
//   }
//
//   static void _startSensorsAnalyticsSDK() {
//     SensorsAnalyticsFlutterPlugin.init(
//         serverUrl: AnalyticsSetting.serverUrl,
//         autoTrackTypes: <SAAutoTrackType>{
//           SAAutoTrackType.APP_START,
//           SAAutoTrackType.APP_VIEW_SCREEN,
//           SAAutoTrackType.APP_CLICK,
//           SAAutoTrackType.APP_END
//         },
//         networkTypes: <SANetworkType>{
//           SANetworkType.TYPE_2G,
//           SANetworkType.TYPE_3G,
//           SANetworkType.TYPE_4G,
//           SANetworkType.TYPE_WIFI,
//           SANetworkType.TYPE_5G
//         },
//         flushInterval: AnalyticsSetting.flushInterval,
//         flushBulkSize: AnalyticsSetting.flushBulkSize,
//         enableLog: true,
//         javaScriptBridge: true,
//         encrypt: true,
//         heatMap: true,
//         visualized: VisualizedConfig(autoTrack: true, properties: true),
//         android: AndroidConfig(
//             maxCacheSize: AnalyticsSetting.androidMaxCacheSize,
//             jellybean: true,
//             subProcessFlush: true),
//         ios: IOSConfig(maxCacheSize: AnalyticsSetting.iOSMaxCacheSize),
//         globalProperties: {'aaa': 'aaa-value', 'bbb': 'bbb-value'});
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   static Future<void> initPlatformState() async {
//     String? distinctId = "";
//
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       distinctId = await SensorsAnalyticsFlutterPlugin.getDistinctId;
//     } on PlatformException {
//       distinctId = 'Failed to get distinctId.';
//     }
//
//     _distinctId = distinctId;
//   }
//
//   /// TODO: 各種埋點方法
//
//   /// 注册成功/登录成功时调用 login
//   static Future<void> login({
//     required String loginId,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.login(loginId, properties);
//   }
//
//   /// 触发激活事件 trackInstallation
//   static Future<void> trackInstallation({
//     required String eventName,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.trackInstallation(eventName, properties);
//   }
//
//   /// 追踪事件 track
//   static Future<void> track({
//     required String eventName,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.track(eventName, properties);
//   }
//
//   /// 设置用户属性 profileSet
//   static Future<void> profileSet({
//     required Map<String, dynamic> profileProperties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.profileSet(profileProperties);
//   }
//
//   /// 设置用户推送 ID 到用户表
//   static Future<void> profilePushId({
//     required String pushTypeKey,
//     required String pushId
//   }) async {
//     SensorsAnalyticsFlutterPlugin.profilePushId(pushTypeKey, pushId);
//   }
//
//   /// 删除用户设置的 pushId
//   static Future<void> profileUnsetPushId({
//     required String pushTypeKey,
//   }) async {
//     SensorsAnalyticsFlutterPlugin.profileUnsetPushId(pushTypeKey);
//   }
//
//   /// set server url
//   static Future<void> setServerUrl({
//     required String serverUrl,
//     bool isRequestRemoteConfig = false
//   }) async {
//     SensorsAnalyticsFlutterPlugin.setServerUrl(
//       serverUrl, // "https://newsdktest.datasink.sensorsdata.cn/sa?project=zhujiagui&token=5a394d2405c147ca",
//       isRequestRemoteConfig
//     );
//   }
//
//   static Future<Map<String, dynamic>?> getPresetProperties() async {
//     final Map<String, dynamic>? map = await SensorsAnalyticsFlutterPlugin.getPresetProperties();
//     return map;
//   }
//
//   static Future<void> enableLog({
//     bool enable = true
//   }) async {
//     SensorsAnalyticsFlutterPlugin.enableLog(enable);
//   }
//
//   static Future<void> setFlushNetworkPolicy({
//     SANetworkType networkType = SANetworkType.TYPE_WIFI
//   }) async {
//     SensorsAnalyticsFlutterPlugin.setFlushNetworkPolicy(<SANetworkType>{networkType});
//   }
//
//   static Future<void> setFlushInterval({
//     required int flushInterval
//   }) async {
//     SensorsAnalyticsFlutterPlugin.setFlushInterval(flushInterval);
//   }
//
//   static Future<int> getFlushInterval() async {
//     final int result = await SensorsAnalyticsFlutterPlugin.getFlushInterval();
//     return result;
//   }
//
//   static Future<void> setFlushBulkSize({
//     int flushInterval = 60 * 60 * 1000,
//     required int flushBulkSize
//   }) async {
//     SensorsAnalyticsManager.setFlushInterval(flushInterval: flushInterval);
//     SensorsAnalyticsFlutterPlugin.setFlushBulkSize(flushBulkSize);
//     print("setFlushBulkSize===");
//     final int result = await SensorsAnalyticsFlutterPlugin.getFlushBulkSize();
//     print("getFlushBulkSize===$result");
//     for (int index = 0; index <= 100; index++) {
//       SensorsAnalyticsFlutterPlugin.track(
//           'ViewProduct2', <String, dynamic>{
//         "a_time": DateTime.now(),
//         "product_name": "Apple 12 max pro"
//       });
//     }
//     print("track end=====");
//   }
//
//   /// 返回本地缓存日志的最大条目数 默认值为 100 条 在每次调用 track、signUp 以及 profileSet 等接口的时候，都会检查如下条件，以判断是否向服务器上传数据:
//   /// 是否是 WIFI/3G/4G 网络条件
//   /// 是否满足发送条件之一: 1) 与上次发送的时间间隔是否大于 flushInterval 2) 本地缓存日志数目是否大于 flushBulkSize 如果满足这两个条件，则向服务器发送一次数据；如果不满足，则把数据加入到队列中，等待下次检查时把整个队列的内 容一并发送。需要注意的是，为了避免占用过多存储，队列最多只缓存 32MB 数据。
//   /// 返回本地缓存日志的最大条目数
//   static Future<int> getFlushBulkSize() async {
//     final int result = await SensorsAnalyticsFlutterPlugin.getFlushBulkSize();
//     return result;
//   }
//
//   /// 获取当前用户的匿名 ID
//   static Future<String> getAnonymousId() async {
//     final String result = await SensorsAnalyticsFlutterPlugin.getAnonymousId();
//     return result;
//   }
//
//   /// 获取当前用户的 loginId
//   static Future<String> getLoginId() async {
//     final String result = await SensorsAnalyticsFlutterPlugin.getLoginId();
//     return result;
//   }
//
//   /// 设置当前用户的 distinctId。一般情况下，如果是一个注册用户，则应该使用注册系统内 的 user_id，
//   /// 如果是个未注册用户，则可以选择一个不会重复的匿名 ID，如设备 ID 等，如果 客户没有调用 identify，
//   /// 则使用SDK自动生成的匿名 ID。
//   /// distinctId 当前用户的 distinctId，仅接受数字、下划线和大小写字母。
//   static Future<void> setIdentify({
//     required String distinctId
//   }) async {
//     SensorsAnalyticsFlutterPlugin.identify(distinctId);
//   }
//
//   /// 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
//   /// 注意：如果之前使用 trackInstallation 触发的激活事件，需要继续保持原来的调用，无需改成 trackAppInstall，否则会导致激活事件数据分离。
//   /// 这是 Sensors Analytics 进阶功能，
//   /// 请参考文档 https://sensorsdata.cn/manual/track_installation.html
//   /// properties 渠道追踪事件的属性 disableCallback 是否关闭这次渠道匹配的回调请
//   static Future<void> trackAppInstall({
//     Map<String, dynamic>? properties,
//     bool disableCallback = false
//   }) async {
//     SensorsAnalyticsFlutterPlugin.trackAppInstall(properties, disableCallback);
//   }
//
//   // trackTimerStart function
//   static Future<void> trackTimerStart() async {
//     var tmpResult = await SensorsAnalyticsFlutterPlugin.trackTimerStart("hello_event");
//     print("trackTimerStart===$tmpResult");
//   }
//
//   // trackTimerPause function
//   static Future<void> trackTimerPause({
//     required String eventName
//   }) async {
//     SensorsAnalyticsFlutterPlugin.trackTimerPause(eventName);
//   }
//
//   // trackTimerResume function
//   static Future<void> trackTimerResume({
//     required String eventName
//   }) async {
//     SensorsAnalyticsFlutterPlugin.trackTimerResume(eventName);
//   }
//
//   // removeTimer function
//   static Future<void> removeTimer({
//     required String eventName
//   }) async {
//     SensorsAnalyticsFlutterPlugin.removeTimer(eventName);
//   }
//
//   // endTimer function
//   static Future<void> endTimer({
//     required String eventName,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.trackTimerEnd(eventName, properties);
//   }
//
//   /// 将所有本地缓存的日志发送到 Sensors Analytics.
//   static Future<void> flush() async {
//     SensorsAnalyticsFlutterPlugin.flush();
//   }
//
//   /// 删除本地缓存的全部事件
//   static Future<void> deleteAll() async {
//     SensorsAnalyticsFlutterPlugin.deleteAll();
//   }
//
//   // setSuperProperties function
//   static Future<void> setSuperProperties({
//     required Map<String, dynamic> superProperties
// }) async {
//     // final map = {
//     //   "superproperties_test": "flutter 注册公共属性",
//     //   "aaa": "同名公共属性 aaa"
//     // };
//     SensorsAnalyticsFlutterPlugin.registerSuperProperties(superProperties);
//   }
//
//   // getSuperProperties function
//   static Future<Map<String, dynamic>?> getSuperProperties() async {
//     final Map<String, dynamic>? result = await SensorsAnalyticsFlutterPlugin.getSuperProperties();
//     return result;
//   }
//
//   // enableNetworkRequest function
//   static Future<void> enableNetworkRequest({bool isRequest = true}) async {
//     SensorsAnalyticsFlutterPlugin.enableNetworkRequest(isRequest);
//   }
//
//   // itemSet function
//   static Future<void> itemSet({
//     required String itemType,
//     required String itemId,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.itemSet(itemType, itemId, properties);
//   }
//
//   // itemDelete function
//   static Future<void> itemDelete({required String itemType, required String itemId}) async {
//     SensorsAnalyticsFlutterPlugin.itemDelete(itemType, itemId);
//   }
//
//   // isNetworkRequestEnable function
//   static Future<bool> isNetworkRequestEnable() async {
//     final bool result = await SensorsAnalyticsFlutterPlugin.isNetworkRequestEnable();
//     return result;
//   }
//
//   // logout function
//   static Future<void> logout() async {
//     SensorsAnalyticsFlutterPlugin.logout();
//   }
//
//   // bind function
//   static Future<void> bind({required String key, required String value}) async {
//     SensorsAnalyticsFlutterPlugin.bind(key, value);
//   }
//
//   // unbind function
//   static Future<void> unbind({required String key, required String value}) async {
//     SensorsAnalyticsFlutterPlugin.unbind(key, value);
//   }
//
//   // loginwithkey function
//   static Future<void> loginWithKey({
//     required String key,
//     required String value,
//     Map<String, dynamic>? properties
//   }) async {
//     SensorsAnalyticsFlutterPlugin.loginWithKey(key, value, properties);
//   }
//
//   // isAutoTrackEventTypeIgnored function
//   static Future<void> isAutoTrackEventTypeIgnored() async {
//     bool click = await SensorsAnalyticsFlutterPlugin.isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_CLICK);
//     bool end = await SensorsAnalyticsFlutterPlugin.isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_END);
//     bool start = await SensorsAnalyticsFlutterPlugin.isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_START);
//     bool screen = await SensorsAnalyticsFlutterPlugin.isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_VIEW_SCREEN);
//     print("isAutoTrackEventTypeIgnored====$click====$end====$start====$screen");
//   }
// }