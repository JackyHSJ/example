import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_charge_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtc_token_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/color_box.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frechat/widgets/shared/dialog/calling_recharge_dialog.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/calling_recharge_sheet.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../screens/user_info_view/user_info_view.dart';

class ReceiverAlertDialog extends ConsumerStatefulWidget {
  final WsMemberInfoRes wsMemberInfoRes;
  final num chatType;
  final String channel;
  final num roomID;
  final num callUserId;
  final bool isStrikeUpMateMode;
  final ZegoCallData invitationData;
  final Function? onRejectCallback;
  final Function(WsAccountGetRTCTokenRes)? onAcceptCallback;

  ReceiverAlertDialog({Key? key, required this.wsMemberInfoRes, required this.chatType, required this.channel,
    required this.roomID,this.onRejectCallback, this.onAcceptCallback, required this.invitationData, required this.callUserId, required this.isStrikeUpMateMode}) : super(key: key);

  @override
  ConsumerState<ReceiverAlertDialog> createState() => _ReceiverAlertDialogState();
}

class _ReceiverAlertDialogState extends ConsumerState<ReceiverAlertDialog> {
  bool isStrikeUpMateMode = false;
  num? gender;
  List<String>? cost;
  WsMemberPointCoinRes? wsMemberPointCoinRes;
  String startCallContent = '立即聊天';
  int countdown = 10;
  ChatUserModel? chatUserModel;
  String callCost = '';
  bool isPermission = false;
  String permissionMsg = '';
  num cohesionPoint = 0;
  WsSettingCharmAchievementRes? charmAchievement;

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppImageTheme _appImageTheme;


  @override
  void initState() {
    super.initState();
    getIsStrikeUpMateMode();
    permission();
    AudioPlayerUtils.playAssetAudio('aac/phone_call_notification.aac',true);
  }


  Future<void> permission() async {
    isPermission = await _checkPermission();//檢查mic權限
  }


  @override
  void dispose() {
    super.dispose();
    // AudioPlayerUtils.playerDispose();

  }

  // 查詢消息清單(取得亲密度) API 4-1
  Future<void> getSearchListInfoByRoomID(num roomID) async {
    String resultCodeCheck = '';
    final WsNotificationSearchListReq req = WsNotificationSearchListReq.create(page: '1', roomId: roomID, type: 0);
    final WsNotificationSearchListRes res = await ref.read(notificationWsProvider).wsNotificationSearchList(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (res.list!.isNotEmpty) {
        cohesionPoint = res.list?.first.points ?? 0;
        setState(() {});
      }
    }
  }

  // 判斷是否在 7 天內
  bool isWithin7Days(int regTime) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(regTime);
    DateTime dateTime2 = DateTime.now();

    Duration difference = dateTime1.difference(dateTime2);
    return difference.inDays.abs() < 7;
  }


  // 判斷是否要跳充值彈窗
  Future<bool> rechargeDialogHandler(String oppositeUserName, ZegoCallType type) async {
    final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
    final num personalCoin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0; // 個人金幣
    final num rechargeCounts = ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0; // 充值次數
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    if (personalGender == 1) {
      final reqBody = WsMemberInfoReq.create(userName: oppositeUserName);

      // 取得對方的資料，收費設置
      WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
          onConnectSuccess: (succMsg) {},
          onConnectFail: (errMsg) {}
      );

      // List costs = (res.charmCharge ?? '').split('|'); // 女性收費標準
      // int oppositeCost = 0; // 對方花費



      // if (type == ZegoCallType.video) {
      //   oppositeCost = int.parse(costs[2]); // 對方視頻收費
      // } else if (type == ZegoCallType.voice) {
      //   oppositeCost = int.parse(costs[1]); // 對方語音收費
      // }

      final int regTime = ref.read(userInfoProvider).memberInfo?.regTime; // 註冊時間

      bool isNewMember = isWithin7Days(regTime); // 註冊時間有沒有小於 7 天內

      if (personalCoin < int.parse(callCost)) {
        if (isNewMember && type == ZegoCallType.video) return true; // 新用戶 && type 是 video 可以先繞過檢查

        if (rechargeCounts == 0) {
          RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
        } else {
          RechargeUtil.showRechargeBottomSheet(theme: theme);
        }

        return false;
      }

      return true;
    }

    return true; // 女性
  }

  Future<WsAccountGetRTCTokenRes> _buildRtcToken({
    required num callUserId, required num roomID
  }) async {
    int type = 1;
    if (ZegoCallStateManager.instance.callData!.callType == ZegoCallType.video) {
      type = 2;
    }
    final reqBody = WsAccountGetRTCTokenReq.create(
      chatType: type,
      roomId: roomID,
      callUserId: callUserId,
    );
    final WsAccountGetRTCTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTCToken(
        reqBody,
        onConnectSuccess: (succMsg) {},
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    return res;
  }

  Future<void> getIsStrikeUpMateMode() async {
    await getSearchListInfoByRoomID(widget.roomID);

    isStrikeUpMateMode = widget.isStrikeUpMateMode;
    if(isStrikeUpMateMode){
      startCountdown();
    }
    wsMemberPointCoinRes = ref.read(userInfoProvider).memberPointCoin;
    gender = widget.wsMemberInfoRes.gender;

    // 信息｜語音｜視頻
    cost = (widget.wsMemberInfoRes.charmCharge ?? '').split('|');

    WsSettingChargeAchievementReq wsSettingChargeAchievementReq = WsSettingChargeAchievementReq.create();
    charmAchievement = await ref.read(settingWsProvider).wsSettingCharmAchievement(wsSettingChargeAchievementReq,
        onConnectSuccess: (succMsg) => {},
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    final List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement!.list;
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    final List<String> newUserProtect = (intimacyLevelInfo.newUserProtect ?? '').split('|');

    // 後台受保護的親密點數、魅力等級、開關
    num protectIntimacyPoints = double.parse(newUserProtect[0]) ?? 0;
    String protectCharmLevel = newUserProtect[1];
    String protectEnable = newUserProtect[2];

    // 收費價格
    CharmAchievementInfo? charmAchievementInfoVoice;
    CharmAchievementInfo? charmAchievementInfoVideo;

    // 速配模式 || 親密度小於後台親密度設定
    if (isStrikeUpMateMode || (cohesionPoint < protectIntimacyPoints)) {
      // 顯示後台設定的魅力等級扣費標準
      charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
      charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
      if (protectEnable == '0') {
        // 顯示女性用戶設定扣費
        charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == cost![1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
        charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == cost![2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
      }
    } else {
      // 顯示女性用戶設定扣費
      charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == cost![1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
      charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == cost![2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
    }


    if(widget.chatType == 0){
      callCost = charmAchievementInfoVoice!.voiceCharge!;
    }else{
      callCost = charmAchievementInfoVideo!.streamCharge!;
    }

    final List<ChatUserModel> allList = ref.read(chatUserModelNotifierProvider);

    try{
      chatUserModel = allList.firstWhere((info) => info.userName == widget.wsMemberInfoRes.userName);
    } catch (e) {
      chatUserModel = await ref.read(authenticationProvider).loadChatUserModelFailAndAppendToDB(roomId: widget.roomID);
    }
    setState(() {});
  }

  void startCountdown() {
    startCallContent = '立即速配${countdown}s';
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        countdown--;
        if (countdown > 0) {
          startCountdown(); // 继续倒数
        }else{
          ///如果速配需要时间结束时还未接，在这里写方法
        }
      });
    });
  }

  //檢查麥克風、鏡頭使用權限（語音通話只需要mic，視訊通話需要mic camera）
  Future<bool> _checkPermission() async {
    bool isMicPermission = await PermissionUtil.checkAndRequestMicrophonePermission();
    if(isMicPermission){
      if(widget.chatType == 1){
        bool isCamPermission = await PermissionUtil.checkAndRequestCameraPermission();
        permissionMsg = '您尚未开启『相机权限』，因此无法开始通话';
        return isCamPermission;
      }
      return true;
    }else{
      permissionMsg = '您尚未开启『麦克风权限』，因此无法开始通话';
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildContent(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
  /// 標題
  Widget _buildTitle() {
    final String displayTitle = (isStrikeUpMateMode)
        ? '速配来电中'
        : (widget.chatType == 0)
        ? '语音来电中'
        : '视频来电中';

    return Text(
      displayTitle,
      style:_appTextTheme.appbarTextStyle,
      textAlign: TextAlign.center,
    );
  }

  /// 內容
  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(),
          _buildGenderAndAge(),
          _buildNickName(),
          _buildInfoTagList(),
          _buildCallDetailsLabel(),
          _buildChargeItemList(),
          // _buildFreeCallingHint(),
        ],
      ),
    );
  }

  /// 內容 - 頭像
  Widget _buildAvatar() {
    final String avatarPath = widget.wsMemberInfoRes.avatarPath ?? '';
    final String avatar = HttpSetting.baseImagePath + avatarPath;
    final num gender = widget.wsMemberInfoRes.gender ?? 0;
    return Padding(
        padding:EdgeInsets.symmetric(vertical: 12.h),
        child: (avatarPath != '')
            ? AvatarUtil.userAvatar(avatar, size: 64.w)
            : AvatarUtil.defaultAvatar(gender, size: 64.w)
    );
  }

  /// 內容 - 性別
  Widget _buildGenderAndAge() {
    final num gender =  widget.wsMemberInfoRes.gender ?? 0;
    final num age =  widget.wsMemberInfoRes.age ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTag.genderAge(gender: gender, age: age),
      ],
    );
  }

  /// 內容 - 暱稱
  Widget _buildNickName(){
    SearchListInfo? updateSearchListInfo = chatUserModel?.toSearchListInfo();
    final String userName = widget.wsMemberInfoRes.userName ?? '';
    final String nickName = widget.wsMemberInfoRes.nickName ?? userName;
    final String remarkName = updateSearchListInfo?.remark ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, remarkName);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: UIDefine.getWidth(),
      child: MainGradient(linearGradient: _appLinearGradientTheme.vipTextColor).text(title: displayName, fontSize: 20, fontWeight: FontWeight.w600, textAlign: TextAlign.center),
    );
  }

  /// 內容 - 標籤列表（地點/身高/體重）
  Widget _buildInfoTagList(){
    final num height = widget.wsMemberInfoRes.height ?? 0;
    final num weight = widget.wsMemberInfoRes.weight ?? 0;
    final String location = widget.wsMemberInfoRes.location ?? '';
    final String hometown = widget.wsMemberInfoRes.hometown ?? '';
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(visible: hometown != '', child: _buildInfoTag(hometown)),
          Visibility(visible: height != 0, child: _buildInfoTag('${height}cm')),
          Visibility(visible: weight != 0, child: _buildInfoTag('${weight}kg'))
        ],
      ),
    );
  }

  /// 內容 - 標籤列表 -標籤
  Widget _buildInfoTag(dynamic txt) {
    return Row(
      children: [
        ColorBox(
          height: 16,
          radius: 3,
          text: Text('$txt', style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center),
          linearGradient: const LinearGradient(
            colors: [Color.fromRGBO(0, 0, 0, 0.5), Color.fromRGBO(0, 0, 0, 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  /// 內容 - 來電詳情
  Widget _buildCallDetailsLabel(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(isStrikeUpMateMode!
                ? '想要与您速配，快接听把握缘分吧'
                : (widget.chatType == 0)
                    ? '语音来电中... 快接听把握缘分吧'
                    : '视频来电中... 快接听把握缘分吧',
            textAlign: TextAlign.center,
            style: _appTextTheme.dialogContentTextStyle));
  }

  /// 內容 - 收費資訊
  Widget _buildChargeItemList(){
    final num gender = widget.wsMemberInfoRes.gender ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Visibility(
          visible: gender == 0,
          child: _buildBalanceItem(),
        ),
        Visibility(
          visible: gender == 0,
          child: _buildRateItem(),
        ),
      ],
    );
  }

  /// 內容 - 收費資訊 - 餘額
  Widget _buildBalanceItem() {
    final num balance = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0;
    return Container(
      height: 44,
      width: 148,
      decoration: _appBoxDecorationTheme.receiverDialogContentBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('您的馀额', style: _appTextTheme.strikeUpMateDialogChargeTextStyle,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 16.w),
              Text('${balance.toInt()}', style: _appTextTheme.strikeUpMateDialogChargeTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  /// 內容 - 收費資訊 - 通話費率
  Widget _buildRateItem() {
    final List<String>? part = widget.wsMemberInfoRes.charmCharge?.split('|');

    return Container(
      height: 44,
      width: 148,
      decoration: _appBoxDecorationTheme.receiverDialogContentBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('通话费率', style: _appTextTheme.strikeUpMateDialogChargeTextStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 16.w),
              Text('$callCost / 分钟', style: _appTextTheme.strikeUpMateDialogChargeTextStyle,),
            ],
          ),
        ],
      ),
    );
  }

  /// 底部按鈕
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildLeftBtn()),
        SizedBox(width: WidgetValue.separateHeight),
        Expanded(child: _buildRightBtn()),
      ],
    );


  }

  /// 底部按鈕 - 取消
  Widget _buildLeftBtn() {
    return CommonButton(
      onTap: () => widget.onRejectCallback?.call(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: '取消',
      textStyle: _appTextTheme.dialogCancelButtonTextStyle,
      colorBegin: _appLinearGradientTheme.dialogCancelButtonColor.colors[0] ,
      colorEnd: _appLinearGradientTheme.dialogCancelButtonColor.colors[1] ,
      colorAlignmentBegin: _appLinearGradientTheme.dialogCancelButtonColor.begin,
      colorAlignmentEnd: _appLinearGradientTheme.dialogCancelButtonColor.end,
    );
  }

  /// 底部按鈕 - 立即聊天
  Widget _buildRightBtn() {
    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: startCallContent,
      textStyle: _appTextTheme.dialogConfirmButtonTextStyle,
      colorBegin: _appLinearGradientTheme.dialogConfirmButtonColor.colors[0] ,
      colorEnd: _appLinearGradientTheme.dialogConfirmButtonColor.colors[1] ,
      colorAlignmentBegin: _appLinearGradientTheme.dialogConfirmButtonColor.begin,
      colorAlignmentEnd: _appLinearGradientTheme.dialogConfirmButtonColor.end,
      onTap: () async {

        if(isPermission == false){
          BaseViewModel.showToast(context, permissionMsg);
          return;
        }
        final inviterUserID = widget.invitationData.inviter.userID;
        final type = widget.invitationData.callType;

        // 檢查餘額(男性)
        final result = await rechargeDialogHandler(inviterUserID, type);
        if (!result) return;

        final WsAccountGetRTCTokenRes res = await _buildRtcToken(roomID: widget.roomID, callUserId: widget.callUserId);
        if(res.answer?.rtcToken == null || res.answer?.channel == null) {
          return ;
        }

        /// 男性用互接電話前先打3-95
        final bool isMale = ref.read(userInfoProvider).memberInfo?.gender == 1;
        if(isMale) {
          final bool isChargeSucc = await _getMaleFirstChargeSucc();

          /// 男性扣費成功第一次才執行
          if(context.mounted) BaseViewModel.showToast(context, '通话开始');
          if(isChargeSucc) widget.onAcceptCallback?.call(res);
          return ;
        }

        if(context.mounted) BaseViewModel.showToast(context, '通话开始');
        widget.onAcceptCallback?.call(res);
      },
    );
  }

  Future<bool> _getMaleFirstChargeSucc() async {
    String? resultCodeCheck;
    final WsAccountCallChargeReq req = WsAccountCallChargeReq(roomId: widget.roomID, channel: widget.channel, chatType: widget.chatType);
    await ref.read(accountWsProvider).wsAccountCallCharge(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return true;
    }
    return false;
  }

  /// 免費通話（未使用）
  Widget _buildFreeCallingHint() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xffFAFAFA),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconTag.callingFree(),
              const SizedBox(width: 4),
              const Text(
                '不限对象额度 可免费通话 12 分钟',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff444648),
                ),
              ),
            ],
          ),
          const Text(
            '变更',
            style: TextStyle(
                color: Color(0xffEC6193),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
