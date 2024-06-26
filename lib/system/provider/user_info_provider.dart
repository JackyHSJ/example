
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/beauty_setting_model.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
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
import 'package:frechat/models/ws_res/member/ws_member_fate_online_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/models/ws_res/ws_hand_shake_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service_defines.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/system/extension/string.dart';

/// 想進行UserInfo 資料修改使用這個 StateNotifierProvider
final userUtilProvider = StateNotifierProvider<UserNotifier, UserInfoModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserInfoModel> {
  UserNotifier() : super(UserInfoModel());

  /// 是否有Token
  bool get isUserLoginState => state.commToken?.isNotEmpty ?? false;

  /// 是否為DeepLock模式
  bool get isDeepLinkMode => state.inviteCode?.isNotEmpty ?? false;

  String shareInvitedFriendUrl(InviteFriendType type) {

      String inviteCode = '';
      String agentName = state.memberInfo?.agentName ?? '';
      String userName = state.memberInfo?.userName ?? '';

      if (type == InviteFriendType.agent) {
        inviteCode = agentName;
      } else if (type == InviteFriendType.contact) {
        inviteCode = userName;
      }
      String deepLinkUri = AppConfig.getDeepLinkUri;

      final String inviteUri = DeepLinkModel(
        inviteCode: inviteCode,
        avatar: '',
        name: '',
      ).createUrl('$deepLinkUri/');
      return inviteUri;
  }

  /// launch 時調用
  Future<void> loadDataPrefs() async {
    try {
      final String commToken = await FcPrefs.getCommToken();
      final String loginData = await FcPrefs.getLoginData();
      final int userId = await FcPrefs.getUserId();
      final String userName = await FcPrefs.getUserName();
      final String nickName = await FcPrefs.getNickName();
      final String rtcToken = await FcPrefs.getRtcToken();
      final String phoneNumber = await FcPrefs.getPhoneNumber();
      final String inviteCode = await FcPrefs.getInviteCode();
      final bool isClosePersonalizedRecommendations = await FcPrefs.getIsClosePersonalizedRecommendations();
      final String themeStr = await FcPrefs.getTheme();
      final AppTheme? theme = themeStr.toAppTheme();

      final UserInfoModel userInfo = UserInfoModel(
        commToken: commToken,
        loginData: loginData,
        userId: userId,
        userName: userName,
        nickName: nickName,
        rtcToken: rtcToken,
        phoneNumber: phoneNumber,
        inviteCode: inviteCode,
        theme: theme,
        isClosePersonalizedRecommendations: isClosePersonalizedRecommendations,
      );
      state = userInfo;
    } catch (e) {
      print('load token error: $e');
      throw Exception('load token error: $e');
    }
  }

  /// 存取Token用
  Future<void> setDataToPrefs({
    String? commToken, String? loginData, String? environment,
    String? jpushToken, String? rtmToken, String? rtcToken,
    String? phoneToken, String? deviceModel, num? userId,
    String? userName, String? nickName, String? phoneNumber,
    String? theme,
    /// 美顏
    // double? whitening, double? redness, double? smoothing,
    // double? bigEyes, double? thinFace, double? vFace,
    // double? narrowFace, double? smallFace, double? chin,
    // double? forehead, double? nose, double? mouth,

    String? inviteCode, num? unreadMesg, num? activityUnreadCount,
    bool? isStrikeUpMateMode, UserCallStatus? userCallStatus,
    int? currentPage, String? currentChatUser,
    bool? isInChatroom,

    /// config
    ButtonConfigList? buttonConfigList,
    num? myVisitorExpireTime,

    OrderComputeConditionInfo? orderComputeCondition,
    num? callTimer,
    bool? isClosePersonalizedRecommendations,
  }) async {
    try {
      await FcPrefs.setCommToken(commToken ?? state.commToken ?? '');
      await FcPrefs.setLoginData(loginData ?? state.loginData ?? '');
      await FcPrefs.setUserId(userId ?? state.userId ?? 0);
      await FcPrefs.setUserName(userName ?? state.userName ?? '');
      await FcPrefs.setNickName(nickName ?? state.nickName ?? '');
      await FcPrefs.setRtcToken(rtcToken ?? state.rtcToken ?? '');
      await FcPrefs.setPhoneNumber(phoneNumber ?? state.phoneNumber ?? '');
      await FcPrefs.setInviteCode(inviteCode ?? state.inviteCode ?? '');
      await FcPrefs.setIsClosePersonalizedRecommendations(isClosePersonalizedRecommendations ?? state.isClosePersonalizedRecommendations ?? true);
      final String? themeStr = state.theme?.themeType.name;
      await FcPrefs.setTheme(theme ?? themeStr ?? '');

      final UserInfoModel userInfo = UserInfoModel(
        commToken: commToken ?? state.commToken,
        loginData: loginData ?? state.loginData,
        userId: userId ?? state.userId,
        userName: userName ?? state.userName,
        nickName: nickName ?? state.nickName,
        rtcToken: rtcToken ?? state.rtcToken,
        phoneNumber: phoneNumber ?? state.phoneNumber,
        callTimer: callTimer ?? state.callTimer,

        /// theme
        theme: theme?.toAppTheme() ?? state.theme,

        memberInfo: state.memberInfo,
        greetModuleList: state.greetModuleList,
        followList: state.followList,
        fansList: state.fansList,
        memberPointCoin: state.memberPointCoin,
        charmAchievement: state.charmAchievement,

        /// 推廣中心
        agentMemberListSearchAll: state.agentMemberListSearchAll,
        agentMemberListFriend: state.agentMemberListFriend,
        agentMemberListPrimaryPromotor: state.agentMemberListPrimaryPromotor,
        agentMemberListAgent: state.agentMemberListAgent,

        agentSecondMemberList: state.agentSecondMemberList,
        agentSecondFriendList: state.agentSecondFriendList,

        strikeUpListRecommendList: state.strikeUpListRecommendList,
        meetCardRecommendList: state.meetCardRecommendList,
        strikeUpListOnlineList: state.strikeUpListOnlineList,


        agentPromoterInfo: state.agentPromoterInfo,
        bannerInfo: state.bannerInfo,
        missionInfo: state.missionInfo,
        notificationSearchList: state.notificationSearchList,
        notificationBlockGroup: state.notificationBlockGroup,
        notificationSearchIntimacyLevelInfo: state.notificationSearchIntimacyLevelInfo,
        contactSearchList: state.contactSearchList,
        contactSearchForm: state.contactSearchForm,
        activitySearchInfoCity: state.activitySearchInfoCity,
        activitySearchInfoRecommend: state.activitySearchInfoRecommend,
        activitySearchInfoSubscribe: state.activitySearchInfoSubscribe,
        activitySearchInfoPersonal: state.activitySearchInfoPersonal,
        activitySearchInfoHotTopics: state.activitySearchInfoHotTopics ,
        activitySearchInfoTopics: state.activitySearchInfoTopics ,
        activityAllLikePostIdList: state.activityAllLikePostIdList,

        checkInSearchList: state.checkInSearchList,
        visitorList: state.visitorList,
        agentRewardRatioList: state.agentRewardRatioList,
        depositNumberOption: state.depositNumberOption,

        inviteCode: inviteCode ?? state.inviteCode,
        unreadMesg: unreadMesg ?? state.unreadMesg,
        activityUnreadCount: activityUnreadCount ?? state.activityUnreadCount,
        isStrikeUpMateMode: isStrikeUpMateMode ?? state.isStrikeUpMateMode,

        userCallStatus: userCallStatus ?? state.userCallStatus,

        currentPage: currentPage ?? state.currentPage,
        isInChatroom: isInChatroom ?? state.isInChatroom,
        currentChatUser: currentChatUser ?? state.currentChatUser,

        /// config
        buttonConfigList: buttonConfigList ?? state.buttonConfigList,
        myVisitorExpireTime: myVisitorExpireTime ?? state.myVisitorExpireTime,

        orderComputeCondition: orderComputeCondition ?? state.orderComputeCondition,
        isClosePersonalizedRecommendations: isClosePersonalizedRecommendations ?? state.isClosePersonalizedRecommendations,
      );

      state = userInfo;
    } catch (e) {
      print('set token error: $e');
      throw Exception('set token error: $e');
    }
  }

  /// 清空Prets內容（登出用）
  Future<void> clearUserInfo() async {
    try {
      await FcPrefs.setCommToken('');
      await FcPrefs.setUserId(0);
      await FcPrefs.setLoginData('');
      await FcPrefs.setUserName('');
      await FcPrefs.setNickName('');
      await FcPrefs.setRtcToken('');
      await FcPrefs.setPhoneNumber('');

      state = UserInfoModel();
    } catch (e) {
      print('clear UserInfo error: $e');
      throw Exception('clear UserInfo error: $e');
    }
  }

  /// ws member info res 時調用更新資料
  Future<void> loadMemberInfo(WsMemberInfoRes memberInfo) async {
    try {
      final copy = state.copyWith(memberInfo: memberInfo);
      state = copy;
    } catch (e) {
      print('loadMemberInfo error: $e');
      throw Exception('loadMemberInfo error: $e');
    }
  }

  /// ws followList info res 時調用更新資料
  Future<void> loadFollowList(WsAccountFollowAndFansListRes followList) async {
    try {
      final copy = state.copyWith(followList: followList);
      state = copy;
    } catch (e) {
      print('followList error: $e');
      throw Exception('followList error: $e');
    }
  }

  /// ws fansList info res 時調用更新資料
  Future<void> loadFansList(WsAccountFollowAndFansListRes fansList) async {
    try {
      final copy = state.copyWith(fansList: fansList);
      state = copy;
    } catch (e) {
      print('fansList error: $e');
      throw Exception('fansList error: $e');
    }
  }

  /// ws greet info res 時調用更新資料
  Future<void> loadGreetInfo(WsGreetModuleListRes greetModuleList) async {
    try {
      final copy = state.copyWith(greetModuleList: greetModuleList);
      state = copy;
    } catch (e) {
      print('loadGreetInfo error: $e');
      throw Exception('loadGreetInfo error: $e');
    }
  }

  /// ws MemberPointCoin info res 時調用更新資料
  Future<void> loadMemberPointCoin(WsMemberPointCoinRes memberPointCoin) async {
    try {
      final copy = state.copyWith(memberPointCoin: memberPointCoin);
      state = copy;
    } catch (e) {
      print('memberPointCoin error: $e');
      throw Exception('memberPointCoin error: $e');
    }
  }

  /// ws charmAchievement info res 時調用更新資料
  Future<void> loadCharmAchievement(WsSettingCharmAchievementRes charmAchievement) async {
    try {
      final copy = state.copyWith(charmAchievement: charmAchievement);
      if(copy.charmAchievement!.list!.isEmpty) {
        return ;
      }
      copy.charmAchievement!.list!.sort((a, b) => int.parse(a.charmLevel!).compareTo(int.parse(b.charmLevel!)));
      state = copy;
    } catch (e) {
      print('charmAchievement error: $e');
      throw Exception('charmAchievement error: $e');
    }
  }

  // agentMemberListSearchAll,
  // agentMemberListFriend,
  // agentMemberListPrimaryPromotor,
  // agentMemberListAgent,
  Future<void> loadAgentMemberListSearchAll(WsAgentMemberListRes agentMemberList) async {
    try {
      final copy = state.copyWith(agentMemberListSearchAll: agentMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentMemberListSearchAll error: $e');
      throw Exception('loadAgentMemberListSearchAll error: $e');
    }
  }
  Future<void> loadAgentMemberListFriend(WsAgentMemberListRes agentMemberList) async {
    try {
      final copy = state.copyWith(agentMemberListFriend: agentMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentMemberListFriend error: $e');
      throw Exception('loadAgentMemberListFriend error: $e');
    }
  }
  Future<void> loadAgentMemberListPrimaryPromotor(WsAgentMemberListRes agentMemberList) async {
    try {
      final copy = state.copyWith(agentMemberListPrimaryPromotor: agentMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentMemberListPrimaryPromotor error: $e');
      throw Exception('loadAgentMemberListPrimaryPromotor error: $e');
    }
  }
  Future<void> loadAgentMemberListAgent(WsAgentMemberListRes agentMemberList) async {
    try {
      final copy = state.copyWith(agentMemberListAgent: agentMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentMemberListAgent error: $e');
      throw Exception('loadAgentMemberListAgent error: $e');
    }
  }


  Future<void> loadAgentSecondMemberList(WsAgentMemberListRes agentSecondMemberList) async {
    try {
      final copy = state.copyWith(agentSecondMemberList: agentSecondMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentSecondMemberList error: $e');
      throw Exception('loadAgentSecondMemberList error: $e');
    }
  }

  Future<void> loadAgentSecondFriendList(WsAgentMemberListRes agentSecondMemberList) async {
    try {
      final copy = state.copyWith(agentSecondFriendList: agentSecondMemberList);
      state = copy;
    } catch (e) {
      print('loadAgentSecondFriendList error: $e');
      throw Exception('loadAgentSecondFriendList error: $e');
    }
  }

  Future<void> loadAgentPromoterInfo(WsAgentPromoterInfoRes agentPromoterInfo) async {
    try {
      final copy = state.copyWith(agentPromoterInfo: agentPromoterInfo);
      state = copy;
    } catch (e) {
      print('loadAgentPromoterInfo error: $e');
      throw Exception('loadAgentPromoterInfo error: $e');
    }
  }

  Future<void> loadBannerInfo(WsBannerInfoRes bannerInfo) async {
    try {
      final copy = state.copyWith(bannerInfo: bannerInfo);
      state = copy;
    } catch (e) {
      print('loadBannerInfo error: $e');
      throw Exception('loadBannerInfo error: $e');
    }
  }

  Future<void> loadMissionInfo(WsMissionSearchStatusRes missionInfo) async {
    try {
      final copy = state.copyWith(missionInfo: missionInfo);
      state = copy;
    } catch (e) {
      print('loadMissionInfo error: $e');
      throw Exception('loadMissionInfo error: $e');
    }
  }

  Future<void> loadNotificationListInfo(WsNotificationSearchListRes notificationSearchList) async {
    try {
      final copy = state.copyWith(notificationSearchList: notificationSearchList);
      state = copy;
    } catch (e) {
      print('loadMissionInfo error: $e');
      throw Exception('loadMissionInfo error: $e');
    }
  }

  Future<void> loadNotificationBlockGroup(WsNotificationBlockGroupRes notificationBlockGroup) async {
    try {
      final copy = state.copyWith(notificationBlockGroup: notificationBlockGroup);
      state = copy;
    } catch (e) {
      print('notificationBlockGroup error: $e');
      throw Exception('notificationBlockGroup error: $e');
    }
  }

  Future<void> loadNotificationSearchIntimacyLevelInfo(WsNotificationSearchIntimacyLevelInfoRes notificationSearchIntimacyLevelInfo) async {
    try {
      final copy = state.copyWith(notificationSearchIntimacyLevelInfo: notificationSearchIntimacyLevelInfo);
      state = copy;
    } catch (e) {
      print('notificationSearchIntimacyLevelInfo error: $e');
      throw Exception('notificationSearchIntimacyLevelInfo error: $e');
    }
  }

  Future<void> loadContactSearchList(WsContactSearchListRes contactSearchList) async {
    try {
      final copy = state.copyWith(contactSearchList: contactSearchList);
      state = copy;
    } catch (e) {
      print('notificationSearchIntimacyLevelInfo error: $e');
      throw Exception('notificationSearchIntimacyLevelInfo error: $e');
    }
  }

  Future<void> loadContactSearchForm(WsContactSearchFormRes contactSearchForm) async {
    try {
      final copy = state.copyWith(contactSearchForm: contactSearchForm);
      state = copy;
    } catch (e) {
      print('notificationSearchIntimacyLevelInfo error: $e');
      throw Exception('notificationSearchIntimacyLevelInfo error: $e');
    }
  }

  Future<void> loadActivityInfoCity(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoCity: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivitySearchInfo error: $e');
      throw Exception('loadActivitySearchInfo error: $e');
    }
  }

  Future<void> loadActivityInfoRecommend(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoRecommend: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoRecommend error: $e');
      throw Exception('loadActivityInfoRecommend error: $e');
    }
  }

  Future<void> loadActivityInfoSubscribe(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoSubscribe: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoSubscribe error: $e');
      throw Exception('loadActivityInfoSubscribe error: $e');
    }
  }

  Future<void> loadActivityInfoPersonal(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoPersonal: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoPersonal error: $e');
      throw Exception('loadActivityInfoPersonal error: $e');
    }
  }

  Future<void> loadActivityInfoHotTopics(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoHotTopics: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoHotTopics error: $e');
      throw Exception('loadActivityInfoHotTopics error: $e');
    }
  }

  Future<void> loadActivityInfoTopics(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoTopics: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoTopics error: $e');
      throw Exception('loadActivityInfoTopics error: $e');
    }
  }

  Future<void> loadActivityInfoOthers(WsActivitySearchInfoRes activitySearchInfo) async {
    try {
      final copy = state.copyWith(activitySearchInfoOthers: activitySearchInfo);
      state = copy;
    } catch (e) {
      print('loadActivityInfoOthers error: $e');
      throw Exception('loadActivityInfoOthers error: $e');
    }
  }

  Future<void> loadActivityAllLikePostIdList(List<dynamic> activityAllLikePostIdList) async {
    try {
      final copy = state.copyWith(activityAllLikePostIdList: activityAllLikePostIdList);
      state = copy;
    } catch (e) {
      print('loadActivityInfoTopics error: $e');
      throw Exception('loadActivityInfoTopics error: $e');
    }
  }


  Future<void> loadCheckInSearchList(WsCheckInSearchListRes checkInSearchList) async {
    try {
      final copy = state.copyWith(checkInSearchList: checkInSearchList);
      state = copy;
    } catch (e) {
      print('loadActivityInfoPersonal error: $e');
      throw Exception('loadActivityInfoPersonal error: $e');
    }
  }
  Future<void> loadVisitorList(WsVisitorListRes visitorList) async {
    try {
      final copy = state.copyWith(visitorList: visitorList);
      state = copy;
    } catch (e) {
      print('loadActivityInfoPersonal error: $e');
      throw Exception('loadActivityInfoPersonal error: $e');
    }
  }

  Future<void> loadAgentRewardRatioList(WsAgentRewardRatioListRes agentRewardRatioList) async {
    try {
      final copy = state.copyWith(agentRewardRatioList: agentRewardRatioList);
      state = copy;
    } catch (e) {
      print('loadActivityInfoPersonal error: $e');
      throw Exception('loadActivityInfoPersonal error: $e');
    }
  }

  Future<void> loadDepositNumberOption(WsDepositNumberOptionRes depositNumberOption) async {
    try {
      final copy = state.copyWith(depositNumberOption: depositNumberOption);
      state = copy;
    } catch (e) {
      print('loadDepositNumberOption error: $e');
      throw Exception('loadDepositNumberOption error: $e');
    }
  }

  Future<void> loadStrikeUpListRecommendList(WsMemberFateRecommendRes strikeUpListRecommendList) async {
    try {
      final copy = state.copyWith(strikeUpListRecommendList: strikeUpListRecommendList);
      state = copy;
    } catch (e) {
      print('loadStrikeUpListRecommendList error: $e');
      throw Exception('loadStrikeUpListRecommendList error: $e');
    }
  }

  Future<void> loadMeetCardRecommendList(WsMemberFateRecommendRes meetCardRecommendList) async {
    try {
      final copy = state.copyWith(meetCardRecommendList: meetCardRecommendList);
      state = copy;
    } catch (e) {
      print('loadMeetCardRecommendList error: $e');
      throw Exception('loadMeetCardRecommendList error: $e');
    }
  }

  Future<void> loadStrikeUpListOnlineList(WsMemberFateOnlineRes strikeUpListOnlineList) async {
    try {
      final copy = state.copyWith(strikeUpListOnlineList: strikeUpListOnlineList);
      state = copy;
    } catch (e) {
      print('loadStrikeUpListOnlineList error: $e');
      throw Exception('loadStrikeUpListOnlineList error: $e');
    }
  }
}