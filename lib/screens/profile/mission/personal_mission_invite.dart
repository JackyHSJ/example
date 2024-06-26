// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frechat/widgets/strike_up_list/strike_up_list_extension.dart';
// import 'package:frechat/widgets/theme/original/app_colors.dart';
//
// import '../../../models/ws_res/member/ws_member_info_res.dart';
// import '../../../system/base_view_model.dart';
// import '../../../system/providers.dart';
// import '../../../system/repository/http_setting.dart';
// import '../../../widgets/user_info_view/user_info_view_states.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class PersonalMissionInvite extends ConsumerStatefulWidget {
//   const PersonalMissionInvite({super.key});
//
//   @override
//   ConsumerState<PersonalMissionInvite> createState() => _PersonalMissionInviteState();
// }
//
// class _PersonalMissionInviteState extends ConsumerState<PersonalMissionInvite> {
//   GlobalKey qrKey = GlobalKey();
//   WsMemberInfoRes? memberInfo;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       try {
//         memberInfo = ref.watch(userInfoProvider).memberInfo;
//       } catch (e) {
//         // ignore: avoid_print
//         print(e.toString());
//       }
//       return Material(
//         color: Colors.transparent,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Stack(
//                 //alignment: Alignment.center,
//                 children: [
//                   Center(child: Image.asset('assets/strike_up_list/invite_friend.png')),
//                   Column(
//                     children: [
//                       const SizedBox(height: 136),
//                       ListTile(
//                         //暱稱、VIP
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             //頭像
//                             Container(
//                               width: 56,
//                               height: 56,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(48),
//                                 /*
//                               border: Border.all(
//                                 color: MyExtension
//                                     .defAvatarBorderColor(), //gender == 0 ? const Color.fromRGBO(235, 93, 142, 1) : const Color.fromRGBO(51, 138, 243, 1),
//                                 width: 2,
//                               ),
//                               */
//                               ),
//                               child: ClipOval(
//                                 child: Image.network(
//                                   HttpSetting.baseImagePath + (memberInfo!.avatarPath ?? ''),
//                                   errorBuilder: (context, error, stackTrace) {
//                                     // 加載失敗時顯示預設圖片
//                                     return ref.read(userInfoProvider).memberInfo!.gender.defAvatarImage();
//                                   },
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//
//                             //暱稱
//                             Column(
//                               children: [
//                                 ShaderMask(
//                                   shaderCallback: (shader) {
//                                     return const LinearGradient(
//                                       colors: [
//                                         AppColors.mainYellow,
//                                         AppColors.mainOrange,
//                                       ],
//                                       tileMode: TileMode.mirror,
//                                     ).createShader(shader);
//                                   },
//                                   child: Text(memberInfo!.nickNameAuth == 1 ? memberInfo!.nickName ?? '' : memberInfo!.userName ?? '',
//                                       style: const TextStyle(fontSize: 20, color: Colors.white)),
//                                 ),
//                                 //性別,年齡、魅力、实名认证、真人认证
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     //性別,年齡
//                                     Container(
//                                       width: 36,
//                                       height: 16,
//                                       //框
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(48),
//                                         color: memberInfo!.gender == 0
//                                             ? AppColors.mainPink
//                                             : memberInfo!.gender == 1
//                                                 ? const Color.fromRGBO(51, 138, 243, 1)
//                                                 : Colors.black,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           //性別
//                                           (memberInfo!.gender ?? 9).getGenderIcon(),
//                                           //年齡
//                                           Text(memberInfo!.age.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     //魅力
//                                     _buildCharmLevel(),
//                                   ],
//                                 ),
//                                 Container(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(memberInfo!.selfIntroduction ?? '', style: const TextStyle(color: AppColors.textFormBlack, fontSize: 12)),
//                                 ),
//                               ],
//                             ),
//                             //VIP(第二期才會有
//                             // showVip(),
//                           ],
//                         ),
//                       ),
//                       qrCodeImageView(),
//                       const SizedBox(height: 36),
//                       InkWell(
//                           onTap: () {
//                             saveToGallery();
//                             //Navigator.pop(context);
//                           },
//                           child: Container(width: 239, height: 43, color: Colors.transparent)),
//                     ],
//                   ),
//                 ],
//               ),
//               InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Image.asset('assets/strike_up_list/Cancel.png')),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   ///魅力
//   _buildCharmLevel() {
//     return Container(
//       width: 44,
//       height: 16,
//       //框
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(48),
//         gradient: const LinearGradient(
//           colors: [
//             Color.fromRGBO(205, 157, 251, 1),
//             Color.fromRGBO(55, 175, 243, 1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       //魅力值
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.favorite, color: Colors.white, size: 12),
//           const SizedBox(width: 2),
//           Text(memberInfo!.charmLevel.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
//         ],
//       ),
//     );
//   }
//
//   //Qrcode圖片
//   Widget qrCodeImageView() {
//     return GestureDetector(
//       child: RepaintBoundary(
//         key: qrKey,
//         child: Container(
//           margin: EdgeInsets.only(top: 0.h, right: 72.w, left: 72.w),
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//             border: Border.all(width: 1, color: AppColors.mainLightGrey),
//           ),
//           child: Center(
//             child: QrImageView(
//               data: memberInfo!.userName!, // 替换为你的QR码数据
//               version: QrVersions.auto,
//               size: 215.h,
//             ),
//           ),
//         ),
//       ),
//       onLongPress: () async {
//         _copyImageToClipboard();
//       },
//     );
//   }
//
//   //複製圖片
//   void _copyImageToClipboard() async {
//     try {
//       RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       final image = await boundary.toImage(pixelRatio: 1.0);
//       final byteData = await image.toByteData(format: ImageByteFormat.png);
//       if (byteData != null) {
//         final byteDataList = byteData.buffer.asUint8List();
//         final base64String = base64Encode(byteDataList);
//         Clipboard.setData(ClipboardData(text: base64String));
//         toast('已复制到剪贴簿');
//       }
//     } catch (e) {
//       print('复制失败：$e');
//       toast('复制失败');
//     }
//   }
//
//   //Toast彈窗
//   void toast(String text) {
//     BaseViewModel.showToast(context, text);
//   }
//
//   //保存到相簿
//   Future<void> saveToGallery() async {
//     // 请求储存权限
//     var status = await Permission.storage.request();
//
//     if (status.isGranted) {
//       // 权限已授予，执行保存操作
//       try {
//         await Future.delayed(const Duration(milliseconds: 100)); // 添加延迟
//         RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//         final image = await boundary.toImage(pixelRatio: 1.0);
//         final byteData = await image.toByteData(format: ImageByteFormat.png);
//
//         final result = await ImageGallerySaver.saveImage(
//           byteData!.buffer.asUint8List(),
//           quality: 80,
//           name: 'qr_code',
//         );
//         if (result['isSuccess']) {
//           toast('已保存到相册');
//         } else {
//           toast('保存失败');
//         }
//       } catch (e) {
//         print('保存失败：$e');
//         toast('保存失败');
//       }
//     } else if (status.isDenied) {
//       // 用户拒绝了权限请求
//       // 提示用户打开应用设置以授予权限
//       openAppSettings();
//     }
//   }
// }
