
class WebSocketSetting {
  WebSocketSetting._();

  ///MARK: develop Setting
  static const String baseDevUri = 'wss://www.gscjcplive.com/freChat/WebSocketServer/?';
  static const String baseQaUri = "wss://www.yuanyuqa.com/freChat/WebSocketServer/?";
  static const String baseUatUri = "";
  static const String baseReviewUri = 'wss://web.moonyuan520.com/freChat/WebSocketServer/?'; //'wss://www.yuanyulife.com/freChat/WebSocketServer/?'
  static const String baseProUri = "wss://dcdntest.yuanyu520.com/freChat/WebSocketServer/?"; // "wss://web.yuanyu520.com/freChat/WebSocketServer/?";

  static const bool debugMode = true;

  /// 心跳間隔(秒)
  static const int heartTimes = 5;

  /// 心跳重連時間
  static const int reconnectTimes = 3;

  /// 最大重連次數
  static const int reconnectAndLoginCount = 10;
}
