import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/detail/ws_detail_search_list_coin_req.dart';
import 'package:frechat/models/ws_req/detail/ws_detail_search_list_income_req.dart';
import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:frechat/models/ws_res/detail/ws_detail_search_list_income_res.dart';
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

  test('ws detail search list coin test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final searchListCoinProvider = FutureProvider<WsDetailSearchListCoinRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsDetailSearchListCoinReq.create(
        startTime: '2023-06-30 14:12:00',
        endTime: '2023-06-30 14:12:00',
      );
      final res = await ref.read(detailWsProvider).wsDetailSearchListCoin(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(searchListCoinProvider.future);
    print('ws detail search list coin test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws detail search list income test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final searchListIncomeProvider = FutureProvider<WsDetailSearchListIncomeRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsDetailSearchListIncomeReq.create(
        startTime: '2023-06-30 14:12:00',
        endTime: '2023-06-30 14:12:00',
      );
      final res = await ref.read(detailWsProvider).wsDetailSearchListIncome(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(searchListIncomeProvider.future);
    print('ws detail search list income test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });
}