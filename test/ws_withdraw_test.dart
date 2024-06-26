import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_money_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_search_record_req.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_money_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_record_res.dart';
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

  test('ws withdraw money test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final withdrawMoneyProvider = FutureProvider<WsWithdrawMoneyRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsWithdrawMoneyReq.create(
          type: 2,
          amount: 800
      );
      final res = await ref.read(withdrawWsProvider).wsWithdrawMoney(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(withdrawMoneyProvider.future);
    print('ws withdraw money test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_ACCOUNT_NOT_FOUND);

    // 清理 container
    container.dispose();
  });

  test('ws withdraw search record test', () async { //
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final searchWithdrawRecordProvider = FutureProvider<WsWithdrawSearchRecordRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsWithdrawSearchRecordReq.create(
        startTime: '2023-07-01 00:00:0',
        endTime: '2023-07-31 23:59:59'
      );
      final res = await ref.read(withdrawWsProvider).wsWithdrawSearchRecord(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(searchWithdrawRecordProvider.future);
    print('ws withdraw search record test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });
}