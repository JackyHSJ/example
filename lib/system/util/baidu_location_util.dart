//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter_bmflocation/flutter_bmflocation.dart';
// import 'package:frechat/system/util/permission_util.dart';
//
//
// class BaiduLocationUtil {
//
//   static final LocationFlutterPlugin locationPlugin = LocationFlutterPlugin();
//   static bool _isAlreadyInit = false;
//
//   static Future<void> _init() async {
//     // 设置是否隐私政策
//     locationPlugin.setAgreePrivacy(true);
//
//     if (Platform.isIOS) {
//       /// 设置ios端ak, android端ak可以直接在清单文件中配置
//       locationPlugin.authAK('wcvH3sqUxBKsSZAqiL3aE7gTlEsp6GHf');
//     } else if (Platform.isAndroid) {
//
//     }
//
//     /// iOS端鉴权结果
//     locationPlugin.getApiKeyCallback(callback: (String result) {
//       String str = result;
//       print('鉴权结果：' + str);
//     });
//   }
//
//   static Future<String> getLocation() async {
//     await PermissionUtil.checkAndRequestLocationPermission();
//     if(_isAlreadyInit == false) {
//       await _init();
//       _isAlreadyInit = true;
//     }
//     await _locationAction();
//     return await _startLocation();
//   }
//
//   /// 启动定位
//   static Future<String> _startLocation() async {
//     if (Platform.isIOS) {
//       return await _getIosLocation();
//     } else {
//       return await _getAndroidLocation();
//     }
//   }
//
//   static Future<void> _locationAction() async {
//     /// 设置android端和ios端定位参数
//     /// android 端设置定位参数
//     /// ios 端设置定位参数
//     Map iosMap = _initIOSOptions().getMap();
//     Map androidMap = _initAndroidOptions().getMap();
//
//     await locationPlugin.prepareLoc(androidMap, iosMap);
//   }
//
//   static BaiduLocationIOSOption _initIOSOptions() {
//     BaiduLocationIOSOption options = BaiduLocationIOSOption(
//         coordType: BMFLocationCoordType.bd09ll,
//         BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
//         desiredAccuracy: BMFDesiredAccuracy.best);
//     return options;
//   }
//
//   /// 设置地图参数
//   static BaiduLocationAndroidOption _initAndroidOptions() {
//     /// android 端设置定位参数
//     BaiduLocationAndroidOption androidOption = BaiduLocationAndroidOption(coordType: BMFLocationCoordType.bd09ll);
//
//     /// 可选，设置返回经纬度坐标类型，默认gcj02
//     /// gcj02：国测局坐标；
//     /// bd09ll：百度经纬度坐标；
//     /// bd09：百度墨卡托坐标；
//     /// 海外地区定位，无需设置坐标类型，统一返回wgs84类型坐标
//     androidOption.setCoorType("bd09ll");
//     androidOption.setIsNeedAltitude(true); /// 设置是否需要返回海拔高度信息
//     androidOption.setIsNeedAddress(true); /// 设置是否需要返回地址信息
//     androidOption.setIsNeedLocationPoiList(true); /// 设置是否需要返回周边poi信息
//     androidOption.setIsNeedNewVersionRgc(true); /// 设置是否需要返回最新版本rgc信息
//     androidOption.setIsNeedLocationDescribe(true); /// 设置是否需要返回位置描述
//     androidOption.setOpenGps(true); /// 设置是否需要使用gps
//
//     /// 可选，设置定位模式，可选的模式有高精度、低功耗、仅设备，默认为高精度模式，可选值如下：
//     /// 高精度模式: LocationMode.Hight_Accuracy
//     /// 低功耗模式：LocationMode.Battery_Saving
//     /// 仅设备(Gps)模式：LocationMode.Device_Sensors
//     androidOption.setLocationMode(BMFLocationMode.hightAccuracy);
//
//     /// 可选，设置发起定位请求的间隔，int类型，单位ms
//     /// 如果设置为0，则代表单次定位，即仅定位一次，默认为0
//     /// 如果设置非0，需设置1000ms以上才有效
//     androidOption.setScanspan(1000);
//
//     /// 可选，设置场景定位参数，包括签到场景、运动场景、出行场景，可选值如下：
//     /// 签到场景: BDLocationPurpose.SignIn
//     /// 运动场景: BDLocationPurpose.Transport
//     /// 出行场景: BDLocationPurpose.Sport
//     androidOption.setLocationPurpose(BMFLocationPurpose.signIn);
//
//     return androidOption;
//   }
//
//
//   /// "纬度 : ${result.latitude}
//   /// "经度 : ${result.longitude}
//   /// "地址 : ${result.address}
//   /// "位置语义化描述 : ${result.locationDetail}
//   /// "国家 : ${result.country}
//   /// "省份 : ${result.province}
//   /// "城市 : ${result.city}
//   /// "区县 : ${result.district}
//   /// "街道 : ${result.street}
//   static Future<String> _getIosLocation() async {
//     Completer<String> completer = Completer<String>();
//     await locationPlugin.singleLocation({'isReGeocode': true, 'isNetworkState': true});
//     locationPlugin.singleLocationCallback(callback: (BaiduLocation result) {
//       completer.complete(result.city ?? '');
//     });
//
//     return completer.future;
//   }
//
//   static Future<String> _getAndroidLocation() async {
//     Completer<String> completer = Completer<String>();
//     await locationPlugin.startLocation();
//     locationPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
//       locationPlugin.stopLocation();
//       completer.complete(result.city ?? '');
//     });
//     return completer.future;
//   }
// }
//
