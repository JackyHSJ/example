

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_charge_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_shumei_violate_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/call/calling_page.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_authentication_manager/call_authentication_manager.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_manager.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/ws_comm/ws_member.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_effects_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../../models/ws_res/account/ws_account_call_charge_res.dart';

class CallingPageViewModel {
  CallingPageViewModel({
    required this.setState,
    required this.ref,
    required this.channel,
    required this.roomID,
    required this.callData,
    required this.searchListInfo,
    required this.chatRoomViewModel,
    required this.tickerProvider,
    this.token,
    required this.otherUserInfo,
    required this.memberInfoRes,
  }) {
    /// init from ref provider
    isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    accountWs = ref.read(accountWsProvider);
    zimService = ref.read(zimServiceProvider);
    manager = ref.read(zegoSDKManagerProvider);
    expressService = ref.read(expressServiceProvider);
    userUtil = ref.read(userUtilProvider.notifier);
    myGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    callingPage = ref.read(userInfoProvider).currentPage ?? 0;
    memberWs = ref.read(memberWsProvider);
    currentPage = ref.read(userInfoProvider).currentPage ?? 0;
    userInfoModel = ref.read(userInfoProvider);
    callAuthentication = ref.read(callAuthenticationManagerProvider);

    theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
  }

  ViewChange setState;
  WidgetRef ref;
  String channel;
  num roomID;
  ZegoCallData callData;
  SearchListInfo searchListInfo;
  ChatRoomViewModel chatRoomViewModel;
  TickerProvider tickerProvider;
  String? token;
  ZegoUserInfo otherUserInfo;
  WsMemberInfoRes memberInfoRes;

  int rechargeTime = 0; // 充值時間
  bool isRecharged = false; // 是否有充值過
  Timer? rechargeTimer; // 充值 Timer

  static WebSocketUtil? webSocketUtil;

  bool isBeautyOpen = true; // 預設美顏打開
  bool isBeautyEditing = false; // 預設美顏編輯關閉

  bool micIsOn = true;
  bool cameraIsOn = true;
  bool isFacingCamera = true;
  bool isSpeaker = true;
  bool volumeOn = false;
  bool isCameraOpen = true;


  static Timer? callChargeTimer;
  /// 通話計時器
  static Timer? callTimer;
  static num currentCallTimer = 0;

  int coinNotEnoughTime = 0;
  bool isStrikeUpMateMode = false;

  late AccountWs accountWs;
  late ZIMService zimService;
  late ZEGOSDKManager manager;
  late ExpressService expressService;
  late UserNotifier userUtil;
  late num myGender;
  late int callingPage;
  late MemberWs memberWs;
  late num currentPage;
  late UserInfoModel userInfoModel;
  late CallAuthenticationManager callAuthentication;
  late AppTheme theme;

  init(BuildContext context, {
    required ZegoCallUserState zegoCallUserState
  }) async {

    _loadCache();

    chatRoomViewModel.getCohesionPointsRule();

    if(PipUtil.pipStatus != PipStatus.init) { return; }

    AudioPlayerUtils.playerStop();

    /// WS Stream
    /// Shumei審查
    _initListener(context);
    setState((){});

    /// prefs
    /// for cancel call use
    String callJson = jsonEncode({'channel': channel, 'roomId':roomID, 'invitationID': callData.callID, 'invitees':[callData.invitee.userID]});
    await FcPrefs.setCancelCallInfo(callJson);

    userUtil.setDataToPrefs(currentPage: 2);
    userUtil.setDataToPrefs(currentChatUser: memberInfoRes.userName);

    /// 後半部
    _loginRoomInit(context);

    /// 初始化扣費
    _initCallCharge(zegoCallUserState);

    ///開始計時通話時長
    _startCallTimer();
  }

  deactivate() {
    if(PipUtil.pipStatus != PipStatus.init) {
      return ;
    }

    userUtil.setDataToPrefs(currentPage: 0);
    userUtil.setDataToPrefs(currentChatUser: '');
  }

  dispose() {

    ///停止 計時通話時長
    _stopCallTimer();
    ///停止 計時通話費用
    _stopCallChargeTimer();

    ZegoCallStateManager.instance.clearCallData();
    _disposeListener();

    /// 初始化pip status
    PipUtil.pipStatus = PipStatus.init;
  }

  ///結束通話
  Future<void> cancelCall(BuildContext context) async {
    callAuthentication.endCall(
        context,
        callData: callData,
        roomId: roomID,
        channel: channel,
        searchListInfo: searchListInfo,
        onDispose: () => dispose()
    );
  }

  /// 縮小視窗
  enterPiPMode(BuildContext context, {required Widget pipWidget}) {
    PipUtil.enterPiPMode(
        context,
        setState: setState,
        pipWidget: SizedBox(
          width: WidgetValue.smallVideoWidth, height: WidgetValue.smallVideoHeight,
          child: pipWidget,
        ),
        pushPage: CallingPage(
          callData: GlobalData.cacheCallData!,
          otherUserInfo: GlobalData.cacheOtherUserInfo!,
          token: GlobalData.cacheToken!,
          channel: GlobalData.cacheChannel!,
          roomID: GlobalData.cacheRoomID!,
          memberInfoRes: GlobalData.cacheMemberInfoRes!,
          searchListInfo: GlobalData.cacheSearchListInfo!,
        )
    );
  }

  void _loadCache() {
    GlobalData.cacheCallData = callData;
    GlobalData.cacheOtherUserInfo = otherUserInfo;
    GlobalData.cacheToken = token;
    GlobalData.cacheChannel = channel;
    GlobalData.cacheRoomID = roomID;
    GlobalData.cacheMemberInfoRes = memberInfoRes;
    GlobalData.cacheSearchListInfo = searchListInfo;
  }

  void _loginRoomInit(BuildContext context) async {
    try {
      final list = ref.read(userInfoProvider).notificationSearchList?.list;
      final resultList = list?.where((info) => info.userName == searchListInfo.userName).toList();
      chatRoomViewModel.cohesionLevel = resultList?.first.cohesionLevel ?? 0;
    } catch (e) {
      /// 這不能改動，會造成zego login room fail的問題
      chatRoomViewModel.cohesionLevel = 2;
    }

    // final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    // final ExpressService expressService = ref.read(expressServiceProvider);
    if (callData.callType == ZegoCallType.voice) {
      await PermissionUtil.checkAndRequestMicrophonePermission();
      cameraIsOn = false;
      expressService.turnCameraOn(cameraIsOn);
      expressService.useFrontFacingCamera(isFacingCamera);
    } else {
      /// 開啟美顏
      await initBeauty();
    }

    final joinRoomResult = await expressService.loginRoom(channel, token: token ?? '');
    if (joinRoomResult.errorCode == 0) {
      expressService.startPublishingStream(roomId: channel);
      expressService.turnMicrophoneOn(micIsOn);
      expressService.setAudioOutputToSpeaker(isSpeaker);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('join room fail: ${joinRoomResult.errorCode},${joinRoomResult.extendedData}')),
      );
    }
  }

  void _initListener(BuildContext context) {
    if(webSocketUtil != null) {
      return ;
    }
    webSocketUtil = WebSocketUtil();
    webSocketUtil?.onWebSocketListen(
        functionObj: WsParamsReq.accountShumeiViolate,
        onReceiveData: (res) {
          final WsAccountShumeiViolateRes shumeiViolateRes = WsAccountShumeiViolateRes.fromJson(res.resultMap);
          if(shumeiViolateRes.resultCode == ResponseCode.CODE_CONTENT_VIOLATES_REGULATIONS) {
            cancelCall(context);
            BaseViewModel.showToast(context, shumeiViolateRes.resultMsg ?? '');
          }
        });
  }

  void _disposeListener() {
    if(webSocketUtil == null) {
      return ;
    }
    webSocketUtil?.onWebSocketListenDispose();
    webSocketUtil = null;
  }

  ///開始 計時通話時長
  void _startCallTimer() {
    if(callTimer != null){
      return ;
    }
    final UserNotifier userNotifier = ref.read(userUtilProvider.notifier);
    callTimer = TimerUtil.periodic(timerType: TimerType.seconds, timerNum: 1, timerCallback: (time) {
      currentCallTimer++;
      userNotifier.setDataToPrefs(callTimer: currentCallTimer);
    });
  }

  ///停止 計時通話時長
  void _stopCallTimer() {
    if(callTimer == null){
      return ;
    }
    callTimer?.cancel();
    callTimer = null;
    currentCallTimer = 0;
    userUtil.setDataToPrefs(callTimer: currentCallTimer);
  }

  ///初始化扣費
  Future<void> _initCallCharge(ZegoCallUserState zegoCallUserState) async {
    final int callType = _getCallType();
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final bool isFemale = myGender == 0;
    if (isFemale) {
      await Future.delayed(const Duration(seconds: 7));
      //7秒後如果是縮小狀態，進行通話扣款Timer
      if(PipUtil.pipStatus == PipStatus.piping){
        _handleCallCharge(currentContext, callType: callType);
        _startCallChargeTimer();
        return;
      }
      //7秒後如果非縮小狀態，且當前頁面存在，進行通話扣款Timer
      if(ref.context.mounted == true ){
        final UserCallStatus userCallStatus = ref.read(userInfoProvider).userCallStatus ?? UserCallStatus.init;
        if(userCallStatus != UserCallStatus.calling) {return;}
        _handleCallCharge(currentContext, callType: callType);
        _startCallChargeTimer();
      }
    }
    /// 男用戶
    if(isFemale == false) {
      /// 接聽電話移除男生接起電話第一次打扣費的邏輯
      if(zegoCallUserState == ZegoCallUserState.inviting) {
        _handleCallCharge(currentContext, callType: callType);
      }

      /// 直接開啟Timer
      _startCallChargeTimer();
    }
  }

  ///開始 計時通話費用 /// 改為1分02秒
  void _startCallChargeTimer() async{
    callChargeTimer = Timer.periodic(const Duration(seconds: 62), (timer) {
      final currentContext = BaseViewModel.getGlobalContext();
      _handleCallCharge(currentContext, callType: _getCallType());
    });
  }

  ///停止 計時通話費用
  void _stopCallChargeTimer() {
    if(callChargeTimer != null){
      callChargeTimer?.cancel();
      callChargeTimer = null;
    }
  }

  /// 通話費用扣款
  void _handleCallCharge(BuildContext context, {required int callType}) {
    _wsAccountCallCharge(context,
      channel: channel,
      roomID: roomID,
      chatType: callType,
      callData: callData,
    );
  }

  int _getCallType() {
    final ZegoCallType zegoCallType = ZegoCallStateManager.instance.callData?.callType ?? ZegoCallType.voice;
    if(isStrikeUpMateMode) {
      return (zegoCallType == ZegoCallType.voice) ? 7 : 8;
    } else {
      return (zegoCallType == ZegoCallType.voice) ? 1 : 2;
    }
  }

  Future<void> _permissionRequest() async {
    await PermissionUtil.checkAndRequestCameraPermission();
    await PermissionUtil.checkAndRequestMicrophonePermission();
  }

  /// 通話消費(3-95)
  Future<void> _wsAccountCallCharge(BuildContext context, {
    required String channel,
    required num roomID,
    required num chatType,
    // Function(String)? onConnectSuccess,
    // Function(String)? onConnectFail,
    required ZegoCallData callData
  }) async {
    String? resultCodeCheck;
    final reqBody = WsAccountCallChargeReq.create(chatType: chatType, channel: channel, roomId: roomID);
    WsAccountCallChargeRes res = await accountWs.wsAccountCallCharge(reqBody,
      onConnectSuccess: (succMsg) {
        resultCodeCheck = succMsg;
      }, onConnectFail: (errMsg) {
        resultCodeCheck = errMsg;
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    );



    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final num personalGender = userInfoModel.memberInfo?.gender ?? 0; // 個人性別

      // 男方可見
      final num remainCoins = res.remainCoins ?? 0; // 自己剩餘的金幣（已預扣）
      final num cost = res.cost ?? 0; // 對方的收費
      final num remainTimes = res.remainTimes ?? 0; // 剩餘的免費通話 "分鐘 or 次數"

      // 如果 remainTimes > 0 則不需要判斷
      // 男方才要判斷
      // 判斷每次回傳的 cost 跟 remainCoins，
      // remainCoins - cost < 0 代表剩餘金額不足扣下一分鐘，等待 30 秒後就會跳充值彈窗
      if (remainTimes <= 0) {
        if (personalGender == 1 && remainCoins - cost < 0) {
          await Future.delayed(const Duration(seconds: 30));
          // 如果已經有跳過充值彈窗就不要在跳了
          BaseViewModel.showRechargeBottomSheet(theme: theme, userInfoModel: userInfoModel);
        }
      }
    }

    /// TODO: 應該有更好作法
    /// Zego 推拉流與斷流, 操作太快造成對方手機Zego未進入CallBack
    /// 延遲跳出彈窗以避免充值彈窗直接被關閉
    // 如果餘額不足就會直接掛電話
    if (resultCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH || resultCodeCheck == ResponseCode.CODE_CALL_HAS_ENDED || resultCodeCheck == ResponseCode.CODE_CALL_NOT_CHARGED) {
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) await cancelCall(context);
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);

      /// 女生則不跳出充值彈窗
      if(myGender == 0 || resultCodeCheck == ResponseCode.CODE_CALL_HAS_ENDED) {
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
      BaseViewModel.showRechargeBottomSheet(theme: theme, userInfoModel: userInfoModel);
    }
  }

  /// ----- 美顏  -----

  initBeauty() async {
    await _permissionRequest();
    // final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    // final ExpressService expressService = ref.read(expressServiceProvider);
    await manager.initZegoEffect();
    expressService.turnCameraOn(true);
    await expressService.startPreview();
    manager.loadDbDateToCurrentValue();
  }

  setBeautyParams(){
    if (isBeautyOpen) {
      // final manager = ref.read(zegoSDKManagerProvider);
      manager.loadDbDateToCurrentValue();
    } else {
      ZegoBeautyType.values.forEach((type) {
        final ZegoBeautyAbility? ability = getAbility(type);
        ability?.editor.enable(true);
        ability?.editor.apply(0);
        ability?.currentValue = 0;
      });
    }
    setState((){});
  }

  /// 打開美顏
  openBeauty(BuildContext context) async {
    // await FcPrefs.setBeautyStatus(true);
    isBeautyOpen = true;
    setBeautyParams();
    // returnToOriginalSetting();
    if(context.mounted) {
      // BaseViewModel.popPage(context);
      // BaseViewModel.popPage(context);
    }
    BaseViewModel.showToast(context, '已开启美颜功能');
    setState((){});
  }

  /// 關閉美顏
  closeBeauty(BuildContext context) async {
    isBeautyOpen = false;
    setBeautyParams();
    // FcPrefs.setBeautyStatus(false);
    // disableBeauty();
    // BaseViewModel.popPage(context);
    BaseViewModel.popPage(context);
    BaseViewModel.showToast(context, '已关闭美颜功能');
    setState((){});
  }

  ZegoBeautyAbility? getAbility (ZegoBeautyType? type) {
    final ZegoBeautyAbility? ability = ZegoEffectsService.instance.beautyAbilities[type];
    return ability;
  }

  /// ----- 充值 -----

  /// 充值時間
  void startRechargeTime(BuildContext context) {

    rechargeTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if(isRecharged) {
        rechargeTimer?.cancel();
        rechargeTime = 0;
        return;
      }

      if (rechargeTime >= 30) {
        rechargeTimer?.cancel();
        cancelCall(context);
        rechargeTime = 0;
        return;
      }
      rechargeTime++;
    });
  }

  /// 判斷是否要跳充值彈窗
  void rechargeDialogHandler(String oppositeUserName, num type, num remainCoins, BuildContext context) async {

    final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
    final num rechargeCounts = ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0; // 充值次數
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    // 男性
    if (personalGender == 1) {
      await Future.delayed(const Duration(seconds: 30));
      if (rechargeCounts == 0) {
        RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
      } else {
        RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
      }
    }
  }
}