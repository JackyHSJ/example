import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/error_log_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/ws_base_res.dart';
import 'package:frechat/models/ws_res/ws_hand_shake_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_setting.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';

import '../../screens/launch/launch.dart';
import '../ws_comm/ws_params_req.dart';

class WebSocketUtil {
  WebSocketUtil({
    this.ref
  });
  ProviderRef? ref;
  StreamSubscription? streamSubscription;
  late Function onConnectSuccess;
  late Function onConnectFail;

  /// WebSocket連線, 心跳專用
  Future<void> connectWebSocket({Function(String)? onConnectSuccess, Function(String)? onConnectFail}) async {
    this.onConnectSuccess = onConnectSuccess!;
    this.onConnectFail = onConnectFail!;

    WebSocketHandler.initWebSocket(
      onOpen: () {
        WebSocketHandler.bRepeatingLogin = false;
        print('MainDart WS onOpen');
      },
      onMessage: (data) {

        /// 心跳檢查，不等於1 直接中斷程式碼。回复型態為int
        if (data.runtimeType == int && data != 1) {
          print('心跳檢查，不等於1 直接中斷程式碼。回复型態為int');
          return;
        }
        print('心跳成功');

        /// 監聽 接收訊息並檢查response是否為空
        final res = WebSocketHandler.getACKData(data);
        if(res == null) {
          return;
        }
        _listenerHandShake(wsBaseRes: res);
        _repeatLoginReConnectOrLock(wsBaseRes: res);
        _sendErrorLog(wsBaseRes: res);
      },
      onError: (error) {
        print('MainDart WS onError ' + error.toString());
        this.onConnectFail(error);
      },
      onHeartBeatReconnect: (reconnectTime) async {
        /// 每10次重連做一次login刷新token
        _heartBeatReconnect(reconnectTime);
        _periodShowToast(reconnectTime);
      },
      onHeartBeatReceive: () {
        ref?.read(newUserBehaviorManagerProvider).stateController.add(NewUserBehaviorState.onlineDuration);
      },
      onHeartBeatLostConnect: () {
        /// 檢查是否通話中, 假如正在通話中須先結束通話
        // final UserCallStatus userCallStatus = ref?.read(userInfoProvider).userCallStatus ?? UserCallStatus.init;
        // if (userCallStatus == UserCallStatus.calling) {
        //   final BuildContext currentContext = BaseViewModel.getGlobalContext();
        //   BaseViewModel.showToast(currentContext, '亲～网速太慢, 尽速重连中呦');
        //   ref?.read(callAuthenticationManagerProvider).endCall(
        //       currentContext,
        //       callData: GlobalData.cacheCallData!,
        //       roomId: GlobalData.cacheRoomID!,
        //       channel: GlobalData.cacheChannel!,
        //       searchListInfo: GlobalData.cacheSearchListInfo!,
        //       onDispose: () {}
        //   );
        //   ref?.read(expressUtilProvider).dispose();
        // }
        _closeStreamSubscription();
      }
    );
  }

  /// 監聽用
  Future<void> onWebSocketListen({required WsBaseReq functionObj, required Function(WsBaseRes) onReceiveData}) async {
    streamSubscription = WebSocketHandler.streamController.stream.listen((data) async {
      /// 監聽 接收訊息並檢查response是否為空
      final res = WebSocketHandler.getACKData(data);
      if(res == null) {
        return;
      }
      if(res.f == functionObj.f) {
        onReceiveData(res);
      }
    });
  }

  /// 監聽dispose用
  Future<void> onWebSocketListenDispose() async {
    _closeStreamSubscription();
  }

  /// dispose
  Future<void> onWebSocketDispose() async {
    _closeStreamSubscription();
    WebSocketHandler.closeSocket();
  }

  _listenerHandShake({required WsBaseRes wsBaseRes}) {
    /// 檢查function id
    if(wsBaseRes.f != WsParamsReq.handshake.f) {
      return;
    }

    if (wsBaseRes.resultCode != ResponseCode.CODE_SUCCESS) {
      return ;
    }
    final WsHandShakeRes result = WsHandShakeRes.fromJson(wsBaseRes.resultMap);

    /// load http image url
    HttpSetting.baseImagePath = '${result.sysConfig?.fileUrl}/' ?? '';

    final ButtonConfigList defaultButtonConfigList = _initBtnConfig();
    final UserNotifier? userModelUtil = ref?.read(userUtilProvider.notifier);
    userModelUtil?.setDataToPrefs(buttonConfigList: result.buttonConfig ?? defaultButtonConfigList);
    userModelUtil?.setDataToPrefs(myVisitorExpireTime: result.myVisitorExpireTime);
    userModelUtil?.setDataToPrefs(orderComputeCondition: result.orderComputeCondition);

    onConnectSuccess(wsBaseRes.resultCode);
    WebSocketHandler.initHeartBeat();
  }

  /// 被重複登入踢出
  _repeatLoginReConnectOrLock({required WsBaseRes wsBaseRes}) {
    /// 檢查function id
    if(wsBaseRes.resultCode != WsParamsReq.repeatLogin.f) {
      return;
    }
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    if(wsBaseRes.resultCode == WsParamsReq.repeatLogin.f) BaseViewModel.showToast(currentContext, '亲～被重复登入啰');

    print('被重複登入');
    WebSocketHandler.bRepeatingLogin = true;
    WebSocketHandler.closeSocket();
    _logout();
    return;
  }

  _closeStreamSubscription() {
    if(streamSubscription == null) {
      return;
    }
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  ButtonConfigList _initBtnConfig() {
    return ButtonConfigList(
      callType: 1,
      officialType: 1,
      intimacyType: 1,
      tvWallType: 1,
      mateType: 1,
      withdrawType: 0,
      type7: 1,
      activityType: 1,
      gmType: 1,
      blockType: 1,
    );
  }

  _logout() {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    ref?.read(authenticationProvider).logout(
        onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(currentContext, GlobalData.launch ?? const Launch()),
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, errMsg)
    );
  }

  _periodShowToast(int reconnectTime) {
    if(reconnectTime % 5 == 0) {
      final BuildContext context = BaseViewModel.getGlobalContext();
      BaseViewModel.showToast(context, '亲～网速过慢重连中呦');
    }
  }

  Future<void> _heartBeatReconnect(int time) async {
    /// 每10次重連做一次login刷新token ,檢查是不是10次倍數
    final bool isTenTime = time % WebSocketSetting.reconnectAndLoginCount == 0;
    if(isTenTime) {
      _loginAndOpenSocket();
      return ;
    }
    WebSocketHandler.openSocket();
  }

  Future<void> _loginAndOpenSocket() async {
    String? resultCodeCheck;
    await ref?.read(commApiProvider).memberLogin(null,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      WebSocketHandler.openSocket();
    }
  }

  _sendErrorLog({required WsBaseRes wsBaseRes}) {
    if(wsBaseRes.resultCode == ResponseCode.CODE_SUCCESS) {
      return ;
    }
    final String userName = GlobalData.memberInfo?.userName ?? '';
    final ErrorLogReq headers = ErrorLogReq(
      userName: userName,
      funcCode: wsBaseRes.f,
      resultCode: wsBaseRes.resultCode,
      resultMsg: wsBaseRes.resultMsg,
    );

    ref?.read(commApiProvider).sendErrorMsgLog(headers);
  }
}