import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/ws_base_res.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/websocket/websocket_setting.dart';
import 'package:frechat/system/websocket/websocket_status.dart';

import 'package:zyg_websocket_plugin/io.dart';
import 'package:zyg_websocket_plugin/web_socket_channel.dart';

import '../global/shared_preferance.dart';
import '../util/timer.dart';

class WebSocketHandler {
  static late WebSocketChannel channel; // WebSocket
  static StreamController streamController = StreamController.broadcast(); // 流控制器，多頁面才能監聽同一流
  static SocketStatus socketStatus = SocketStatus.SocketStatusClosed; // 連線狀態
  static late Timer _heartBeat; // 心跳
  static late Timer reconnectTimer; // 重連定時

  static late Function onError; // Socket Error
  static late Function onOpen; // Socket Open
  static late Function onMessage; // Get Message
  static late Function(int) onHeartBeatReconnect; // Get Message
  static late Function onHeartBeatLostConnect; // Get Message
  static late Function onHeartBeatReceive; // Get Message

  static late StreamSubscription streamSubscription;
  static bool bStillWaitingACK = false; // 由伺服器端斷線的情況下作為自動重連
  static bool bRepeatingLogin = false;

  /// 重連次數紀錄
  static late int _reconnectTimes = 0;

  /// 取得WebSocket地址
  static Future<String> get _getSocketUri async {
    final String token = await FcPrefs.getCommToken();
    final String merchant = await AppConfig.getMerChant();
    final String uri = '${AppConfig.wsBaseUri}tId=$token&merchant=$merchant';
    return uri;
  }

  /// 初始化WebSocket
  static void initWebSocket({
    required Function onOpen, required Function onMessage,
    required Function onError,
    required Function(int) onHeartBeatReconnect,
    required Function onHeartBeatLostConnect,
    required Function onHeartBeatReceive
  }) {
    WebSocketHandler.onOpen = onOpen;
    WebSocketHandler.onMessage = onMessage;
    WebSocketHandler.onError = onError;
    WebSocketHandler.onHeartBeatReconnect = onHeartBeatReconnect;
    WebSocketHandler.onHeartBeatLostConnect = onHeartBeatLostConnect;
    WebSocketHandler.onHeartBeatReceive = onHeartBeatReceive;
    openSocket();
  }

  /// 執行WebSocket連線
  static Future<void> openSocket({Function()? onConnectSuccess}) async {
    if (socketStatus == SocketStatus.SocketStatusConnected) {
      cancelReconnectTimer();
      return;
    }

    Map<String, dynamic> header = {};
    // header['Authorization'] = 'commToken';
    try {
      channel = await IOWebSocketChannel.connect(await _getSocketUri, headers: header);
      print('WebSocket連線成功: ${await _getSocketUri}');
      socketStatus = SocketStatus.SocketStatusConnected;
      onConnectSuccess?.call();
      cancelReconnectTimer();
    } catch(e) {
      print('WebSocket連線失敗: $e');
      webSocketOnError(e);
      return;
    }
    // 連線成功，將channel放進stream，由streamController來做監聽
    streamController.addStream(channel.stream);
    bStillWaitingACK = false;

    // 連線成功，重置計數器
    _reconnectTimes = 0;

    // 由MainScreen啟動心跳
    onOpen();

    // 接收消息
    socketListener();
  }

  /// 當前是否已連線成功
  static bool isSocketConnected() {
    return socketStatus == SocketStatus.SocketStatusConnected;
  }

  /// WebSocket監聽
  static void socketListener() {
    streamSubscription = streamController.stream.listen((data) =>
        webSocketOnMessage(data),
        onError: webSocketOnError, onDone: webSocketOnDone);
  }

  /// WebSocket收到消息
  static webSocketOnMessage(data) {
    onMessage(data);
  }

  /// WebSocket關閉連線
  static webSocketOnDone() {
    print('WebSocketOnDone 關閉連線');
    closeSocket();
    reconnect();
  }

  /// WebSocket連線錯誤
  static webSocketOnError(e) {
    print('WebSocket連線錯誤');
    WebSocketChannelException ex = e;
    socketStatus = SocketStatus.SocketStatusClosed;
    onError(ex.message);
    closeSocket();
  }

  /// Init心跳
  static void initHeartBeat() {
    _heartBeat = TimerUtil.periodic(
        timerType: TimerType.seconds,
        timerNum: WebSocketSetting.heartTimes,
        timerCallback: (time) => sentHeart());
  }

  /// 心跳
  static void sentHeart() {
    if (bStillWaitingACK && bRepeatingLogin == false) { // 被伺服器端斷線了
      print('被伺服器斷線 開始進行重連');
      onHeartBeatLostConnect();
      closeSocket();
      reconnect();
      return;
    }

    bStillWaitingACK = true;
    // Map<String, dynamic> heartBeat = {};
    // heartBeat['topic'] = 'heartBeat';
    // var jsonStr = json.encode(heartBeat);
    sendMessage('0');
  }

  /// 銷毀心跳
  static void destroyHeartBeat() {
    _heartBeat.cancel();
  }

  /// 關閉WebSocket
  static void closeSocket() {
    print('WebSocket關閉');
    try{
      channel.sink.close();
      streamSubscription.cancel();
      destroyHeartBeat();
      socketStatus = SocketStatus.SocketStatusClosed;
    } catch (e) {
      print('closeSocket not init');
    }
  }

  /// 心跳重連機制
  static void reconnect() {
    reconnectTimer = TimerUtil.periodic(
      timerType: TimerType.seconds,
      timerNum: WebSocketSetting.reconnectTimes,
      timerCallback: (time) {
        if (socketStatus == SocketStatus.SocketStatusClosed) {
          onHeartBeatReconnect(time.tick);
        }
      });
  }

  //////////////////////////////////////////////////////////////////////////////
  //// 上面連線 ////            //// 下面傳接 ////
  //////////////////////////////////////////////////////////////////////////////

  /// WebSocket Send Msg
  static void sendMessage(String message) {
    switch (socketStatus) {
      case SocketStatus.SocketStatusConnected:
        print('訊息發送中');
        channel.sink.add(message);
        break;
      case SocketStatus.SocketStatusClosed:
        print('已斷線');
        break;
      case SocketStatus.SocketStatusFailed:
        print('發訊息失敗');
        break;
      default:
        break;
    }
  }

  /// WebSocket 發送Data
  static Future<WsBaseRes> sendData(WsBaseReq data, {
    required String funcCode,
    Function(String)? onConnectSuccess,
    Function(String)? onConnectFail,
  }) async {
    final String jsonStr = json.encode(data);
    sendMessage(jsonStr);
    GlobalData.cacheLogs.add('發出去的jsonStr: $jsonStr');
    print('發出去的jsonStr: $jsonStr');

    // 等待接收到消息
    final WsBaseRes res = await streamController.stream
        .where((msg) => msg is String)
        .map((msg) => json.decode(msg))
        .where((jsonObj) => jsonObj is Map<String, dynamic>)
        .map((jsonObj) => WsBaseRes.fromJson(jsonObj))
        .firstWhere((res) => _checkResWithFuncCodeANdUuid(funcCode: funcCode, wsBaseRes: res, wsBaseReq: data));

    /// 傳回callback
    if(res.resultCode == ResponseCode.CODE_SUCCESS){
      onConnectSuccess?.call(res.resultCode ?? '');
    } else {
      onConnectFail?.call(res.resultCode ?? '');
    }

    return res;
  }

  /// WebSocket ACK資料轉Data
  static WsBaseRes? getACKData(String jsonStr) {
    bStillWaitingACK = false;
    GlobalData.cacheLogs.add('ACK訊息：$jsonStr');
    print('ACK訊息：$jsonStr');
    final time = DateTime.now();
    final timeFormat = DateFormatUtil.getDateWith12HourFormat(time);
    GlobalData.cacheLogs.add('current time:$timeFormat');
    debugPrint('current time:$timeFormat');
    final dynamic jsonResult = json.decode(jsonStr);
    if (jsonResult is Map<String, dynamic>) {
      WsBaseRes data = WsBaseRes.fromJson(jsonResult);
      return data;
    }

    if(jsonResult is num) {
      if(jsonResult == 1) {
        onHeartBeatReceive();
      }
      return null;
    }

    return null;
  }

  static void cancelReconnectTimer() {
    try { // 防尚未init
      reconnectTimer.cancel();
    } catch (e) {
      print('reconnectTimer.cancel(); $e');
      return;
    }
  }

  static bool _checkResWithFuncCodeANdUuid({
    required String funcCode,
    required WsBaseRes wsBaseRes,
    required WsBaseReq wsBaseReq
  }) {
    if(wsBaseReq.rId == null) {
      return (wsBaseRes.f == funcCode);
    }
    return (wsBaseRes.f == funcCode && wsBaseRes.rId == wsBaseReq.rId);
  }
}