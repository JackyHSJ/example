
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../models/ws_res/member/ws_member_info_res.dart';
import '../../../system/providers.dart';
import '../../../system/repository/http_setting.dart';
import '../../../system/zego_call/interal/zim/zim_service_defines.dart';
import '../../shared/color_box.dart';
import '../../shared/dialog/recharge_dialog.dart';
import '../../shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class StrikeUpListMateDialog extends ConsumerStatefulWidget {
  const StrikeUpListMateDialog({
    super.key,
    required this.viewModel,
    required this.mateMemberInfo,
  });
  final StrikeUpListMateViewModel viewModel;
  final WsMemberInfoRes mateMemberInfo;

  @override
  ConsumerState<StrikeUpListMateDialog> createState() => _StrikeUpListMateState();
}

class _StrikeUpListMateState extends ConsumerState<StrikeUpListMateDialog> {
  WsMemberInfoRes get mateMemberInfo => widget.mateMemberInfo;
  late ChatRoomViewModel chatRoomViewModel;
  String? channel;
  num? roomId;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppImageTheme _appImageTheme;

  void _loadCache({
    required String token,
    required SearchListInfo searchListInfoRes,
  }) {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final String userName = userInfo.userName ?? '';
    final String nickName = userInfo.nickName ?? '';
    final String roomName = userInfo.nickName == '' ? userName : nickName;

    GlobalData.cacheCallData = ZegoCallStateManager.instance.callData!;
    GlobalData.cacheOtherUserInfo = ZegoUserInfo(userID: userName, userName: roomName);
    GlobalData.cacheToken = token;
    GlobalData.cacheChannel = channel;
    GlobalData.cacheRoomID = roomId;
    GlobalData.cacheMemberInfoRes = mateMemberInfo;
    GlobalData.cacheSearchListInfo = searchListInfoRes;
  }

  _cancelCallApi() {
    if(channel != null && roomId != null) {
      widget.viewModel.wsAccountEndCall(context, channel ?? '', roomId ?? 0);
    }
  }

  _zegoCancelInvited() {
    try {
      final ZegoCallData zegoCallData = ZegoCallStateManager.instance.callData!;
      final zimService = ref.read(zimServiceProvider);
      zimService.cancelInvitation(
        invitationID: zegoCallData.callID,
        invitees: [zegoCallData.invitee.userID],
      );
      final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
      final ExpressService expressService = ref.read(expressServiceProvider);
      manager.disposeZegoEffect();
      expressService.stopPreview();
      expressService.stopPublishingStream();
      if(channel != null) {
        expressService.logoutRoom(channel ?? '');
      }
    } catch (e) {
      print('error $e');
    }
  }

  ///確認使用速配是男生時的金币餘額
  iniCheck() {
    final num gender = mateMemberInfo.gender ?? 0;
    if (gender == 1) {
      // _getGoldCoins_2_8();
    }
  }

  void _onTapStartChattingButton() async{
    final bool isBlock = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;
    final bool isReviewAccount = ref.read(userInfoProvider).memberInfo?.type == 2 ? true : false;
    final String timeoutText = mateMemberInfo.gender == 0
        ? '小姊姊未接听，好的缘分须多点耐心'
        : '小哥哥未接听，好的缘分须多点耐心';
    // 判斷環境是否設定審核中或是審核帳號
    if (isBlock || isReviewAccount) {
      widget.viewModel.initDialogTimer(context, setState: setState, onTimeOut: (){
        widget.viewModel.sendEmptyCall(context, timeoutText);
      });
      setState(() {});
      return;
    }

    // 正常流程
    final strikeUpRes = await widget.viewModel.strikeUp(context, userName: mateMemberInfo.userName ?? '');
    final searchListInfoRes = await widget.viewModel.getMateSearchListInfo(context, roomId: strikeUpRes?.chatRoom?.roomId ?? 0);
    final callVerificationRes = await widget.viewModel.callVerification(context, freUserId: searchListInfoRes?.userId ?? 0, roomId: strikeUpRes?.chatRoom?.roomId ?? 0, timeoutText: timeoutText);
    if (strikeUpRes == null || searchListInfoRes == null || callVerificationRes == null) return;

    channel = callVerificationRes.call?.channel;
    roomId = searchListInfoRes.roomId;
    final userId = ref.read(userInfoProvider).userId ?? 0;
    final token = callVerificationRes.call?.rtcToken ?? '';
    final invitedName = mateMemberInfo.userName ?? '';
    await ref.read(callAuthenticationManagerProvider).startCall(
        callType: widget.viewModel.callType,
        invitedName: invitedName,
        token: token,
        channel: channel ?? '',
        callUserId: userId, // 自己
        isNeedLoading: false,
        isOfflineCall: true,
        searchListInfo: searchListInfoRes,
        otherMemberInfoRes: mateMemberInfo,
    );
    _loadCache(token: token, searchListInfoRes: searchListInfoRes);

    widget.viewModel.initDialogTimer(context, setState: setState, onTimeOut: () {
      BaseViewModel.popPage(context);
      BaseViewModel.showToast(context, timeoutText);
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    });
    setState(() {});
  }

  @override
  void initState() {
    chatRoomViewModel = ChatRoomViewModel(ref: ref, context: context);
    StrikeUpListMateViewModel.stateController.sink.add(MateState.open);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 24.w,),
        Center(child: Text('您的速配对象', style:_appTextTheme.appbarTextStyle)),
        InkWell(
          onTap: () {
            _cancelCallApi();
            _zegoCancelInvited();
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
          },
          child:ImgUtil.buildFromImgPath(_appImageTheme.bottomSheetCancelBtnIcon, size: 24.w),
        )
      ],
    );
  }
  /// 內容
  Widget _buildContent(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              _buildAvatar(),
              _buildNickName(),
              _buildGenderAndAge(),
              _buildInfoTagList(),
              _buildCallDetailsLabel(),
              _buildChargeItemList(),
            ],
          ),
        ],
      ),

    );
  }
  /// 內容 - 頭像
  Widget _buildAvatar() {
    final String avatarPath = mateMemberInfo.avatarPath ?? '';
    final String avatar = HttpSetting.baseImagePath + avatarPath;
    final num gender = mateMemberInfo.gender ?? 0;
    return Padding(
        padding:EdgeInsets.symmetric(vertical: 12.h),
        child: (avatarPath != '')
            ? AvatarUtil.userAvatar(avatar, size: 64.w)
            : AvatarUtil.defaultAvatar(gender, size: 64.w)
    );
  }
  /// 內容 - 性別
  Widget _buildGenderAndAge() {
    final num gender = mateMemberInfo.gender ?? 0;
    final num age = mateMemberInfo.age ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTag.genderAge(gender: gender, age: age),
      ],
    );
  }
  /// 內容 - 暱稱
  Widget _buildNickName(){
    final String userName = mateMemberInfo.userName ?? '';
    final String nickName = mateMemberInfo.nickName ?? userName;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: UIDefine.getWidth(),
      child: MainGradient(linearGradient: _appLinearGradientTheme.vipTextColor).text(title: nickName, fontSize: 20, fontWeight: FontWeight.w600, textAlign: TextAlign.center),
    );
  }
  /// 內容 - 標籤列表（地點/身高/體重）
  Widget _buildInfoTagList(){
    final num height = mateMemberInfo.height ?? 0;
    final num weight = mateMemberInfo.weight ?? 0;
    final String location = mateMemberInfo.location ?? '';
    final String hometown = mateMemberInfo.hometown ?? '';
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
      child: Text('想要与您速配，快接听把握缘分吧', style: _appTextTheme.dialogContentTextStyle),
    );
  }
  /// 內容 - 收費資訊
  Widget _buildChargeItemList(){
    final num gender = mateMemberInfo.gender ?? 0;

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
      decoration: _appBoxDecorationTheme.strikeUpMateDialogChargeBoxDecoration,
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
    final List<String>? part = mateMemberInfo.charmCharge?.split('|');
    final callTypeIndex = (widget.viewModel.callType == ZegoCallType.voice) ? 1 : 2;

    final WsSettingCharmAchievementRes charmAchievement = ref.watch(userInfoProvider).charmAchievement ?? WsSettingCharmAchievementRes();
    List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement.list;
    String mateCharmCharge = '';

    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    final List<String> newUserProtect = (intimacyLevelInfo.newUserProtect ?? '').split('|');

    // 後台受保護的親密點數、魅力等級、開關
    num protectIntimacyPoints = double.parse(newUserProtect[0]) ?? 0;
    String protectCharmLevel = newUserProtect[1];
    String protectEnable = newUserProtect[2];

    // 收費價格
    CharmAchievementInfo? charmAchievementInfoVoice;
    CharmAchievementInfo? charmAchievementInfoVideo;

    // 0 代表新用戶保護關閉
    if (protectEnable == '0') {
      charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == part![1].toString(), orElse: () => CharmAchievementInfo(charmLevel: "0"));
      charmAchievementInfoVideo = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == part![2].toString(), orElse: () => CharmAchievementInfo(charmLevel: "0"));
    } else {
      // 顯示後台設定的魅力等級扣費標準
      charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
      charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
    }

    if (callTypeIndex == 1) {
      mateCharmCharge = charmAchievementInfoVoice?.voiceCharge ?? '';
    } else {
      mateCharmCharge = charmAchievementInfoVideo?.streamCharge ?? '';
    }

    return Container(
      height: 44,
      width: 148,
      decoration: _appBoxDecorationTheme.strikeUpMateDialogChargeBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text('通话费率', style: _appTextTheme.strikeUpMateDialogChargeTextStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 16.w),
              Text('$mateCharmCharge / 分钟', style: _appTextTheme.strikeUpMateDialogChargeTextStyle,),
            ],
          ),
        ],
      ),
    );
  }
  /// 底部按鈕
  Widget _buildActionButtons() {
    final bool isTimerEnable = widget.viewModel.dialogTimer?.isActive ?? false;
    return Container(
      child: isTimerEnable
          ? _buildWaitingButton()
          : Row(
              children: [
                Expanded(child: _buildActionNextButton()),
                SizedBox(width: WidgetValue.horizontalPadding),
                Expanded(child: _buildActionStartChattingButton()),
              ],
            ),
    );
  }
  /// 底部按鈕 - 立即接聽
  Widget _buildActionStartChattingButton(){
    return InkWell(
      onTap: () =>_onTapStartChattingButton(),
      child: Container(
        alignment: Alignment.center,
        height: 44.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2), gradient: _appLinearGradientTheme.dialogConfirmButtonColor),
        child: Text('开始聊天', style: _appTextTheme.dialogConfirmButtonTextStyle),
      ),
    );
  }
  /// 底部按鈕 - 等候下一位
  Widget _buildActionNextButton(){
    return InkWell(
      onTap: () => widget.viewModel.nextOneMate(context),
      child: Container(
        alignment: Alignment.center,
        height: 44.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2), gradient: _appLinearGradientTheme.dialogCancelButtonColor),
        child: Text('等候下一位', style: _appTextTheme.dialogCancelButtonTextStyle),
      ),
    );
  }
  /// 底部按鈕 - 等待接聽
  Widget _buildWaitingButton(){
    final num countDownTime = widget.viewModel.currentCountDownTime;
    return InkWell(
      onTap: () =>_onTapStartChattingButton(),
      child: Container(
        alignment: Alignment.center,
        height: 44.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2), gradient: _appLinearGradientTheme.dialogConfirmButtonColor),
        child: Text('等待对方中 ${countDownTime}s', style: _appTextTheme.dialogConfirmButtonTextStyle),
      ),
    );
  }

}
