//
// import 'dart:convert';
//
// import 'package:flutter_callkeep/flutter_callkeep.dart';
// import 'package:frechat/system/app_config/app_config.dart';
// import 'package:frechat/models/zpns/call_payload_model.dart';
// import 'package:frechat/models/zpns/offline_call_model.dart';
// import 'package:frechat/system/constant/enum.dart';
// import 'package:frechat/system/database/model/chat_user_model.dart';
// import 'package:frechat/system/repository/http_setting.dart';
// import 'package:frechat/system/zego_call/zego_callback.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zego_zpns/zego_zpns.dart';
//
// class CallKeepHandler {
//   late final Uuid _uuid;
//   static String? _currentUuid;
//
//   static addListener() {
//   }
//
//   static Future<void> showIncomingCall({
//     required ZPNsMessage zpnsMessage,
//   }) async {
//     final OfflineCallExtrasModel extras = OfflineCallExtrasModel.fromJson(zpnsMessage.extras);
//     final Map<String, dynamic> payloadMap = json.decode(extras.payload ?? '');
//     final CallPayloadModel payloadModel = CallPayloadModel.fromJson(payloadMap);
//     final num timeout = payloadModel.timeout; // 秒
//     final callerAvatar = payloadModel.callerAvatar;
//     final String callId = extras.zego?.callId ?? '';
//
//     final CallKeepIncomingConfig config = CallKeepIncomingConfig(
//       uuid: callId,
//       callerName: zpnsMessage.title,
//       appName: AppConfig.getAppName(),
//       avatar: HttpSetting.baseImagePath + callerAvatar,
//       handle: zpnsMessage.content,
//       hasVideo: false,
//       duration: timeout * 1000, // 毫秒
//       acceptText: '接听',
//       declineText: '拒接',
//       missedCallText: '未接来电',
//       callBackText: '回拨',
//       // extra: <String, dynamic>{'userId': '1a2b3c4d'},
//       // headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//       androidConfig: _getCallKeepAndroidConfig(),
//       iosConfig: _getCallKeepIosConfig(),
//     );
//
//     await CallKeep.instance.displayIncomingCall(config);
//   }
//
//   static CallKeepAndroidConfig _getCallKeepAndroidConfig() {
//     return CallKeepAndroidConfig(
//       logo: "ic_launcher",
//       notificationIcon: "ic_launcher",
//       showCallBackAction: true,
//       showMissedCallNotification: true,
//       ringtoneFileName: 'system_ringtone_default',
//       accentColor: '#EB5D8E',
//       backgroundUrl: 'assets/images/splash_bg.png',
//       incomingCallNotificationChannelName: '来电通话',
//       missedCallNotificationChannelName: '未接来电',
//     );
//   }
//
//   static CallKeepIosConfig _getCallKeepIosConfig() {
//     return CallKeepIosConfig(
//       iconName: 'CallKitLogo',
//       handleType: CallKitHandleType.generic,
//       isVideoSupported: true,
//       maximumCallGroups: 2,
//       maximumCallsPerCallGroup: 1,
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtoneFileName: 'system_ringtone_default',
//     );
//   }
//
//   static Future<List<CallKeepCallData>> _activeCalls() {
//     return CallKeep.instance.activeCalls();
//   }
//
//   static Future<void> endAllCalls() {
//     return CallKeep.instance.endAllCalls();
//   }
//
//   static Future<CallKeepCallData?> _getCurrentCall() async {
//     //check current call from pushkit if possible
//     final List<CallKeepCallData> calls = await _activeCalls();
//     if (calls.isNotEmpty) {
//       print('DATA: $calls');
//       _currentUuid = calls[0].uuid;
//       return calls[0];
//     } else {
//       _currentUuid = "";
//       return null;
//     }
//   }
//
//   static checkAndNavigationCallingPage() async {
//     final CallKeepCallData? currentCall = await _getCurrentCall();
//     if (currentCall != null && currentCall.isAccepted == true) {
//       ZegoCallBack.type = OfflineCallType.accept;
//     }
//
//     if (currentCall != null && currentCall.isAccepted == false) {
//       ZegoCallBack.type = OfflineCallType.handout;
//     }
//   }
// }