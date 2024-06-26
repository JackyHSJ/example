import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_quick_match_list_req.dart';
import 'package:frechat/screens/profile/certification/personal_certification.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class StrikeUpListMateComponentsViewModel {

  StrikeUpListMateComponentsViewModel({
    required this.ref,
    required this.setState,
  });
  WidgetRef ref;
  ViewChange setState;

  init() {
    // unReadMsgController = SwiperController();
  }

  dispose() {
    // unReadMsgController?.dispose();
  }

  pressMateBtn(BuildContext context, {
    required ZegoCallType type,
    Function()? onMate
  }) {
    final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
    if (isPipMode) {
      BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
    } else {
      final bool protectEnable = _getNewUserProtectEnable();
      final num firstVideoCharge = _getFirstCharge(type);
      final num defaultNum = type == ZegoCallType.video ? 500 : 200;
      final checkCoinNum = protectEnable ? firstVideoCharge : defaultNum;
      mateCheck(callType: type, checkCoinNum: checkCoinNum, onMate: onMate);
    }
  }

  /// 0 -> 關閉, 1 -> 開啟
  bool _getNewUserProtectEnable() {
    final WsNotificationSearchIntimacyLevelInfoRes? levelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo;
    final List<String> newUserProtect = (levelInfo?.newUserProtect ?? '').split('|');
    return newUserProtect[2] == '1';
  }

  num _getFirstCharge(ZegoCallType type) {
    final WsSettingCharmAchievementRes? charmAchievement = ref.read(userInfoProvider).charmAchievement;
    String firstChargeStr = '';
    switch(type) {
      case ZegoCallType.voice:
        firstChargeStr = charmAchievement?.getSortList().first.voiceCharge ?? '';
      case ZegoCallType.video:
        firstChargeStr = charmAchievement?.getSortList().first.streamCharge ?? '';
      case ZegoCallType.message:
        firstChargeStr = charmAchievement?.getSortList().first.messageCharge ?? '';
    }
    final num firstCharge = num.tryParse(firstChargeStr) ?? 0;
    return firstCharge;
  }

  ///檢查（語音速配錢）
  mateCheck({required ZegoCallType callType, required num checkCoinNum,  Function()? onMate}) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();

    final num coin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0;
    final num realPersonAuth = ref.read(userInfoProvider).memberInfo?.realPersonAuth ?? 0;
    final realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth;
    final CertificationType personAuthType = CertificationModel.getType(authNum: realPersonAuth);
    final CertificationType nameAuthType = CertificationModel.getType(authNum: realNameAuth);
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final bool isPermission = await _checkPermission(callType);//檢查權限
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    if(isPermission == false){
      return;
    }
    //女生必須 真人與實名認證 才使用速配
    if(gender == 0 &&(personAuthType != CertificationType.done || nameAuthType != CertificationType.done ) ) {
      CommDialog(currentContext).build(
        theme: theme,
        title: '真人/实名认证',
        contentDes: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪',
        leftBtnTitle: '考虑一下',
        rightBtnTitle: '立即认证',
        leftAction: () {
          BaseViewModel.popPage(currentContext);
        },
        rightAction: () {
          BaseViewModel.popPage(currentContext);
          BaseViewModel.pushPage(currentContext, const PersonalCertification());
        },
      );
      return;
    }

    final regTime = ref.read(userInfoProvider).memberInfo?.regTime; // 註冊時間
    bool isNewMember = isWithin7Days(regTime); // 註冊時間有沒有小於 7 天內

    // 檢查男性用戶餘額是否充足
    // checkCoinNum: 視頻 500, 語音 200
    if (coin < checkCoinNum && gender == 1) {
      final UserInfoModel userInfoModel = ref.read(userInfoProvider);
      // 新用戶有免費視訊時間
      if (isNewMember && callType == ZegoCallType.video) {
        final String res = await loadVideoMateList();
        if (res == ResponseCode.CODE_SUCCESS) {
          if(currentContext.mounted) _pushToMatePage(currentContext, callType: callType, onMate: onMate);
        } else if (res == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
          BaseViewModel.showRechargeBottomSheet(theme: theme, userInfoModel: userInfoModel);
        }
      } else {
        BaseViewModel.showRechargeBottomSheet(theme: theme, userInfoModel: userInfoModel);
      }
      return;
    }

    // 男性有錢或女性可以直接進
    if(currentContext.mounted) _pushToMatePage(currentContext, callType: callType, onMate: onMate);
  }

  _pushToMatePage(BuildContext context, {
    required ZegoCallType callType,
    required Function()? onMate
  }) {
    if(onMate != null) {
      onMate();
      return ;
    }
    BaseViewModel.pushPage(context, StrikeUpListMate(callType: callType), arguments: callType);
  }

  //檢查麥克風、鏡頭使用權限（語音通話只需要mic，視訊通話需要mic camera）
  Future<bool> _checkPermission(ZegoCallType callType) async {
    bool isMicPermission = await PermissionUtil.checkAndRequestMicrophonePermission();
    bool isCamPermission = false;
    if(callType == ZegoCallType.video){
      isCamPermission = await PermissionUtil.checkAndRequestCameraPermission();
    }
    if(callType == ZegoCallType.voice){
      return isMicPermission;
    }else{
      if(isMicPermission==false || isCamPermission == false){
        return false;
      }else{
        return true;
      }
    }
  }

  // 新用戶
  bool isWithin7Days(int regTime) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(regTime);
    DateTime dateTime2 = DateTime.now();

    Duration difference = dateTime1.difference(dateTime2);
    return difference.inDays.abs() < 7;
  }

  // 視頻速配新用戶
  Future<String> loadVideoMateList() async {
    String resultCodeCheck = '';

    const String type = '2';
    final WsAccountQuickMatchListReq reqBody = WsAccountQuickMatchListReq.create(
        type: type,
        page: 1
    );
    final res = await ref.read(accountWsProvider).wsAccountQuickMatchList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    return resultCodeCheck;
  }


}