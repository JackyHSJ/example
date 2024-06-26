

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/analytics/analytics_login.dart';
import 'package:frechat/models/req/member_login_req.dart';
import 'package:frechat/models/req/member_logout_req.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_promoter_info_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_reward_ratio_list_req.dart';
import 'package:frechat/models/ws_req/banner/ws_banner_info_req.dart';
import 'package:frechat/models/ws_req/check_in/ws_check_in_search_list_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_form_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_list_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_number_option_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_apply_cancel_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_fate_recommend_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_block_group_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_reward_ratio_list_res.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_form_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/activity/activity_notification_view_model.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/block_list_info.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/activity_message_model_provider.dart';
import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/new_user_behavior_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/provider/visitor_time_model_provider.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/util/file_util.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/zego_call/interal/express/express_util.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'zego_call/interal/zim/call_data_manager.dart';
import 'zego_call/interal/zim/zim_service.dart';
import 'zego_call/interal/zim/zim_service_defines.dart';
import 'zego_call/zego_sdk_manager.dart';

class AuthenticationManager {
  AuthenticationManager({required this.ref}) {
    accountWs = ref.read(accountWsProvider);
  }
  ProviderRef ref;

  late AccountWs accountWs;

  loginAndConnectWs({
    MemberLoginReq? req,
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    String? resultCodeCheck;
    await ref.read(commApiProvider).memberLogin(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {
          _checkLoginIsLock(errMsg);
          _checkLoginTokenIsExpired(errMsg);
          onConnectFail(errMsg);
        }
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(webSocketUtilProvider).connectWebSocket(
          onConnectSuccess: (succMsg) async {
            sendModifyLocation();
            sendAnalyticsLogin();
            onConnectSuccess(succMsg);
          },
          onConnectFail: (errMsg) {
            onConnectFail(errMsg);
          }
      );
    }
  }

  Future<void> keepRetryLoginAndConnectWs({
    MemberLoginReq? req,
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    bool loginSuccessful = false;
    while (!loginSuccessful) {
      try {
        await ref.read(commApiProvider).memberLogin(req,
            onConnectSuccess: (succMsg) => loginSuccessful = true,
            onConnectFail: (errMsg) {
              _checkLoginIsLock(errMsg);
              _checkLoginTokenIsExpired(errMsg);
              print('login too frequently');
            }
        );
      } catch (e) {
        print("Login attempt failed: $e");
      }

      /// 每1秒重複連線
      if (!loginSuccessful) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    await ref.read(webSocketUtilProvider).connectWebSocket(
        onConnectSuccess: (succMsg) {
          sendModifyLocation();
          sendAnalyticsLogin();
          onConnectSuccess(succMsg);
        },
        onConnectFail: onConnectFail
    );
  }

  _checkLoginIsLock(String errMsg) {
    if(errMsg != ResponseCode.CODE_MEMBER_STATE_LOCK) {
      return ;
    }
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    logout(
        onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(currentContext, GlobalData.launch ??  const Launch()),
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, errMsg)
    );
  }

  _checkLoginTokenIsExpired(String errMsg) {
    if(errMsg != ResponseCode.CODE_TID_ERROR_OR_EXPIRED) {
      return ;
    }
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    logout(
        onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(currentContext, GlobalData.launch ??  const Launch()),
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, errMsg)
    );
  }

  Future<bool> initZego({required WsAccountGetRTMTokenRes wsAccountGetRTMTokenRes}) async {
    /// get userName nickName
    final userName = ref.read(userInfoProvider).userName ?? '';
    final checkNickName = ref.read(userInfoProvider).nickName ?? '';
    final String nickName = (checkNickName == '') ? userName : checkNickName;

    ref.read(userUtilProvider.notifier).setDataToPrefs(rtcToken: wsAccountGetRTMTokenRes.rtcToken);
    try {
      await ref.read(zegoLoginProvider).init(
          userName: userName,
          nickName: nickName,
          token: wsAccountGetRTMTokenRes.rtcToken
      );
    } catch(e) {
      return false;
    }
    return true;
  }

  sendAnalyticsLogin() {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final num userId = userInfo.userId ?? 0;
    final String nickname = userInfo.memberInfo?.nickName ?? '';
    final String userName = userInfo.memberInfo?.userName ?? '';
    final String tId = userInfo.commToken ?? '';
    final Map<String, dynamic> properties = AnalyticsLogin(nickname: nickname, tId: tId, userName: userName,).toMap();
    ref.read(analyticsProvider).login('$userId', properties);
  }

  /// 需要loading才需要帶入context
  void logout({
    BuildContext? loadingContext,
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail
  }) {
    // loading start
    if(loadingContext != null) {
      final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
      LoadingAnimation.showOverlayDotsLoading(loadingContext, appTheme: theme);
    }

    final String commToken = ref.read(userInfoProvider).commToken ?? 'emptyToken';
    final reqBody = MemberLogoutReq.create(tId: commToken);
    ref.read(commApiProvider).memberLogout(reqBody,
        onConnectSuccess: (succMsg) async {
          await clearAllData();
          onConnectSuccess(succMsg);
          LoadingAnimation.cancelOverlayLoading();
        },
        onConnectFail: (errMsg) {
          onConnectFail(errMsg);
          LoadingAnimation.cancelOverlayLoading();
        });
  }

  deleteMember({
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail
  }) async {
    final reqBody = WsMemberApplyCancelReq.create();
    await ref.read(memberWsProvider).wsMemberApplyCancel(reqBody,
        onConnectSuccess: (succMsg) async {
          await clearAllData();
          onConnectSuccess(succMsg);
        },
        onConnectFail: (errMsg) => onConnectFail(errMsg)
    );
  }

  clearAllData({
    bool enableClearUserInfo = true
  }) async {
    /// 檢查是否通話中, 假如正在通話中須先結束通話
    final UserCallStatus userCallStatus = ref.read(userInfoProvider).userCallStatus ?? UserCallStatus.init;
    if(userCallStatus == UserCallStatus.calling) {
      cancelCalling();
    }

    String phoneNumber = await FcPrefs.getPhoneNumber();
    if(enableClearUserInfo == true) {
      await ref.read(userUtilProvider.notifier).clearUserInfo();
    }

    await ref.read(webSocketUtilProvider).onWebSocketDispose();
    ref.read(strikeUpUpdatedProvider.notifier).update((state) => null);

    final zegoLogin = ref.read(zegoLoginProvider);
    zegoLogin.disconnectNotification();
    zegoLogin.dispose();
    zegoLogin.callListenerDispose();
    zegoLogin.callingListUpdateListenerDispose();

    //删除ＤＢ
    ref.read(chatUserModelNotifierProvider.notifier).clearSql();
    ref.read(chatMessageModelNotifierProvider.notifier).clearSql();
    ref.read(chatImageModelNotifierProvider.notifier).clearSql();
    ref.read(chatGiftModelNotifierProvider.notifier).clearSql();
    ref.read(chatAudioModelNotifierProvider.notifier).clearSql();
    ref.read(chatCallModelNotifierProvider.notifier).clearSql();
    ref.read(chatBlockModelNotifierProvider.notifier).clearSql();
    ref.read(activityMessageModelNotifierProvider.notifier).clearSql();
    FcPrefs.setPhoneNumber(phoneNumber);
    FcPrefs.setIsCheckPrivcyAgreement(false);
    FcPrefs.setKeepNickNameInReview('');


    ref.read(newUserBehaviorManagerProvider).dispose();

    /// 清空log txt
    FileUtil.clearWriteText(fileName: GlobalData.logFileName);
  }

  Future<String?> sendModifyLocation() async {
    // String? resultCodeCheck;
    // final String location  = await BaiduLocationUtil.getLocation();
    // final token = ref.read(userUtilProvider).commToken ?? '';
    // final MemberModifyUserReq memberModifyUserReq = MemberModifyUserReq(
    //   tId: token,
    //   location: location
    // );
    // final currentContext = BaseViewModel.getGlobalContext();
    // await ref.read(commApiProvider).memberModifyUser(memberModifyUserReq,
    //   onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
    //   onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    // );
    //
    // if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
    //   print('亲～抓取定位资讯成功');
    //   return location;
    // }

    return null;
  }

  Future<void> _loadMemberInfo() async {
    String? resultCodeCheck;
    final WsMemberInfoReq reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {}
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
      GlobalData.memberInfo = res;
    }
  }

  Future<void> _loadRecommendList() async {
    String? resultCodeCheck;
    final WsMemberFateRecommendReq reqBody = WsMemberFateRecommendReq.create(
      page: 1, orderSeq: 1,
      topListPage: 1,
      // totalPages: totalPages,
    );
    final WsMemberFateRecommendRes res = await ref.read(memberWsProvider).wsMemberFateRecommend(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadStrikeUpListRecommendList(res);
      ref.read(userUtilProvider.notifier).loadMeetCardRecommendList(res);
    }
  }

  Future<void> _loadGreetInfo(BuildContext context) async {
    String? resultCodeCheck;
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    if(gender == 1) {
      return;
    }

    final WsGreetModuleListReq reqBody = WsGreetModuleListReq.create();
    final WsGreetModuleListRes res = await ref.read(greetWsProvider).wsGreetModuleList(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadGreetInfo(res);
    }
  }

  _loadFallowAndFans(BuildContext context) async {
    await _loadFallowList(context);
    await _loadFansList(context);
  }

  /// 1:关注列表,2:粉丝列
  Future<void> _loadFallowList(BuildContext context) async {
    String? resultCodeCheck;
    final WsAccountFollowAndFansListReq reqBody = WsAccountFollowAndFansListReq.create(
        type: 1
    );
    final WsAccountFollowAndFansListRes res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadFollowList(res);
    }
  }

  Future<void> _loadFansList(BuildContext context) async {
    String? resultCodeCheck;
    final WsAccountFollowAndFansListReq reqBody = WsAccountFollowAndFansListReq.create(
        type: 2
    );
    final WsAccountFollowAndFansListRes res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadFansList(res);
    }
  }

  Future<void> _loadPropertyInfo(BuildContext context) async {
    String? resultCodeCheck;
    final WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }

  Future<void> _loadCharmAchievement(BuildContext context) async {
    String? resultCodeCheck;
    final WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq.create();
    final WsSettingCharmAchievementRes res = await ref.read(settingWsProvider).wsSettingCharmAchievement(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }

  /// 16-1
  Future<void> _loadAgentMemberList(BuildContext context, {AgentMemberListMode? mode}) async {
    String? resultCodeCheck;
    DateTime currentDay = DateTime.now();
    final String startTimeFormat = DateFormatUtil.getDateWith24HourFormat(currentDay);
    final String endTimeFormat = DateFormatUtil.getDateWith24HourFormat(currentDay);
    final WsAgentMemberListReq reqBody = WsAgentMemberListReq.create(
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      agentMemberListMode: mode,
    );
    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentMemberList(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      switch (mode) {
        case AgentMemberListMode.friends:
          ref.read(userUtilProvider.notifier).loadAgentMemberListFriend(res);
          break;
        case AgentMemberListMode.primaryPromotor:
          ref.read(userUtilProvider.notifier).loadAgentMemberListPrimaryPromotor(res);
          break;
        case AgentMemberListMode.agent:
          ref.read(userUtilProvider.notifier).loadAgentMemberListAgent(res);
          break;
        case null:
          ref.read(userUtilProvider.notifier).loadAgentMemberListSearchAll(res);
          break;
        default:
          break;
      }
    }
  }

  Future<void> _loadAgentData(BuildContext context) async {
    await _loadAgentMemberList(context, mode: AgentMemberListMode.friends);
    await _loadAgentMemberList(context, mode: AgentMemberListMode.primaryPromotor);
    await _loadAgentMemberList(context, mode: AgentMemberListMode.agent);
    _loadAgentMemberList(context, mode: null);
  }

  Future<void> _loadAgentRewardRatioList() async {
    String resultCodeCheck = '';
    final WsAgentRewardRatioListReq reqBody = WsAgentRewardRatioListReq.create();
    final WsAgentRewardRatioListRes res = await ref.read(agentWsProvider).wsAgentRewardRatioList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadAgentRewardRatioList(res);
    }
  }

  /// 16-2
  Future<void> _loadAgentPromoterInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsAgentPromoterInfoReq.create();
    final WsAgentPromoterInfoRes res = await ref.read(agentWsProvider).wsAgentPromoterInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadAgentPromoterInfo(res);
    }
  }

  Future<void> _loadMissionInfo(BuildContext context) async {
    String? resultCodeCheck;
    final WsMissionSearchStatusReq reqBody = WsMissionSearchStatusReq.create();
    final WsMissionSearchStatusRes res = await ref.read(missionWsProvider).wsMissionSearchStatus(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMissionInfo(res);
    }
  }

  Future<void> _loadBannerInfo(BuildContext context) async {

    String appId = AppConfig.getBundleId();
    num osType = Platform.isIOS ? 0 : 1;
    String resultCodeCheck = '';
    WsBannerInfoReq reqBody = WsBannerInfoReq.create(appId: appId, osType: osType);
    final WsBannerInfoRes res = await ref.read(bannerWsProvider).wsBannerInfo(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadBannerInfo(res);
      print('[loadBannerInfo Success!]: ${jsonEncode(res.toJson())}');
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }

  Future<WsNotificationSearchListRes> _loadNotificationSearchList({ num page = 1 }) async {
    String? resultCodeCheck;
    WsNotificationSearchListReq reqBody = WsNotificationSearchListReq.create(page: '$page');
    final WsNotificationSearchListRes res = await ref.read(notificationWsProvider).wsNotificationSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {}
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadNotificationListInfo(res);
      print('[loadNotificationSearchList Success!]: ${jsonEncode(res.toJson())}');
    }

    return res;
  }

  Future<void> _loadNotificationSearchIntimacyLevelInfo(BuildContext context) async {
    String? resultCodeCheck;
    final WsNotificationSearchIntimacyLevelInfoReq reqBody = WsNotificationSearchIntimacyLevelInfoReq.create();
    final WsNotificationSearchIntimacyLevelInfoRes res = await ref.read(notificationWsProvider).wsNotificationSearchIntimacyLevelInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadNotificationSearchIntimacyLevelInfo(res);
    }
  }

  Future<void> _loadContactSearchList(BuildContext context) async {
    String? resultCodeCheck;
    final WsContactSearchListReq reqBody = WsContactSearchListReq.create(page: '1', size: '10', querykeyword: '');
    final WsContactSearchListRes res = await ref.read(contactWsProvider).wsContactSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) =>  BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadContactSearchList(res);
    }
  }

  Future<void> _loadContactSearchForm(BuildContext context) async {
    String? resultCodeCheck;
    final WsContactSearchFormReq reqBody = WsContactSearchFormReq.create();
    final WsContactSearchFormRes res = await ref.read(contactWsProvider).wsContactSearchForm(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadContactSearchForm(res);
    }
  }

  Future<void> _loadCheckInSearchList(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsCheckInSearchListReq.create();
    final WsCheckInSearchListRes res = await ref.read(checkInWsProvider).wsCheckInSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCheckInSearchList(res);
    }
  }

  Future<void> _loadVisitorList(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsVisitorListReq.create(
        page: '1'
    );
    final WsVisitorListRes res = await ref.read(visitorWsProvider).wsVisitorList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadVisitorList(res);
    }
  }

  Future<WsNotificationBlockGroupRes?> _loadNotificationBlockGroup({required num page}) async {
    String? resultCodeCheck;
    WsNotificationBlockGroupReq reqBody = WsNotificationBlockGroupReq.create(page: page);
    final WsNotificationBlockGroupRes res = await ref.read(notificationWsProvider).wsNotificationBlockGroup(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {}
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if(page == 1) {
        ref.read(userUtilProvider.notifier).loadNotificationBlockGroup(res);
      }
      return res;
    }

    return null;
  }

  Future<void> _loadDepositNumberOption(BuildContext context) async {
    String resultCodeCheck = '';
    final WsDepositNumberOptionReq reqBody = WsDepositNumberOptionReq.create();
    final WsDepositNumberOptionRes res = await ref.read(depositWsProvider).wsDepositNumberOption(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadDepositNumberOption(res);
    }
  }

  Future<void> _loadSqfliteData() async {
    ref.read(chatCallModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatUserModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatMessageModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatImageModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatAudioModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatGiftModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatBlockModelNotifierProvider.notifier).loadDataFromSql();

    /// 讀取美顏設定值
    ref.read(zegoBeautyModelNotifierProvider.notifier).loadDataFromSql();

    /// 讀取訪客資料
    ref.read(visitorTimeModelNotifierProvider.notifier).loadDataFromSql();

    /// 讀取新用戶排序相關資料
    ref.read(newUserBehaviorModelNotifierProvider.notifier).loadDataFromSql();

    // 動態牆列通知列表
    ref.read(activityMessageModelNotifierProvider.notifier).loadDataFromSql();
  }

  _checkJavaSystem(List<ChatUserModel> chatUserModels) async {
    final bool isContainJavaSys = chatUserModels.any((model) => model.userName == 'java_system');
    if(isContainJavaSys) {
      return ;
    }
    final ChatUserModel javaSysModel = _initJavaDataToSql();
    await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [javaSysModel]);
  }

  Future<void> loadBlockGroupInDB() async {
    num page = 0;
    bool shouldContinue = true;
    while (shouldContinue) {
      page++;
      final WsNotificationBlockGroupRes? res = await _loadNotificationBlockGroup(page: page);
      final userId = ref.read(userInfoProvider).userId;
      final List<ChatBlockModel> modelList = res?.list?.map((blockInfo) => blockInfo.toChatBlockModel(userId: userId)).toList() ?? [];
      ref.read(chatBlockModelNotifierProvider.notifier).setDataToSql(chatBlockModelList: modelList);

      final num pageSize = res?.pageSize ?? 1;
      final num currentLength = res?.list?.length ?? 0;
      if(pageSize > currentLength) {
        break;
      }
    }
  }

  Future<List<SearchListInfo>> _loadAllSearchListInfo() async {
    final List<SearchListInfo> list = [];
    num page = 0;
    bool shouldContinue = true;
    while (shouldContinue) {
      page++;
      final WsNotificationSearchListRes res = await _loadNotificationSearchList(page: page);
      final num pageSize = res.pageSize ?? 1;
      final num currentLength = res.list?.length ?? 0;
      list.addAll(res.list ?? []);
      if(pageSize > currentLength) {
        shouldContinue = false;
      }
    }
    return list;
  }

  Future<List<SearchListInfo>?> loadSearchListInDB({
    bool? loadAllData = false,
    bool? updateDb = true,
  }) async {
    final List<ChatUserModel> chatUserModel = ref.read(chatUserModelNotifierProvider);
    await _checkJavaSystem(chatUserModel);

    if(chatUserModel.isEmpty) {
      final List<SearchListInfo> searchListInfoList = await _loadAllSearchListInfo();
      final List<ChatUserModel> chatUserModelList = searchListInfoList.map((info) => _initChatUserModel(info)).toList();
      await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: chatUserModelList);
      return searchListInfoList;
    }

    ///扣除官方訊息（java_system）動態通知(feed_notify)，目前訊息總數
    final num modelLength = chatUserModel.where((model) => model.userName != 'java_system' && model.userName != 'feed_notify').length;

    /// 檢查roomCount與自己的DB總數量是不是一致
    final WsNotificationSearchInfoWithTypeRes resLength = await _loadNotificationSearchInfoWithType(type: 1);
    if(resLength.roomCount == modelLength) {
      if(loadAllData == true) {
        final List<SearchListInfo> searchListInfoList = chatUserModel.map((model) => model.toSearchListInfo()).toList();
        return searchListInfoList;
      }
      return null;
    }

    /// 不一致, 則補齊DB
    /// 比對res的roomList 與 DB的RoomId 缺少哪些RoomId
    final WsNotificationSearchInfoWithTypeRes resRoomIds = await _loadNotificationSearchInfoWithType(type: 2);
    final List<num?> chatUserModelRoomIds = chatUserModel.map((model) => model.roomId).toList();
    final List<num> roomList = resRoomIds.roomList?.map((item) => item as num).toList() ?? [];

    /// 檢查並檢查删除多餘的DB ChatUserModel
    await _checkAndCompareChatUserModelData(allRoomList: roomList, chatUserModelRoomIds: chatUserModelRoomIds);

    final List<num> lackRoomIds = roomList.where((roomId) {
      final bool isContain = chatUserModelRoomIds.contains(roomId);
      if(loadAllData == true) {
        return true;
      }
      return !isContain;
    }).map((roomId) => roomId).toList();

    /// 把roomList送出type 3, 補齊資料進DB
    final WsNotificationSearchInfoWithTypeRes resSearchInfo = await _loadNotificationSearchInfoWithType(
        type: 3,
        roomIdList: lackRoomIds
    );

    if(resSearchInfo.list == null || resSearchInfo.list == []) {
      return null;
    }

    if(updateDb == true) {
      final List<ChatUserModel> chatUserModelList = resSearchInfo.list?.map((info) => _initChatUserModel(info)).toList() ?? [];
      await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: chatUserModelList);
    }

    return resSearchInfo.list;
  }

  Future<WsNotificationSearchInfoWithTypeRes> _loadNotificationSearchInfoWithType({
    required num type,
    List<num>? roomIdList
  }) async {
    final WsNotificationSearchInfoWithTypeReq reqBody = WsNotificationSearchInfoWithTypeReq.create(
        type: type,
        roomIdList: roomIdList
    );
    final WsNotificationSearchInfoWithTypeRes res = await ref.read(notificationWsProvider).wsNotificationSearchInfoWithType(
        reqBody,
        onConnectSuccess: (succMsg){ },
        onConnectFail: (errMsg){}
    );
    return res;
  }

  _checkAndCompareChatUserModelData({required List<num> allRoomList, required List<num?> chatUserModelRoomIds}) async {
    final List<num> notInAllRoomList = chatUserModelRoomIds.where((chatRoomId) {
      if(chatRoomId == 0) {
        return false;
      }
      final bool isContain = allRoomList.contains(chatRoomId);
      return !isContain;
    }).map((chatRoomId) => chatRoomId as num).toList();

    if(notInAllRoomList.isEmpty) {
      return ;
    }

    /// 把roomList送出type 3, 補齊資料進DB
    final WsNotificationSearchInfoWithTypeRes resSearchInfo = await _loadNotificationSearchInfoWithType(
        type: 3,
        roomIdList: notInAllRoomList
    );

    if(resSearchInfo.list == null || resSearchInfo.list == []) {
      return null;
    }

    resSearchInfo.list?.forEach((info) {
      final ChatUserModel model = _initChatUserModel(info);
      ref.read(chatUserModelNotifierProvider.notifier).clearSql(whereModel: model);
    });
  }


  Future<void> _loadActivity() async {
    // await _loadActivityInfo(type: '0', condition: '0'); // 同城
    await _loadActivityInfo(type: WsActivitySearchInfoType.recommend, condition: '0', needGender: true); // 推薦
    await _loadActivityInfo(type: WsActivitySearchInfoType.subscribe, condition: '0', needGender: true); // 關注
    await _loadActivityInfo(type: WsActivitySearchInfoType.personal, condition: '0', needGender: false); // 本人
    await _loadActivityInfo(type: WsActivitySearchInfoType.hotTopics, condition: '0', needGender: true); // 熱門話題
    _loadActivityNotification(); // 動態通知
  }

  Future<void> _loadActivityInfo({
    required WsActivitySearchInfoType type,
    required String condition,
    required bool needGender
  }) async {
    String? resultCodeCheck;
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    num gmType = userInfo.buttonConfigList?.gmType ?? 0;
    num? userGender = await ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    userGender == 0 ? userGender = 1 : userGender = 0; // 取跟自己相反的 gender
    if (!needGender) userGender = null; // type 3 不用帶 gender
    if(gmType == 1) userGender = null;//超管狀態下，顯示男女貼文
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: condition,gender: userGender);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg){ }
    );
    /// 0:同城 1:推薦 2:關注 3.本人 4.熱門貼文
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      switch(type) {
        case WsActivitySearchInfoType.city:
          ref.read(userUtilProvider.notifier).loadActivityInfoCity(res);
          break;
        case WsActivitySearchInfoType.recommend:
          GlobalData.cacheUserPostActivityPostInfoList = [];
          ref.read(userUtilProvider.notifier).loadActivityInfoRecommend(res);
          break;
        case WsActivitySearchInfoType.subscribe:
          ref.read(userUtilProvider.notifier).loadActivityInfoSubscribe(res);
          break;
        case WsActivitySearchInfoType.personal:
          ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(res);
          break;
        case WsActivitySearchInfoType.hotTopics:
          ref.read(userUtilProvider.notifier).loadActivityInfoHotTopics(res);
          break;
        default:
          break;
      }
    }
  }

  Future<void> _loadActivityNotification() async {
    ZIMMessageQueriedResult res = await ref.read(zimServiceProvider).getAllHistoryMessageFromUserName(conversationID: 'feed_notify');
    List<ActivityMessageModel> list = ActivityNotificationViewModel.convertToActivityMessageModel(res);
    ref.read(activityMessageModelNotifierProvider.notifier).setDataToSql(activityMessageModelList: list);
  }

  /// 更新至 全部已按讚動態貼文ID清單
  Future<void> _refreshActivityAllLikePostIdList(List<dynamic> likeList) async{
    List<dynamic> allLikeList = await ref.read(userInfoProvider).activityAllLikePostIdList?? [];
    Set<dynamic> mergedSet = {};
    mergedSet.addAll(allLikeList);
    mergedSet.addAll(likeList);
    List<dynamic> mergedList = mergedSet.toList();
    ref.read(userUtilProvider.notifier).loadActivityAllLikePostIdList(mergedList);
  }

  preload(BuildContext context) async {
    /// load db data preload
    _loadSqfliteData();

    /// 預載資料
    _loadFallowAndFans(context);
    _loadPropertyInfo(context);
    _loadCharmAchievement(context);

    /// 推廣中心 預載資料用
    // _loadAgentData(context);
    // _loadAgentPromoterInfo(context);

    /// 推廣中心邀請成員, 當前獎勵%數
    _loadAgentRewardRatioList();

    _loadMissionInfo(context);
    _loadNotificationSearchIntimacyLevelInfo(context);
    _loadContactSearchList(context);
    _loadContactSearchForm(context);
    _loadCheckInSearchList(context);
    _loadVisitorList(context);
    _loadDepositNumberOption(context);

    await _loadNotificationSearchList();
    await loadSearchListInDB();
    await loadBlockGroupInDB();
    await _loadBannerInfo(context);
    await _loadMemberInfo();
    await _loadRecommendList();
    /// loadGreetInfo 需放在loadMemberInfo後面 因為有判斷性別
    _loadGreetInfo(context);
    /// 動態牆 需放在loadMemberInfo後面 因為有判斷性別
    _loadActivity();
  }

  ChatUserModel _initChatUserModel(SearchListInfo info) {
    return ChatUserModel(
      userId: info.userId,
      roomIcon: info.roomIcon,
      cohesionLevel: info.cohesionLevel,
      userCount: info.userCount,
      isOnline: info.isOnline,
      userName: info.userName,
      roomId: info.roomId,
      roomName: info.roomName,
      points: info.points,
      remark: info.remark,
      notificationFlag: info.notificationFlag,
      unRead: 0,
      recentlyMessage: '',
      pinTop: 0,
      timeStamp: 0,
      charmCharge: '',
    );
  }

  ChatUserModel _initJavaDataToSql() {
    return ChatUserModel(
      userName: 'java_system',
      userId: 0,
      roomIcon: 'assets/images/system_avatar.png',
      cohesionLevel: 0,
      userCount: 0,
      isOnline: 0,
      roomId: 0,
      roomName: '官方讯息',
      points: 0,
      unRead: 0,
      recentlyMessage: '',
      pinTop: 0,
      timeStamp: 0,
    );
  }

  Future<ChatUserModel> loadChatUserModelFailAndAppendToDB({required num roomId}) async {
    final WsNotificationSearchInfoWithTypeRes res = await _loadNotificationSearchInfoWithType(type: 3, roomIdList: [roomId]);
    final SearchListInfo searchListInfo = res.list?.firstWhere((info) => info.roomId == roomId) ?? SearchListInfo();
    final ChatUserModel model = _initChatUserModel(searchListInfo);
    await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [model]);
    return model;
  }


  Future<void> cancelCalling() async {
    /// 取出cache data
    final String channel =  GlobalData.cacheChannel ?? '';
    final num roomID = GlobalData.cacheRoomID ?? 0;
    final ZegoCallData callData = GlobalData.cacheCallData!;
    final ZIMService zimService = ref.read(zimServiceProvider);
    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final BuildContext context = BaseViewModel.getGlobalContext();
    final bool isVideoCall = callData.callType == ZegoCallType.video;
    final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
    final expressUtil = ExpressUtil(ref: ref);
    // final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;

    /// 結束通話(3-97)
    _endCallReq(channel: channel, roomId: roomID);

    /// 如果有撥打通話, 則取消邀請
    zimService.cancelInvitation(
      invitationID: callData.callID,
      invitees: [callData.invitee.userID],
    );

    /// 如果是視訊通話, 則關閉美顏
    if(isVideoCall) {
      manager.disposeZegoEffect();
    }

    if(isPipMode) {
      expressUtil.dispose();
      PipUtil.exitPiPMode();
    } else {
      BaseViewModel.popupDialog();
      BaseViewModel.popPage(context);
    }

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
  }

  _endCallReq({
    required String channel,
    required num roomId
  }) {
    final WsAccountEndCallReq endCallReq = WsAccountEndCallReq(roomId: roomId, channel: channel);
    accountWs.wsAccountEndCall(endCallReq,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg) {}
    );
  }
}