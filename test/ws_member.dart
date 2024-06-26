import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/member/ws_member_apply_cancel_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_fate_online_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_fate_recommend_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_apply_cancel_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_online_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
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

  test('ws member info test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final memberInfoProvider = FutureProvider<WsMemberInfoRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsMemberInfoReq.create();
      final res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(memberInfoProvider.future);
    print('ws member info test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws member apply cancel test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final applyCancelProvider = FutureProvider<WsMemberApplyCancelRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsMemberApplyCancelReq.create();
      final res = await ref.read(memberWsProvider).wsMemberApplyCancel(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(applyCancelProvider.future);
    print('ws member apply cancel test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws member fate recommend test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final fateRecommendProvider = FutureProvider<WsMemberFateRecommendRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsMemberFateRecommendReq.create();
      final res = await ref.read(memberWsProvider).wsMemberFateRecommend(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(fateRecommendProvider.future);
    print('ws member fate recommend test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws member fate online test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final fateOnlineProvider = FutureProvider<WsMemberFateOnlineRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsMemberFateOnlineReq.create();
      final res = await ref.read(memberWsProvider).wsMemberFateOnline(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(fateOnlineProvider.future);
    print('ws member fate online test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });
}