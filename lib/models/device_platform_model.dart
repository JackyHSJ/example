
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:frechat/system/global/shared_preferance.dart';

/// 下載平台
/// APPLE 苹果
/// HUAWEI 华为
/// VIVO
/// OPPO
/// XIAOMI 小米
/// TENCENT  应用宝
/// BAIDU 百度
/// LENOVO 联想
/// MEIZU 魅族
/// REALME
/// NUBIA 努比亞
/// ZTE
/// TCL
/// ONEPLUS
class DevicePlatformModel {
  static String apple = 'APPLE';
  static String huawei = 'HUAWEI';
  static String vivo = 'VIVO';
  static String oppo = 'OPPO';
  static String xiaomi = 'XIAOMI';
  static String tencent = 'TENCENT';
  static String baidu = 'BAIDU';
  static String lenovo = 'LENOVO';
  static String meizu = 'MEIZU';
  static String realme = 'REALME';
  static String nubia = 'NUBIA';
  static String zte = 'ZTE';
  static String tcl = 'TCL';
  static String oneplus = 'ONEPLUS';
  static String openinstall = 'OPENINSTALL';

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // static List<String> platformList = [apple, huawei, vivo, oppo, xiaomi, tencent, baidu, lenovo, meizu];

  //取得設備型號
  static Future<String> getDeviceModel({
    bool setToPrefs = true
}) async {
    String deviceModel;
    String deviceManufacturer;

    if (Platform.isAndroid) {
      //取得Android設備信息
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      deviceManufacturer = androidInfo.manufacturer;
    } else {
      //取得Ios設備信息
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      deviceModel = iosInfo.model;
      deviceManufacturer = DevicePlatformModel.apple;
    }

    if(setToPrefs) {
      FcPrefs.setDevice(deviceModel);
      FcPrefs.setBeautyStatus(true);
    }

    return deviceManufacturer;
  }

  static Future<String> getDeviceNameForMerchant() async {
    /// 預設值
    String merchant = DevicePlatformModel.huawei;
    if(Platform.isIOS) {
      merchant = DevicePlatformModel.apple;
    } else {
      final deviceModel =(await getDeviceModel(setToPrefs: false)).toUpperCase();
      if(deviceModel.contains('HUAWEI')) {
        merchant = DevicePlatformModel.huawei;
      } else if(deviceModel.contains('VIVO')) {
        merchant = DevicePlatformModel.vivo;
      } else if(deviceModel.contains('OPPO')) {
        merchant = DevicePlatformModel.oppo;
      } else if(deviceModel.contains('XIAOMI')) {
        merchant = DevicePlatformModel.xiaomi;
      } else if(deviceModel.contains('TENCENT')) {
        merchant = DevicePlatformModel.tencent;
      } else if(deviceModel.contains('BAIDU')) {
        merchant = DevicePlatformModel.baidu;
      } else if(deviceModel.contains('LENOVO')) {
        merchant = DevicePlatformModel.lenovo;
      } else if(deviceModel.contains('MEIZU')) {
        merchant = DevicePlatformModel.meizu;
      } else if(deviceModel.contains('REALME')) {
        merchant = DevicePlatformModel.realme;
      } else if(deviceModel.contains('NUBIA')) {
        merchant = DevicePlatformModel.nubia;
      } else if(deviceModel.contains('ZTE')) {
        merchant = DevicePlatformModel.zte;
      } else if(deviceModel.contains('TCL')) {
        merchant = DevicePlatformModel.tcl;
      } else if(deviceModel.contains('ONEPLUS')) {
        merchant = DevicePlatformModel.oneplus;
      }
    }
    return merchant;
  }
}