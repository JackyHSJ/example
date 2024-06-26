

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alipay_kit/alipay_kit_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/device_platform_model.dart';
import 'package:frechat/system/analytics/analytics_setting.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/notification/zpns/zpns_setting.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/websocket/websocket_setting.dart';
import 'package:frechat/system/zego_call/zyg_zego_setting.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zego_zpns/zego_zpns.dart';

class AppConfig {
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
  static String getDownloadPlatform() {

    return '';
  }

  static const String _frechatBundle = 'com.zyg.frechat';
  static const String _yueyuanBundle = 'com.yuanyin.yueyuan';

  static PackageInfo? _packageInfo;
  static AppEnvType? env;
  static String baseUri = '';
  static String baseDebugUri = '';

  static String wsBaseUri = '';
  static ZPNsIOSEnvironment pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
  // assets/txt/strike_up_list_pick_up_phrases.txt
  static const String _path = 'lib/system/constant/merchant.txt';

  /// zego
  static int zegoAppID = 0;
  static String zegoAppSign = '';
  static String zegoServerSecret = '';
  static ZPNsConfig zpNsConfig = ZPNsConfig();
  static AlipayEnv alipayEnv = AlipayEnv.online;

  static String getAppName() => _packageInfo?.appName ?? '';
  static String getBundleId() => _packageInfo?.packageName ?? '';

  /// 取得廠商通道
  static Future<String> get getConstantMerchant async {
    final Map<String, dynamic> merchantJson = await _loadTxt(_path);
    final String merchant = merchantJson['merchant'];
    return merchant;
  }

  static String get getDeepLinkUri {
    String deepLinkUri = '';
    final AppBundleType bundleType = _getAppBundleType;
    switch(bundleType) {
      case AppBundleType.frechat:
        deepLinkUri = HttpSetting.frechatDeepLinkUri;
        break;
      case AppBundleType.yueyuan:
        deepLinkUri = HttpSetting.yueyuanDeepLinkUri;
        break;
      default:
        deepLinkUri = HttpSetting.frechatDeepLinkUri;
        break;
    }
    return deepLinkUri;
  }

  /// 取得app bundle類型
  static AppBundleType get _getAppBundleType {
    final String bundleName = _packageInfo?.packageName ?? '';
    switch(bundleName) {
      case _frechatBundle:
        return AppBundleType.frechat;
      case _yueyuanBundle:
        return AppBundleType.yueyuan;
      default:
        return AppBundleType.frechat;
    }
  }

  static String analyticsIosAppKey = '';
  static String analyticsAndroidAppKey = '';
  static num RMBRatio = 10;

  static init(WidgetRef ref, {
    required PackageInfo packageInfo,
    required AppEnvType envType,
  }) {
    _packageInfo = packageInfo;
    env = envType;

    _initApi();
    _initWs();
    _initIm();
    _initNotification();
    _initDeepLink();
    _initPayment();
    _initAnalytics();
    _initAppTheme(ref);
  }

  static AppTheme getDefaultAppTheme() {
    AppTheme defaultTheme = AppTheme(themeType: AppThemeType.original);
    final bundleType = _getAppBundleType;
    switch(bundleType) {
      case AppBundleType.frechat:
        defaultTheme = AppTheme(themeType: AppThemeType.original);
        break;
      case AppBundleType.yueyuan:
        defaultTheme = AppTheme(themeType: AppThemeType.yueyuan);
        break;
    }
    return defaultTheme;
  }

  static _initAppTheme(WidgetRef ref) {
    final AppTheme? themeSetting = ref.read(userInfoProvider).theme;
    final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
    final AppTheme defaultAppTheme = getDefaultAppTheme();
    final AppTheme theme = themeSetting ?? defaultAppTheme;
    userUtil.setDataToPrefs(theme: theme.themeType.name);
    PermissionUtil.init(theme: theme);
  }

  ///
  static Future<String> getMerChant() async {
    final String merchant = await DevicePlatformModel.getDeviceNameForMerchant();
    final String constantMerchant = await getConstantMerchant;
    final bool isEmpty = constantMerchant.isEmpty;
    return isEmpty ? merchant : constantMerchant;
  }

  static Future<String> getDevice() async {
    final String device = await FcPrefs.getDevice();
    return device;
  }

  static String get appVersion {
    return _packageInfo?.version ?? '';
  }

  static String get appName {
    return _packageInfo?.appName ?? '';
  }

  static String get packageName {
    return _packageInfo?.packageName ?? '';
  }

  static String get version {
    final String version = _packageInfo?.version ?? '';
    final String buildNumber = _packageInfo?.buildNumber ?? '';
    return 'v$version ($buildNumber ${(kDebugMode) ? ') - Debug' : ''}${(kProfileMode) ? ' - Profile' : ''}${(kReleaseMode) ? ' - Release' : ''}';
  }

  static String get buildNumber {
    return _packageInfo?.buildNumber ?? '';
  }

  /// api
  static Future<String> getEnvStr() {
    Completer<String> completer = Completer<String>();
    _setValue(env ?? AppEnvType.Dev, onDev: (){
      completer.complete('DEV');
    }, onQA: (){
      completer.complete('QA');
    }, onUAT: (){
      completer.complete('UAT');
    }, onReview: (){
      completer.complete('DEV');//Review 暫時使用DEV API
    },onPro: (){
      completer.complete('PROD');
    });
    return completer.future;
  }

  static String getZegoUserNameWithEnv({required String userName}) {
    String name = '';
    _setValue(env ?? AppEnvType.Dev, onDev: (){
        name = userName;
      }, onQA: (){
        name = '$userName';
      }, onUAT: (){
        name = '$userName';
      }, onReview: (){
        name = '$userName';
      }, onPro: (){
        name = '$userName';
    });
    return name;
  }

  /// api
  static void _initApi() {
    _setValue(env ?? AppEnvType.Dev, onDev: (){
      baseUri = HttpSetting.baseDevUri;
      baseDebugUri = HttpSetting.baseDebugDevUri;
    }, onQA: (){
      baseUri = HttpSetting.baseQaUri;
      baseDebugUri = HttpSetting.baseDebugQaUri;
    }, onUAT: (){
      baseUri = HttpSetting.baseUatUri;
      baseDebugUri = HttpSetting.baseDebugUatUri;
    }, onReview: (){
      baseUri = HttpSetting.baseReviewUri;
      baseDebugUri = HttpSetting.baseDebugReviewUri;
    }, onPro: (){
      baseUri = HttpSetting.baseProUri;
      baseDebugUri = HttpSetting.baseDebugProUri;
    });
  }
  /// ws
  static void _initWs() {
    _setValue(env ?? AppEnvType.Dev, onDev: (){
      wsBaseUri = WebSocketSetting.baseDevUri;
    }, onQA: (){
      wsBaseUri = WebSocketSetting.baseQaUri;
    }, onUAT: (){
      wsBaseUri = WebSocketSetting.baseUatUri;
    }, onReview: (){
      wsBaseUri = WebSocketSetting.baseReviewUri;
    }, onPro: (){
      wsBaseUri = WebSocketSetting.baseProUri;
    });
  }
  /// im - zego
  static void _initIm() {
    _setValue(env ?? AppEnvType.Dev, onDev: (){
      zegoAppID = ZegoSetting.devAppID;
      zegoAppSign = ZegoSetting.devAppSign;
      zegoServerSecret = ZegoSetting.devServerSecret;
    }, onQA: (){
      zegoAppID = ZegoSetting.qaAppID;
      zegoAppSign = ZegoSetting.qaAppSign;
      zegoServerSecret = ZegoSetting.qaServerSecret;
    }, onUAT: (){
      zegoAppID = ZegoSetting.uatAppID;
      zegoAppSign = ZegoSetting.uatAppSign;
      zegoServerSecret = ZegoSetting.uatServerSecret;
    }, onReview: (){
      zegoAppID = ZegoSetting.reviewAppID;
      zegoAppSign = ZegoSetting.reviewAppSign;
      zegoServerSecret = ZegoSetting.reviewServerSecret;
    }, onPro: (){
      zegoAppID = ZegoSetting.proAppID;
      zegoAppSign = ZegoSetting.proAppSign;
      zegoServerSecret = ZegoSetting.proServerSecret;
    });
  }

  /// notification - zpns
  static void _initNotification() {
    final bundleType = _getAppBundleType;
    switch(bundleType) {
      case AppBundleType.frechat:
        _initFrechatPushConfig();
      case AppBundleType.yueyuan:
        _initYueyuanPushConfig();
      default:
        break;
    }

    _setValue(env ?? AppEnvType.Dev, onDev: (){
      pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
    }, onQA: (){
      pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
    }, onUAT: (){
      pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
    }, onReview: (){
      pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
    }, onPro: (){
      pushNotificationEnv = ZPNsIOSEnvironment.Automatic;
    });
  }
  /// deeplink - openinstall
  static void _initDeepLink() {
    _setValue(env ?? AppEnvType.Dev, onDev: (){

    }, onQA: (){
    }, onUAT: (){
    }, onReview: (){
    }, onPro: (){
    });
  }
  /// payment
  static void _initPayment() {
    _setValue(env ?? AppEnvType.Dev, onDev: (){
      alipayEnv = AlipayEnv.online;
    }, onQA: (){
      alipayEnv = AlipayEnv.online;
    }, onUAT: (){
      alipayEnv = AlipayEnv.online;
    }, onReview: (){
      alipayEnv = AlipayEnv.online;
    }, onPro: (){
      alipayEnv = AlipayEnv.online;
    });
  }
  /// analytics - sensorsdata
  static void _initAnalytics() {
    if(_getAppBundleType == AppBundleType.frechat) {
      _setValue(env ?? AppEnvType.Dev, onDev: (){
        // analyticsIosAppKey = AnalyticsSetting.iosAppKeyDEV;
        // analyticsAndroidAppKey = AnalyticsSetting.androidAppKeyDEV;
        AnalyticsSetting.isDebugMode = true;
      }, onQA: (){
        // analyticsIosAppKey = AnalyticsSetting.frechatAppKeyQA;
        analyticsAndroidAppKey = AnalyticsSetting.frechatAppKeyQA;
      }, onUAT: (){
        // analyticsIosAppKey = AnalyticsSetting.iosAppKeyUAT;
        // analyticsAndroidAppKey = AnalyticsSetting.androidAppKeyUAT;
      }, onReview: (){
        analyticsIosAppKey = AnalyticsSetting.iosFrechatAppKeyReview;
        analyticsAndroidAppKey = AnalyticsSetting.androidFrechatAppKeyReview;
      }, onPro: (){
        analyticsIosAppKey = AnalyticsSetting.iosFrechatAppKeyPro;
        analyticsAndroidAppKey = AnalyticsSetting.androidFrechatAppKeyPro;
      });
    }

    if(_getAppBundleType == AppBundleType.yueyuan) {
      _setValue(env ?? AppEnvType.Dev, onDev: (){
        // analyticsIosAppKey = AnalyticsSetting.iosAppKeyDEV;
        // analyticsAndroidAppKey = AnalyticsSetting.androidAppKeyDEV;
        AnalyticsSetting.isDebugMode = true;
      }, onQA: (){
        // analyticsIosAppKey = AnalyticsSetting.iosAppKeyQA;
        analyticsAndroidAppKey = AnalyticsSetting.yueyuanAppKeyQA;
      }, onUAT: (){
        // analyticsIosAppKey = AnalyticsSetting.iosAppKeyUAT;
        // analyticsAndroidAppKey = AnalyticsSetting.androidAppKeyUAT;
      }, onReview: (){
        analyticsIosAppKey = AnalyticsSetting.iosYueyuanAppKeyReview;
        analyticsAndroidAppKey = AnalyticsSetting.androidYueyuanAppKeyReview;
      }, onPro: (){
        analyticsIosAppKey = AnalyticsSetting.iosYueyuanAppKeyPro;
        analyticsAndroidAppKey = AnalyticsSetting.androidYueyuanAppKeyPro;
      });
    }
  }

  static void _setValue(AppEnvType envType, {
    required Function() onDev,
    required Function() onQA,
    required Function() onUAT,
    required Function() onReview,
    required Function() onPro,
  }) {
    switch (envType) {
      case AppEnvType.Dev:
        onDev();
        break;
      case AppEnvType.QA:
        onQA();
        break;
      case AppEnvType.UAT:
        onUAT();
        break;
      case AppEnvType.Review:
        onReview();
        break;
      case AppEnvType.Production:
        onPro();
        break;
      default:
        break;
    }
  }

  static Future<Map<String, dynamic>> _loadTxt(String path) async {
    final String jsonStr = await rootBundle.loadString(_path);
    final Map<String, dynamic> jsonData = jsonDecode(jsonStr);
    return jsonData;
  }

  static void _initFrechatPushConfig() {
    zpNsConfig
      ..enableHWPush = true
      ..enableMiPush = true
      ..enableVivoPush = true
      ..enableOppoPush = true
      ..enableFCMPush = false
      ..miAppID = ZpnsSetting.frechatMiAppID
      ..miAppKey = ZpnsSetting.frechatMiAppKey
      ..oppoAppID = ZpnsSetting.frechatOppoAppID
      ..oppoAppSecret = ZpnsSetting.frechatOppoAppSecret
      ..oppoAppKey = ZpnsSetting.frechatOppoAppKey
      ..vivoAppID = ZpnsSetting.frechatVivoAppID
      ..vivoAppKey = ZpnsSetting.frechatVivoAppKey
      ..hwAppID = ZpnsSetting.frechatHwAppID
      ..appType = 1;
  }

  static void _initYueyuanPushConfig() {
    zpNsConfig
      ..enableHWPush = false
      ..enableMiPush = false
      ..enableVivoPush = false
      ..enableOppoPush = false
      ..enableFCMPush = false
      ..miAppID = ZpnsSetting.yueyuanMiAppID
      ..miAppKey = ZpnsSetting.yueyuanMiAppKey
      ..oppoAppID = ZpnsSetting.yueyuanOppoAppID
      ..oppoAppSecret = ZpnsSetting.yueyuanOppoAppSecret
      ..oppoAppKey = ZpnsSetting.yueyuanOppoAppKey
      ..vivoAppID = ZpnsSetting.yueyuanVivoAppID
      ..vivoAppKey = ZpnsSetting.yueyuanVivoAppKey
      ..hwAppID = ZpnsSetting.yueyuanHwAppID
      ..appType = 2;
  }
}