import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_block_group_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_press_btn_and_remove_black_account_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_press_btn_and_remove_black_account_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/websocket/websocket_manager.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FcPrefs.mockInitial();
  String resultCodeCheck = '';
  String errorMsgCheck = '';

  _initWs() async {
    // /// websocket connect & open listener
    // await WebSocketUtil.connectWebSocket();
    // await WebSocketUtil.onWebSocketListen();
  }

  test('ws handshake', () async {
    _initWs();
  });

  // test('ws searchListResProvider test', () async {
  //   await _initWs();
  //   // 建立一個 ProviderContainer
  //   final container = ProviderContainer();
  //   final searchListProvider = FutureProvider<WsNotificationSearchListRes>((ref) async {
  //     /// ---參考以下---
  //     final reqBody = WsNotificationSearchListReq.create(
  //       page: '1',
  //       roomId: 9980,
  //       type: 0
  //     );
  //     final res = await ref.read(notificationWsProvider).wsNotificationSearchList(reqBody,
  //         onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
  //         onConnectFail: (errMsg) => errorMsgCheck = errMsg
  //     );
  //     /// ---參考以上---
  //     return res;
  //   });
  //
  //   // 使用 container.read 讀取 provider
  //   final result = await container.read(searchListProvider.future);
  //   print('ws searchListResProvider test: ${result.toJson()}');
  //   // 驗證結果
  //   print('驗證結果: $resultCodeCheck');
  //   print('驗證結果 Error: $errorMsgCheck');
  //   expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
  //
  //   // 清理 container
  //   container.dispose();
  // });

  test('ws strike up test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final strikeUpProvider = FutureProvider<WsNotificationStrikeUpRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsNotificationStrikeUpReq.create(
        userName: 'ZXLBS5',
        type: 0
      );
      final res = await ref.read(notificationWsProvider).wsNotificationStrikeUp(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(strikeUpProvider.future);
    print('ws strike up test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  /// 需要先搭訕過後取得roomId, 再把roomId帶入 退出群組、拉黑
  test('ws leave group block test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final leaveGroupBlockProvider = FutureProvider<WsNotificationLeaveGroupBlockRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsNotificationLeaveGroupBlockReq.create(
          roomId: 11932
      );
      final res = await ref.read(notificationWsProvider).wsNotificationLeaveGroupBlock(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(leaveGroupBlockProvider.future);
    print('ws leave group block test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws block group test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final blockGroupProvider = FutureProvider<WsNotificationBlockGroupRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsNotificationBlockGroupReq.create(
          page: 1
      );
      final res = await ref.read(notificationWsProvider).wsNotificationBlockGroup(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(blockGroupProvider.future);
    print('ws block group test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws pressBtn and remove black account test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final blockGroupProvider = FutureProvider<WsNotificationPressBtnAndRemoveBlackAccountRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsNotificationPressBtnAndRemoveBlackAccountReq.create(
          friendId: 34
      );
      final res = await ref.read(notificationWsProvider).wsNotificationPressBtnAndRemoveBlackAccount(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(blockGroupProvider.future);
    print('ws pressBtn and remove black account test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_SYSTEM_MAINTENANCE);

    // 清理 container
    container.dispose();
  });
}