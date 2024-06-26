//
// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:frechat/system/payment/wechat/wechat_setting.dart';
// import 'package:wechat_kit/wechat_kit.dart';
// import 'package:wechat_kit_extension/wechat_kit_extension.dart';
// import 'package:uuid/uuid.dart';
//
// class Qrauth extends StatefulWidget {
//   const Qrauth({
//     super.key,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return _QrauthState();
//   }
// }
//
// class _QrauthState extends State<Qrauth> {
//   StreamSubscription<WechatQrauthResp>? _qrAuthRespSubs;
//
//   Uint8List? _qrcode;
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   _init() {
//     if(_qrAuthRespSubs != null) {
//       return;
//     }
//     _qrAuthRespSubs = WechatKitPlatform.instance.qrauthRespStream().listen(_listenQrAuthResp);
//   }
//
//   void _listenQrAuthResp(WechatQrauthResp resp) {
//     if (resp is WechatGotQrcodeResp) {
//       setState(() {
//         _qrcode = resp.imageData;
//       });
//     } else if (resp is WechatQrcodeScannedResp) {
//       if (kDebugMode) {
//         print('QrcodeScanned');
//       }
//     } else if (resp is WechatFinishResp) {
//       if (kDebugMode) {
//         print('resp: ${resp.errorCode} - ${resp.authCode}');
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }
//
//   _dispose() {
//     if(_qrAuthRespSubs == null) {
//       return;
//     }
//     _qrAuthRespSubs?.cancel();
//     _qrAuthRespSubs == null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Qrauth'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () async {
//               final WechatAccessTokenResp accessToken =
//               await WechatExtension.getAccessToken(
//                 appId: WeChatSetting.appId,
//                 appSecret: WeChatSetting.appSecret,
//               );
//               if (kDebugMode) {
//                 print(
//                   'accessToken: ${accessToken.errorCode} - '
//                       '${accessToken.errorMsg} - '
//                       '${accessToken.accessToken}',
//                 );
//               }
//               final WechatTicketResp ticket = await WechatExtension.getTicket(
//                 accessToken: accessToken.accessToken!,
//               );
//               if (kDebugMode) {
//                 print(
//                   'accessToken: ${ticket.errorCode} - '
//                       '${ticket.errorMsg} - '
//                       '${ticket.ticket}',
//                 );
//               }
//               await WechatKitPlatform.instance.startQrauth(
//                 appId: WeChatSetting.appId,
//                 scope: <String>[WechatScope.kSNSApiUserInfo],
//                 noncestr: Uuid().v1().replaceAll('-', ''),
//                 ticket: ticket.ticket!,
//               );
//             },
//             child: Text('got qr code'),
//           ),
//         ],
//       ),
//       body: GestureDetector(
//         child: Center(
//           child: _qrcode != null ? Image.memory(_qrcode!) : Text('got qr code'),
//         ),
//       ),
//     );
//   }
// }