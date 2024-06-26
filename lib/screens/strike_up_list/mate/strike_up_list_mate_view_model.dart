

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_verification_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_quick_match_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_verification_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class StrikeUpListMateViewModel {
  StrikeUpListMateViewModel({
    required this.ref, this.setState, this.tickerProvider,
    required this.callType,
  });
  WidgetRef ref;
  ViewChange? setState;
  TickerProvider? tickerProvider;
  ZegoCallType callType;

  AnimationController? dialogAnimationController;

  AnimationController? animationController1;
  Animation<double>? animation1;
  AnimationController? animationController2;
  Animation<double>? animation2;
  AnimationController? animationController3;
  Animation<double>? animation3;

  static late StreamController<MateState> stateController;
  static late StreamSubscription streamSubscription;
  Timer? dialogTimer;

  List<String> mateList = [];
  int mateListIndex = 0;
  final num maxCountDownTime = 10;
  num currentCountDownTime = 10;
  
  Timer? _delayTimer;

  Function(WsMemberInfoRes)? onShowMateDialog;
  Function()? onShowErrorMateDialog;

  init(BuildContext context, {
    required Function(WsMemberInfoRes) onShowMateDialog,
    required Function() onShowErrorMateDialog
  }) async {
    this.onShowMateDialog = onShowMateDialog;
    this.onShowErrorMateDialog = onShowErrorMateDialog;

    /// 頭像旋轉
    animationStart();
    stateController = StreamController.broadcast();
    initMate(context);
  }

  dispose() {
    streamSubscription.cancel();
    disposeDialogTimer();
    disposeDelayTimer();
    animationStop();
  }

  initMate(BuildContext context) async {
    mateListIndex = 0;

    /// 取得速配列表
    await _loadMateList(context, page: 1);
    /// 速配狀態監聽
    streamSubscription = stateController.stream.listen((state) async {
      disposeDialogTimer();
      if(state == MateState.close) {
        WsMemberInfoRes? mateMemberInfoRes;
        while(mateListIndex < mateList.length) {
          final mateId = mateList[mateListIndex];
          /// 加入memberInfo 2-2 連續發送延遲時間, 目的減少Server負擔
          final Duration delayTimeDuration = _getMemberInfoDaleyTime();
          await Future.delayed(delayTimeDuration);

          mateMemberInfoRes = await _loadMateMemberInfo(context, id: mateId);
          /// 檢查是否為黑名單
          final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
          final bool isBlockUser = blockList.any((blockInfo) => blockInfo.userName == mateMemberInfoRes?.userName);

          /// 檢查是否真人認證過
          final realPersonAuth = CertificationModel.getType(authNum: mateMemberInfoRes?.realPersonAuth ?? 0);
          final isPassAuthList = _checkAuthAndGender(realPersonAuth, mateMemberInfoRes?.isOnline, mateMemberInfoRes?.gender);

          /// 檢查是否被凍結: 封号状态(0:无,1:短期,2:永久)
          final num lockStatus = mateMemberInfoRes?.lockStatus ?? 0;
          final bool isLock = lockStatus != 0;

          /// 是否線上
          final bool isOnline = mateMemberInfoRes?.isOnline == 1;

          /// 是否為好友, 已經是好友則濾掉
          final List<ChatUserModel> chatUserModelList = ref.read(chatUserModelNotifierProvider);
          final bool isFriend = chatUserModelList.any((model) => model.userName == mateMemberInfoRes?.userName);

          /// 真人認證條件通過、非封鎖用戶
          if(isPassAuthList && isBlockUser == false && isLock == false && isOnline && isFriend == false) {
            break;
          } else {
            /// 如果不是，則mateListIndex++
            mateListIndex++;
          }
        }
        /// mateList 中的元素都不滿足 realPersonAuth == CertificationType.done 的情况
        /// 重新加載更多配對清單mateList
        if(mateListIndex >= mateList.length) {
          print("加載更多配對清單 mateList");
        }

        if(mateMemberInfoRes == null) {
          onShowErrorMateDialog?.call();
          return ;
        }

        /// 速配彈窗
        onShowMateDialog?.call(mateMemberInfoRes);
        mateListIndex++;
      }
    }, onDone: () => print('onDone'), onError: (errMsg) => print('onError: $errMsg'));
    /// 初始化 進入頁面首次彈窗
    stateController.sink.add(MateState.close);
  }

  Duration _getMemberInfoDaleyTime() {
    final bool isDevEnv = AppConfig.env == AppEnvType.Dev;
    if(isDevEnv) {
      return const Duration(milliseconds: 0);
    }
    return const Duration(seconds: 3);
  }

  /// 如果 realPersonAuth 是 CertificationType.done 呼叫 break跳出循環
  /// 男生用戶則不需真人認證 僅需判斷是否上線中
  /// 符合速配條件
  bool _checkAuthAndGender(CertificationType realPersonAuth, num? isOnline, num? gender) {
    final bool result = (realPersonAuth == CertificationType.done && isOnline == 1) || (gender == 1 && isOnline == 1);
    return result;
  }

  initDialogTimer(BuildContext context, {required ViewChange setState, Function()? onTimeOut}) {
    dialogTimer = TimerUtil.periodic(timerType: TimerType.seconds, timerNum: 1, timerCallback: (time){
      currentCountDownTime--;
      if(currentCountDownTime == 0) {
        currentCountDownTime = 10;
        disposeDialogTimer();
        onTimeOut?.call();
      }
      if(context.mounted) {
        setState((){});
      }
    });
  }

  disposeDialogTimer() {
    if(dialogTimer != null) {
      dialogTimer!.cancel();
      dialogTimer = null;
    }
  }

  disposeDelayTimer() {
    if(_delayTimer != null) {
      _delayTimer!.cancel();
      _delayTimer = null;
    }
  }

  Future<void> _loadMateList(BuildContext context, {required num page}) async {
    String? resultCodeCheck;
    final String type = callType == ZegoCallType.voice ? '1' : '2';
    final WsAccountQuickMatchListReq reqBody = WsAccountQuickMatchListReq.create(
        type: type,
        page: page
    );
    stateController.sink.add(MateState.loading);
    final res = await ref.read(accountWsProvider).wsAccountQuickMatchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final String list = res.matchIdList ?? '';
      mateList = list.split(',');
    }
  }

  Future<WsMemberInfoRes?> _loadMateMemberInfo(BuildContext context, {required String id}) async {
    String? resultCodeCheck;
    final num? mateId = num.tryParse(id);
    final WsMemberInfoReq reqBody = WsMemberInfoReq.create(id: mateId);
    final res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => print('error: ${ResponseCode.map[errMsg]}')
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res;
    }
    return null;
  }

  ///動畫開始
  animationStart() {
    animationController1 = _buildAnimationController(5);
    animation1 = _buildAnimation(begin: 0, end: 2, animationController: animationController1!);
    animationController2 = _buildAnimationController(3);
    animation2 = _buildAnimation(begin: 0, end: 2, animationController: animationController2!);
    animationController3 = _buildAnimationController(2);
    animation3 = _buildAnimation(begin: 0, end: 2, animationController: animationController3!);
  }

  ///動畫停止
  animationStop() {
    animationController1?.dispose();
    animationController2?.dispose();
    animationController3?.dispose();
  }

  ///動畫控制
  _buildAnimationController(int sec) {
    final animationController = AnimationController(
      vsync: tickerProvider!,
      duration: Duration(seconds: sec),
    )..repeat();
    return animationController;
  }

  ///動畫
  Animation<double>? _buildAnimation({
    required double begin, required double end,
    required AnimationController animationController
  }) {
    final tween = Tween<double>(begin: begin, end: end * math.pi).animate(animationController);
    return tween;
  }

  nextOneMate(BuildContext context) {
    BaseViewModel.popPage(context);
    /// 延遲3秒後 彈窗
    const duration = Duration(seconds: 10);
    _delayTimer = Timer(duration, () {
      /// MateState.close 後會彈窗
      stateController.sink.add(MateState.close);

      disposeDelayTimer();
    });
  }

  Future<void> loadPropertyInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }

  Future<SearchListInfo?> getMateSearchListInfo(BuildContext context, {required num roomId}) async {
    String resultCodeCheck = '';
    final WsNotificationSearchListReq reqBody = WsNotificationSearchListReq.create(page: '1', roomId: roomId);
    final res = await ref.read(notificationWsProvider).wsNotificationSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res.list?.first;
    } else if (resultCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
      if (context.mounted) {
        rechargeHandler();
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
      return null;
    }
    if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    return null;
  }

  // 4-2 搭訕
  Future<WsNotificationStrikeUpRes?> strikeUp(BuildContext context, {required String userName}) async {
    String resultCodeCheck = '';
    final WsNotificationStrikeUpReq reqBody = WsNotificationStrikeUpReq.create(userName: userName, type: 1);
    final WsNotificationStrikeUpRes res = await ref.read(notificationWsProvider).wsNotificationStrikeUp(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res;
    } else if (resultCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
      if (context.mounted) {
        rechargeHandler();
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
      return null;
    }
    if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    return null;
  }

  Future<WsAccountCallVerificationRes?> callVerification(BuildContext context, {
    required num freUserId, required num roomId,
    required String timeoutText
  }) async {
    String resultCodeCheck = '';
    final num type = (callType == ZegoCallType.voice) ? 7 : 8;
    final WsAccountCallVerificationReq reqBody = WsAccountCallVerificationReq.create(
      chatType: type, freUserId: freUserId, roomId: roomId
    );
    final WsAccountCallVerificationRes res = await ref.read(accountWsProvider).wsAccountCallVerification(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res;
    }

    if(resultCodeCheck == ResponseCode.CODE_CALL_IS_BLACK_LISTED_ERROR) {
      sendEmptyCall(context, timeoutText);
      return null;
    }

    if (resultCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
      if (context.mounted) {
        rechargeHandler();
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
      return null;
    }

    if (resultCodeCheck == ResponseCode.CODE_CALL_CHANNEL_ERROR
        || resultCodeCheck == ResponseCode.CODE_CALL_IS_BLACK_LISTED_ERROR
        || resultCodeCheck == ResponseCode.CODE_MEMBER_BUSY
    ) {
      return null;
    }

    return null;
  }

  //結束通話(3-97)
  Future<WsAccountEndCallRes> wsAccountEndCall(BuildContext context, String channel, num roomID) async {
    final reqBody = WsAccountEndCallReq.create(channel: channel, roomId: roomID,);
    final commToken = await FcPrefs.getCommToken();
    String? resultCodeCheck;
    final WsBaseReq msg = WsParamsReq.accountEndCall
      ..tId = commToken
      ..msg = reqBody;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg, funcCode: WsParamsReq.accountEndCall.f,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    return (res.resultMap == null) ? WsAccountEndCallRes() : WsAccountEndCallRes.fromJson(res.resultMap);
  }

  void rechargeHandler() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

  void sendEmptyCall(BuildContext context, String text) {
    BaseViewModel.popPage(context);
    BaseViewModel.showToast(context, text);
    StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
  }
}