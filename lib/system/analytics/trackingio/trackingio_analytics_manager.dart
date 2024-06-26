import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/analytics/analytics_setting.dart';
import 'package:frechat/system/analytics/device_id_for_ad.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:trackingio_flutter_plugin/trackingio_flutter_plugin.dart';

class TrackingIOManager {
  TrackingIOManager({required this.ref});
  ProviderRef ref;

  _isDevEnv() {
    final bool isDevEnv = AppConfig.env == AppEnvType.Dev;
    return isDevEnv;
  }

  String _getAppKey() {
    final bool isIOS = Platform.isIOS;
    final String appKey = (isIOS) ? AppConfig.analyticsIosAppKey : AppConfig.analyticsAndroidAppKey;
    return appKey;
  }

  /// 在所有方法之前调用的方法，用于预初始化 TrackingIO。
  /// 必须在其他方法之前调用。
  void _preInit(String appKey) {
    TrackingioFlutterPlugin.preInitTrackingIO(appKey);
  }

  /// 设置是否启用 Debug 模式，仅在开发环境中进行 Debug 测试时使用。
  /// 默认值为 false，关闭 Debug 模式。在生产环境中应设置为 false。
  void setDebug(bool enableDebug) {
    TrackingioFlutterPlugin.enablePrintLog(enableDebug);
  }

  /// 初始化 TrackingIO SDK。
  /// 需要在 Android 和 iOS 平台上调用，传递相应的参数。
  /// installParams 追蹤安裝來源
  /// startupParams 追蹤啟動來源
  Future<void> init() async {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    final String appKey = _getAppKey();
    _preInit(appKey);

    /// 檢查權限
    // final bool permissionStatus = await _getPermission();
    // if(permissionStatus == false) {
    //   // return;
    // }

    final deviceId = await DeviceIdForAd.getIdfaOrCaid();
    if(deviceId == '') {

    }

    if (Platform.isAndroid || Platform.isIOS) {
      final String merchant = await AppConfig.getMerChant();
      TrackingioFlutterPlugin.initTrackingIO(
        appKey,
        merchant,
        'caid',
        "caid2",
        {},
        {},
      );
    }

    /// 設定環境
    if(AnalyticsSetting.isDebugMode) {
      setDebug(true);
    }
  }

  Future<bool> _getPermission () async {
    final bool permissionStatus = await PermissionUtil.checkAndRequestPhonePermission();
    return permissionStatus;
  }

  /// 发送登录事件到 TrackingIO。
  /// [userId]: 登录用户的唯一标识。
  /// [properties]: 登录事件的属性。
  void login(String userId, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.login(userId, properties);
  }

  /// 发送注册事件到 TrackingIO。
  /// [userId]: 注册用户的唯一标识。
  /// [properties]: 注册事件的属性。
  void register(String userId, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.register(userId, properties);
  }

  /// 发送订单信息到 TrackingIO。
  /// [orderId]: 订单的唯一标识。
  /// [currency]: 订单货币类型。
  /// [amount]: 订单金额。
  /// [properties]: 订单事件的属性。
  void setOrder(String orderId, String currency, String amount, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.setDD(orderId, currency, amount, properties);
  }

  /// 发送支付信息到 TrackingIO。
  /// [paymentId]: 支付的唯一标识。
  /// [paymentMethod]: 支付方式。
  /// [currency]: 支付货币类型。
  /// [amount]: 支付金额。
  /// [properties]: 支付事件的属性。
  void setPayment(String paymentId, String paymentMethod, String currencyType, String amount, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.setZF(paymentId, paymentMethod, currencyType, amount, properties);
  }

  /// 发送广告展示事件到 TrackingIO。
  /// [platform]: 广告平台。
  /// [adId]: 广告的唯一标识。
  /// [showType]: 广告展示类型。
  /// [properties]: 广告展示事件的属性。
  void setAdShow(String platform, String adId, int showType, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.setAdShow(platform, adId, showType, properties);
  }

  /// 发送广告点击事件到 TrackingIO。
  /// [platform]: 广告平台。
  /// [adId]: 广告的唯一标识。
  /// [properties]: 广告点击事件的属性。
  void setAdClick(String platform, String adId, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.setAdClick(platform, adId, properties);
  }

  /// 发送页面浏览事件到 TrackingIO。
  /// [pageName]: 页面名称。
  /// [duration]: 页面浏览时长。
  /// [properties]: 页面浏览事件的属性。
  void trackView(String pageName, int duration, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.trackView(pageName, duration, properties);
  }

  /// 发送应用时长事件到 TrackingIO。
  /// [duration]: 应用运行时长。
  /// [properties]: 应用时长事件的属性。
  void trackAppDuration(int duration, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.trackAppDuration(duration, properties);
  }

  /// 发送自定义事件到 TrackingIO。
  /// [eventName]: 自定义事件名称。
  /// [properties]: 自定义事件的属性。
  void setEvent(String eventName, Map<String, dynamic> properties) {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return ;
    }

    TrackingioFlutterPlugin.setEvent(eventName, properties);
  }

  /// 获取设备唯一标识（Device ID）。
  /// 返回值为设备唯一标识。
  Future<String> getDeviceId() async {
    final bool isDevEnv = _isDevEnv();
    if(isDevEnv) {
      return '';
    }

    String deviceId = "";
    try {
      deviceId = await TrackingioFlutterPlugin.getDeviceId ?? '';
    } catch(e) {
      deviceId = 'Failed to get distinctId: $e';
    }
    return deviceId;
  }
}
