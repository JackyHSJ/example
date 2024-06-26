import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frechat/models/device_platform_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/home/home_msg_drift.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  static late AppTheme _theme;

  static void init({required AppTheme theme}) {
    _theme = theme;
  }

  static Future<PermissionStatus> _getPermissionStatus(Permission permission) async {
    if(Platform.isAndroid) {
      return await permission.status;
    } else {
      return await permission.request();
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    PermissionStatus status = await _getPermissionStatus(permission);

    /// iOS 相簿特例
    /// 限制所選照片、可以當作true
    if (permission == Permission.photos && status.isLimited) {
      return true;
    }

    if (status.isGranted) {
      return true;
    } else {
      bool result = await _buildPermanentlyDeniedDialog(permission, status);
      return result;
    }
  }


  static Future<bool> _buildPermanentlyDeniedDialog(Permission permission, PermissionStatus status) async {
    final PermissionInfo info = _getPermissionInfo(permission);
    if (Platform.isAndroid) {
      /// 顯示權限詳細內容（6秒後關閉）
      final OverlaySupportEntry overlay = _permissionDesDialog(info.title, info.describe);
      Timer(Duration(seconds: 6), () {if(overlay != null){overlay.dismiss();}});
      if (status == PermissionStatus.permanentlyDenied) {
        /// 前往設定權限視窗
        _showPermissionSettingDialog(permissionName:info.title, describe:info.describe,onTapAction: (){
          if(overlay != null){overlay.dismiss();}
        });
        return false;
      } else {
        /// 系統權限視窗
        PermissionStatus permissionStatus = await permission.request();
        /// 選擇後，將顯示權限詳細彈窗關閉
        if(overlay != null){overlay.dismiss();}
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else {
          /// 前往設定權限視窗
          _showPermissionSettingDialog(permissionName:info.title, describe:info.describe,onTapAction: (){
            if(overlay != null){overlay.dismiss();}
          });
          return false;
        }
      }
    } else {
      _showPermissionSettingDialog(permissionName:info.title,describe: info.describe,onTapAction: (){} );
      return false;
    }
  }



  static void _showPermissionSettingDialog({required String permissionName,required String describe,required Function() onTapAction}) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    CommDialog(currentContext).build(
      theme: _theme!,
      title: '${AppConfig.appName}想要使用你的$permissionName权限',
      contentDes: '此功能需要$permissionName权限，请到设定页面开启。',
      leftBtnTitle: '取消',
      rightBtnTitle: '前往设定',
      isDialogCancel: false,
      leftAction: () {
        onTapAction.call();
        BaseViewModel.popPage(currentContext);
      },
      rightAction: () {
        onTapAction.call();
        BaseViewModel.popPage(currentContext);
        openAppSettings();
      },
    );
  }

  static OverlaySupportEntry _permissionDesDialog(String permissionName, String des) {
    return showSimpleNotification(
      Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(width: 1, color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('$permissionName权限',
                      style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
              Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(des,
                      style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w500))),
            ],
          )),
      background: Colors.transparent,
      elevation: 0,
      autoDismiss: false,
    );
  }

  static PermissionInfo _getPermissionInfo(Permission permission){
    String permissionName = '';
    String des = '';
    switch (permission.value) {
    /// 定位
      case 3:
        permissionName = '定位';
        des = '-需要使用您的位置信息来向您推荐附近的用户';
        break;

    /// 麥克風
      case 7:
        permissionName = '麦克风';
        des =
        '${AppConfig.appName}需要取用您的麦克风以提供更好的使用体验，并实现以下功能：\n语音讯息：您可以发送语音消息给好友，这可以更生动地表达您的情感和信息。\n语音通话：支持语音通话功能，使您能够与好友进行更生动的语音通话。';
        break;

    /// 相機
      case 1:
        permissionName = '相机';
        des =
        '${AppConfig.appName}需要取用您的相机以提供更好的使用体验，并实现以下功能：\n拍摄照片：允许您拍摄照片，以在应用程序中记录和分享您的精彩时刻。\n视频通话：支持视频通话功能，使您能够与好友进行面对面的视讯通话。\n美颜设置: 允许您使用相机，进行美颜设置';
        break;

    /// 推播
      case 17:
        permissionName = '通知';
        des = '通知可包含提示、声音和图像标记。 可以在「设定」中进行设定';
        break;

    /// Media location
      case 18:
        permissionName = 'Media Location';
        des = '-需要访问您的照片库，以便您可以上传照片。';
        break;

    /// 照片與相簿
    // case 6:
      case 9:
        permissionName = '照片与相簿';
        des =
        '${AppConfig.appName}需要取用您的相簿以提供更好的使用体验并实现以下功能：\n头像设置：您可以选择更换应用程序内的头像或封面图片，这需要访问您的相簿。\n照片上传：您可以将照片上传到我们的应用程序，以分享和保存您的回忆和内容。';
        break;//
    /// 追蹤App 記錄權限
      case 25:
        permissionName = '要允许「${AppConfig.appName}」追踪您在其他公司App和网站的记录吗？';
        des = '您的数据将用于改善产品，提升使用体验。包括以下信息：\n●浏览历史：我们会记录您在应用程序中访问的页面和功能，以了解您的偏好和使用模式。\n●点击和互动：我们会记录您与应用程序中的按钮、连接和内容的互动方式，以改进用户界面和功能。';
        break;
      default:
        permissionName = '设置';
        des = '-允许前往设置';
        break;
    }
    return PermissionInfo(title:permissionName,describe: des);
  }


  static Future<bool> checkAndRequestLocationPermission() async {

    return await _requestPermission(Permission.location);
  }

  static Future<bool> checkAndRequestMicrophonePermission() async {
    return await _requestPermission(Permission.microphone);
  }

  static Future<bool> checkAndRequestCameraPermission() async {
    return await _requestPermission(Permission.camera);
  }

  static Future<bool> checkAndRequestNotificationPermission() async {
    FcPrefs.setIsCheckedNotificationPermission(true);
    return await _requestPermission(Permission.notification);
  }

  static Future<bool> checkAndRequestNetworkPermission() async {
    return await _requestPermission(Permission.accessMediaLocation);
  }

  static Future<bool> checkAndRequestStoragePermission() async {
    FcPrefs.setIsCheckedNotificationPermission(true);
    return await _requestPermission(Permission.storage);
  }

  static Future<bool> checkAndRequestGalleryPermission() async {
    // final mediaLibrary = await _requestPermission(Permission.mediaLibrary);
    if (Platform.isAndroid) {
      return true;
    }
    final photos = await _requestPermission(Permission.photos);
    return photos;
  }

  static Future<bool> checkAndRequestTrackingPermission() async {
    await Future.delayed(const Duration(seconds: 3));
    final tracking = await _requestPermission(Permission.appTrackingTransparency);
    return tracking;
  }

  /// Android only
  static Future<bool> checkAndRequestPhonePermission() async {
    final tracking = await _requestPermission(Permission.phone);
    return tracking;
  }

// static Future<bool> checkAndRequestBackgroundFetchPermission() async {
//   return await _requestPermission(Permission.);
// }


}


class PermissionInfo{
  PermissionInfo({
    required this.title,
    required this.describe,
  });
  String title;
  String describe;
}
