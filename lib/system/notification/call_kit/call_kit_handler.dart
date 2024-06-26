// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:zego_callkit/zego_callkit.dart';
// import 'package:uuid/uuid.dart';
//
// class CallKitHandler {
//
//   /// 中國地區尚未加入白名單無法開啟CallKit
//   _initCallKitConfig() {
//     final cxProviderConfig = CXProviderConfiguration(
//       localizedName: 'FreChat',
//       supportsVideo: true,
//       // supportedHandleTypes: [
//       //   CXHandleType
//       // ],
//       /// 應用程式的圖標
//       iconTemplateImageName: 'assets/images/app_icon.png',
//     );
//
//     CallKit.setInitConfiguration(cxProviderConfig);
//   }
//
//   _get() {
//     final CXCallUpdate cxCallUpdate = CXCallUpdate();
//
//     return cxCallUpdate;
//   }
//
//   reportIncomingCall() {
//     CallKit.getInstance().reportIncomingCall(_get(), UUID());
//   }
//
//   reportCallEnded() {
//     CallKit.getInstance().reportCallEnded(_get(), uuid)
//   }
// }
