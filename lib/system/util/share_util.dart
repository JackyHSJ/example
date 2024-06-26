import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_setting.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:social_share_plus/social_share.dart';
import 'package:path/path.dart' as path;

class ShareUtil {
  // static ShareRegister? register;

  static void shareText (BuildContext context, String des, {String? subDes}) {
    // final box = context.findRenderObject() as RenderBox?;
    Share.share(
      des,
      subject: subDes
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static Future<void> shareFile ({
    required File file,
    String? des
  }) async {
    final XFile xFile = XFile(file.path);
    await Share.shareXFiles([xFile], text: des, subject: des);
  }

//   /// social share
//   static Future<void> registerPlatform() async {
//     if(register != null) {
//       return ;
//     }
//     register = ShareRegister();
//     register?.setupWechat(WeChatSetting.appId, WeChatSetting.universalLink);
//     await SharePlugin.registerPlatforms(register!);
//   }
//
//   static Future<void> shareWechatWebPage({
//     required SharePlatform platform,
//     required UserNotifier userUtil,
//     required String appIcon,
//     required InviteFriendType type,
// }) async {
//     SharePlugin.share(
//         await _buildWebpageBean(platform, userUtil: userUtil, appIcon: appIcon, type: type),
//         _notInstallCallback,
//         _successCallback,
//         _errorCallback
//     );
//   }
//
//   static Future<ShareParamsBean> _buildWebpageBean(SharePlatform platform, {
//     String? pkgName,
//     required UserNotifier userUtil,
//     required String appIcon,
//     required InviteFriendType type,
//   }) async {
//     final String title = AppConfig.getAppName();
//     final String imageFilePath = await _getImgFilePath(appIcon);
//     return ShareParamsBean(
//       contentType: LaShareContentTypes.webpage,
//       platform: platform,
//       imageFilePath: imageFilePath,
//       webUrl: userUtil.shareInvitedFriendUrl(type),
//       title: title,
//       text: '缘遇交友，遇见甜甜的有缘人',
//       pkgNameAndroid: pkgName,
//     );
//   }
//
//   static final PlatformCallback _notInstallCallback = (int? platformId) {
//     final BuildContext currentContext = BaseViewModel.getGlobalContext();
//     BaseViewModel.showToast(currentContext, "not install");
//   };
//
//   static final Function _successCallback = () {
//     final BuildContext currentContext = BaseViewModel.getGlobalContext();
//     BaseViewModel.showToast(currentContext, "share successfully");
//   };
//
//   static final Function _errorCallback = (String code, {String? message}) {
//     final BuildContext currentContext = BaseViewModel.getGlobalContext();
//     BaseViewModel.showToast(currentContext, "share failed：$code");
//   };
//
//   static Future<String> _getImgFilePath(String imgAsset) async {
//     final ByteData byteData = await rootBundle.load(imgAsset);
//     final Directory tempDir = await getTemporaryDirectory();
//     final File file = File(path.join(tempDir.path, 'wechatShareIcon.png'));
//     await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//     return file.path;
//   }
}