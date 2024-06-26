

class AnalyticsSetting {

  static String serverUrl = ''; // "https://sdkdebugtest.datasink.sensorsdata.cn/sa?project=default&token=cfb8b60e42e0ae9b"
  static int flushInterval = 30000;
  static int flushBulkSize = 150;
  static int androidMaxCacheSize = 48 * 1024 * 1024;
  static int iOSMaxCacheSize = 10000;

  /// 熱雲
  /// iOS
  /// Frechat
  static String iosFrechatAppKeyReview = 'dd910c0df5630932d5a1111e1126fedd';
  static String iosFrechatAppKeyPro = 'dd910c0df5630932d5a1111e1126fedd';

  /// Yueyuan
  static String iosYueyuanAppKeyReview = '8114c8a730f0bcff3d1b29523f9672fe';
  static String iosYueyuanAppKeyPro = '8114c8a730f0bcff3d1b29523f9672fe';

  /// Android
  /// Frechat
  static String androidFrechatAppKeyReview = 'b91dc34c85d4f572dc7a49c16017039e';
  static String androidFrechatAppKeyPro = 'b91dc34c85d4f572dc7a49c16017039e';

  /// Yueyuan
  static String androidYueyuanAppKeyReview = '1100ef36b86f540168971224565d0541';
  static String androidYueyuanAppKeyPro = '1100ef36b86f540168971224565d0541';

  /// QA Frechat
  static String frechatAppKeyQA = '2539582298f6ec8d9a0647eb9ee03591';
  static String yueyuanAppKeyQA = '2c06e367e55f4dd6a8cfa9679e3b319d';

  static bool isDebugMode = false;
}