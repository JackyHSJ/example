import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/report/ws_report_search_type_req.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
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

  test('ws report search type test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final speakProvider = FutureProvider<WsReportSearchTypeRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsReportSearchTypeReq.create(
          type: '0'
      );
      final res = await ref.read(reportWsProvider).wsReportSearchType(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(speakProvider.future);
    print('ws report search type test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });
}