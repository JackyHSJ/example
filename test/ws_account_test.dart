import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_charge_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_verification_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtc_token_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_remark_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_speak_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_charge_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_verification_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_remark_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_speak_res.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FcPrefs.mockInitial();
  String resultCodeCheck = '';
  String errorMsgCheck = '';

  _initWs() async {
    /// websocket connect & open listener
    // await ref.read(webSocketUtilProvider).connectWebSocket(
    //   onConnectSuccess: (succMsg) => onConnectSuccess(succMsg),
    //   onConnectFail: (errMsg) => onConnectFail(errMsg),
    // );
    // await ref.read(webSocketUtilProvider).onWebSocketListen();
  }

  test('ws handshake', () async {
    _initWs();
  });

  test('ws speak test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final speakProvider = FutureProvider<WsAccountSpeakRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountSpeakReq.create(
          roomId: 9876,
          userId: 1234,
          contentType: 0,
          chatContent: "你要說的是什麼",
          uuId: "fui29dje8fisjd0sa",
          flag: "0",
          replyUuid: '',
          giftId: '',
          giftAmount: '',
          isReplyPickup: 0,
      );
      final res = await ref.read(accountWsProvider).wsAccountSpeak(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(speakProvider.future);
    print('ws speak test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_NOT_A_ROOM_USER);

    // 清理 container
    container.dispose();
  });

  test('ws call charge test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final callChargeProvider =
        FutureProvider<WsAccountCallChargeRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountCallChargeReq.create(
          chatType: 1, channel: 'F01FKC_ZXLBS5_1688543696271', roomId: 11930);
      final res = await ref.read(accountWsProvider).wsAccountCallCharge(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(callChargeProvider.future);
    print('ws call charge test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws call verify test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final callVerificationProvider =
        FutureProvider<WsAccountCallVerificationRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountCallVerificationReq.create(
          freUserId: 30, chatType: 1, roomId: 11930);
      final res = await ref.read(accountWsProvider).wsAccountCallVerification(
          reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(callVerificationProvider.future);
    print('ws call charge test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_NOT_A_ROOM_USER);

    // 清理 container
    container.dispose();
  });

  test('ws end call test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final endCallProvider = FutureProvider<WsAccountEndCallRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountEndCallReq.create(
          channel: 'F01FKC_ZXLBS5_1688545961810', roomId: 11930);
      final res = await ref.read(accountWsProvider).wsAccountEndCall(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(endCallProvider.future);
    print('ws end call test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_NOT_A_ROOM_USER);

    // 清理 container
    container.dispose();
  });

  test('ws getRTMToken test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final getRTMTokenProvider =
        FutureProvider<WsAccountGetRTMTokenRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountGetRTMTokenReq.create();
      final res = await ref.read(accountWsProvider).wsAccountGetRTMToken(
          reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(getRTMTokenProvider.future);
    print('ws getRTMToken test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws getRTCToken test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final getRTCTokenProvider =
        FutureProvider<WsAccountGetRTCTokenRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountGetRTCTokenReq.create(
        chatType: 1,
        roomId: 30,
        callUserId: 17,
      );
      final res = await ref.read(accountWsProvider).wsAccountGetRTCToken(
          reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(getRTCTokenProvider.future);
    print('ws getRTCToken test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws remark test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final remarkProvider = FutureProvider<WsAccountRemarkRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountRemarkReq.create(remark: "有趣的人", friendId: 16);
      final res = await ref.read(accountWsProvider).wsAccountRemark(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(remarkProvider.future);
    print('ws remark test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(errorMsgCheck, ResponseCode.CODE_SYSTEM_MAINTENANCE);

    // 清理 container
    container.dispose();
  });

  test('ws follow test', () async {
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final fallowProvider = FutureProvider<WsAccountFollowRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountFollowReq.create(isFollow: true, friendId: 16);
      final res = await ref.read(accountWsProvider).wsAccountFollow(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(fallowProvider.future);
    print('ws follow test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });

  test('ws follow and fans list test', () async {
    //
    await _initWs();
    // 建立一個 ProviderContainer
    final container = ProviderContainer();
    final followAndFansListProvider =
        FutureProvider<WsAccountFollowAndFansListRes>((ref) async {
      /// ---參考以下---
      final reqBody = WsAccountFollowAndFansListReq.create(type: 1);
      final res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(
          reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);

      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(followAndFansListProvider.future);
    print('ws follow and fans list test: ${result.toJson()}');
    // 驗證結果
    print('驗證結果: $resultCodeCheck');
    print('驗證結果 Error: $errorMsgCheck');
    expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);

    // 清理 container
    container.dispose();
  });
}
