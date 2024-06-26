import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_money_req.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_money_res.dart';
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

  test('ws deposit money test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final depositMoneyProvider = FutureProvider<WsDepositMoneyRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsDepositMoneyReq.create(
        type: 2,
        amount: 800
      );
      final res = await ref.read(depositWsProvider).wsDepositMoney(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(depositMoneyProvider.future);
    print('ws deposit money test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_ACCOUNT_NOT_FOUND);

    // 清理 container
    container.dispose();
  });
}