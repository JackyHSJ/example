class HttpSetting {
  HttpSetting._();

  /// MARK: develop Setting
  static const String baseDevUri = 'https://www.gscjcplive.com/freChat';
  static const String baseUatUri = "";
  static const String baseQaUri = "https://www.yuanyuqa.com/freChat";
  static const String baseReviewUri = "https://web.moonyuan520.com/freChat"; //"https://www.yuanyulife.com/freChat"
  static const String baseProUri = 'https://dcdntest.yuanyu520.com/freChat'; // 'https://web.yuanyu520.com/freChat';

  /// Debug logs setting
  static const String baseDebugDevUri = 'https://debug.gscjcplive.com/freChat';
  static const String baseDebugUatUri = "";
  static const String baseDebugQaUri = "https://debug.yuanyuqa.com/freChat";
  static const String baseDebugReviewUri = "https://web.moonyuan520.com/freChat"; //"https://debug.yuanyulife.com/freChat"
  static const String baseDebugProUri = 'https://debug.yuanyu520.com/freChat';

  static String baseImagePath = '';
  static const String frechatDeepLinkUri = 'https://landing.yuanyu520.com';
  static const String yueyuanDeepLinkUri = 'https://landing.moonyuan520.com';


  /// com.testii.co
  /// com.testii.cy
  /// com.testii.ce
  /// com.teatii.cw
  /// com.testii.ca

  static const bool debugMode = true;

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;
}
