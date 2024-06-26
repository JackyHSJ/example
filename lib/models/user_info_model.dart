import 'package:frechat/models/beauty_setting_model.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_second_member_list_req.dart';
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
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/models/ws_res/ws_hand_shake_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service_defines.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class UserInfoModel {
  UserInfoModel({
    this.memberInfo,
    this.environment,
    this.commToken,
    this.jpushToken,
    this.rtmToken,
    this.rtcToken,
    this.phoneToken,
    this.deviceModel,
    this.loginData,
    this.userId,
    this.userName,
    this.nickName,
    this.phoneNumber,
    this.inviteCode,
    this.greetModuleList,
    this.followList,
    this.fansList,
    this.memberPointCoin,
    this.charmAchievement,
    this.unreadMesg,
    this.activityUnreadCount,
    this.agentPromoterInfo,

    /// 推廣列表
    this.agentMemberListSearchAll,
    this.agentMemberListFriend,
    this.agentMemberListPrimaryPromotor,
    this.agentMemberListAgent,

    this.agentSecondMemberList,
    this.agentSecondFriendList,
    this.agentRewardRatioList,

    this.isStrikeUpMateMode,
    this.userCallStatus,
    this.currentPage,
    this.isInChatroom,
    this.bannerInfo,
    this.missionInfo,
    this.notificationSearchList,
    this.notificationBlockGroup,
    this.notificationSearchIntimacyLevelInfo,
    this.contactSearchList,
    this.contactSearchForm,

    /// 動態牆
    this.activitySearchInfoCity,
    this.activitySearchInfoRecommend,
    this.activitySearchInfoSubscribe,
    this.activitySearchInfoPersonal,
    this.activitySearchInfoHotTopics,
    this.activitySearchInfoTopics,
    this.activitySearchInfoOthers,
    this.activityAllLikePostIdList,

    /// 首頁 與 汪遇頁面 推薦列表
    this.strikeUpListRecommendList,
    this.meetCardRecommendList,

    /// 首頁 在線列表
    this.strikeUpListOnlineList,

    this.depositNumberOption,

    this.checkInSearchList,
    this.visitorList,

    this.currentChatUser,

    this.buttonConfigList,
    this.myVisitorExpireTime,

    this.theme,
    this.orderComputeCondition,
    this.callTimer,
    this.isClosePersonalizedRecommendations,
  });
  WsGreetModuleListRes? greetModuleList;
  WsMemberInfoRes? memberInfo;

  WsAccountFollowAndFansListRes? followList;
  WsAccountFollowAndFansListRes? fansList;
  WsMemberPointCoinRes? memberPointCoin;
  WsSettingCharmAchievementRes? charmAchievement;

  /// 推廣中心-推廣列表
  WsAgentMemberListRes? agentMemberListSearchAll;
  WsAgentMemberListRes? agentMemberListFriend;
  WsAgentMemberListRes? agentMemberListPrimaryPromotor;
  WsAgentMemberListRes? agentMemberListAgent;

  /// 推廣中心-推廣列表 -> 下線詳細頁面
  WsAgentMemberListRes? agentSecondMemberList;
  WsAgentMemberListRes? agentSecondFriendList;

  WsAgentPromoterInfoRes? agentPromoterInfo;
  WsBannerInfoRes? bannerInfo;
  WsMissionSearchStatusRes? missionInfo;
  WsNotificationSearchListRes? notificationSearchList;
  WsNotificationBlockGroupRes? notificationBlockGroup;
  WsNotificationSearchIntimacyLevelInfoRes? notificationSearchIntimacyLevelInfo;
  WsContactSearchListRes? contactSearchList;
  WsContactSearchFormRes? contactSearchForm;

  /// 動態牆
  WsActivitySearchInfoRes? activitySearchInfoCity;
  WsActivitySearchInfoRes? activitySearchInfoRecommend;
  WsActivitySearchInfoRes? activitySearchInfoSubscribe;
  WsActivitySearchInfoRes? activitySearchInfoPersonal;
  WsActivitySearchInfoRes? activitySearchInfoHotTopics;
  WsActivitySearchInfoRes? activitySearchInfoTopics;
  WsActivitySearchInfoRes? activitySearchInfoOthers;

  /// 首頁 與 汪遇頁面 推薦列表
  WsMemberFateRecommendRes? strikeUpListRecommendList;
  WsMemberFateRecommendRes? meetCardRecommendList;

  WsMemberFateOnlineRes? strikeUpListOnlineList;

  List<dynamic>? activityAllLikePostIdList;


  WsCheckInSearchListRes? checkInSearchList;
  WsVisitorListRes? visitorList;
  WsAgentRewardRatioListRes? agentRewardRatioList;

  /// 充值列表
  WsDepositNumberOptionRes? depositNumberOption;

  String? phoneNumber;

  String? environment;

  String? commToken;
  /// login use
  String? loginData;

  /// userid for ws member info use
  num? userId;
  String? userName;
  String? nickName;

  String? jpushToken;
  String? rtmToken;
  String? rtcToken;
  String? phoneToken;
  String? deviceModel;

  String? inviteCode;
  num? unreadMesg;
  num? activityUnreadCount;

  UserCallStatus? userCallStatus;
  bool? isStrikeUpMateMode;
  bool? isClosePersonalizedRecommendations;

  /// 在哪個頁面
  /// 0: non,
  /// 1: 聊天室
  /// 2: 通話或語音頁面
  /// 3: 通話首充彈窗 4: 通話充值彈窗 5: 通話首充彈窗+充值彈窗 6: 亲密度弹窗
  int? currentPage;

  bool? isInChatroom;

  String? currentChatUser;

  ButtonConfigList? buttonConfigList;
  num? myVisitorExpireTime;

  AppTheme? theme;
  OrderComputeConditionInfo? orderComputeCondition;
  num? callTimer;

  /// 保留原本資料 new一個新記憶體空間(改變狀態用 for riverpods)
  UserInfoModel copyWith({
    WsGreetModuleListRes? greetModuleList,
    WsMemberInfoRes? memberInfo,
    WsAccountFollowAndFansListRes? followList,
    WsAccountFollowAndFansListRes? fansList,
    WsMemberPointCoinRes? memberPointCoin,
    WsSettingCharmAchievementRes? charmAchievement,

    /// 推廣列表
    WsAgentMemberListRes? agentMemberListSearchAll,
    WsAgentMemberListRes? agentMemberListFriend,
    WsAgentMemberListRes? agentMemberListPrimaryPromotor,
    WsAgentMemberListRes? agentMemberListAgent,

    WsAgentMemberListRes? agentSecondMemberList,
    WsAgentMemberListRes? agentSecondFriendList,

    /// 推薦列表
    WsMemberFateRecommendRes? strikeUpListRecommendList,
    WsMemberFateRecommendRes? meetCardRecommendList,

    /// 在線列表
    WsMemberFateOnlineRes? strikeUpListOnlineList,

    WsAgentPromoterInfoRes? agentPromoterInfo,
    WsBannerInfoRes? bannerInfo,
    WsMissionSearchStatusRes? missionInfo,
    WsNotificationSearchListRes? notificationSearchList,
    WsNotificationBlockGroupRes? notificationBlockGroup,
    WsNotificationSearchIntimacyLevelInfoRes? notificationSearchIntimacyLevelInfo,
    WsContactSearchListRes? contactSearchList,
    WsContactSearchFormRes? contactSearchForm,
    WsActivitySearchInfoRes? activitySearchInfoCity,
    WsActivitySearchInfoRes? activitySearchInfoRecommend,
    WsActivitySearchInfoRes? activitySearchInfoSubscribe,
    WsActivitySearchInfoRes? activitySearchInfoPersonal,
    WsActivitySearchInfoRes? activitySearchInfoHotTopics,
    WsActivitySearchInfoRes? activitySearchInfoTopics,
    WsActivitySearchInfoRes? activitySearchInfoOthers,
    List<dynamic>? activityAllLikePostIdList,
    WsCheckInSearchListRes? checkInSearchList,
    WsVisitorListRes? visitorList,
    WsAgentRewardRatioListRes? agentRewardRatioList,

    /// 充值列表
    WsDepositNumberOptionRes? depositNumberOption,

    String? environment,
    String? commToken,
    String? jpushToken,
    String? rtmToken,
    String? rtcToken,
    String? phoneToken,
    String? deviceModel,
    num? userId,
    String? loginData,
    String? userName,
    String? nickName,
    String? phoneNumber,
    String? inviteCode,
    num? unreadMesg,
    num? activityUnreadCount,
    bool? isStrikeUpMateMode,
    UserCallStatus? userCallStatus,
    int? currentPage,
    bool? isInChatroom,
    String? currentChatUser,
    List<ChatMessageModel>? unReadMsgList,

    /// config
    ButtonConfigList? buttonConfigList,
    num? myVisitorExpireTime,

    AppTheme? theme,
    OrderComputeConditionInfo? orderComputeCondition,
    num? callTimer,
    bool? isClosePersonalizedRecommendations,

    ZegoRoomStreamListUpdateEvent? zegoRoomStreamList,
  }) {
    return UserInfoModel(
      followList: followList ?? this.followList,
      fansList: fansList ?? this.fansList,
      memberPointCoin: memberPointCoin ?? this.memberPointCoin,
      greetModuleList: greetModuleList ?? this.greetModuleList,
      memberInfo: memberInfo ?? this.memberInfo,
      charmAchievement: charmAchievement ?? this.charmAchievement,
      agentPromoterInfo: agentPromoterInfo ?? this.agentPromoterInfo,

      /// 推廣列表
      agentMemberListSearchAll: agentMemberListSearchAll ?? this.agentMemberListSearchAll,
      agentMemberListFriend: agentMemberListFriend ?? this.agentMemberListFriend,
      agentMemberListPrimaryPromotor: agentMemberListPrimaryPromotor ?? this.agentMemberListPrimaryPromotor,
      agentMemberListAgent: agentMemberListAgent ?? this.agentMemberListAgent,

      agentSecondMemberList: agentSecondMemberList ?? this.agentSecondMemberList,
      agentSecondFriendList: agentSecondFriendList ?? this.agentSecondFriendList,

      /// 推薦列表
      strikeUpListRecommendList: strikeUpListRecommendList ?? this.strikeUpListRecommendList,
      meetCardRecommendList: meetCardRecommendList ?? this.meetCardRecommendList,

      /// 在線列表
      strikeUpListOnlineList: strikeUpListOnlineList ?? this.strikeUpListOnlineList,

      missionInfo: missionInfo ?? this.missionInfo,
      notificationSearchList: notificationSearchList ?? this.notificationSearchList,
      notificationBlockGroup: notificationBlockGroup ?? this.notificationBlockGroup,
      notificationSearchIntimacyLevelInfo: notificationSearchIntimacyLevelInfo ?? this.notificationSearchIntimacyLevelInfo,
      contactSearchList: contactSearchList ?? this.contactSearchList,
      contactSearchForm: contactSearchForm ?? this.contactSearchForm,
      activitySearchInfoCity: activitySearchInfoCity ?? this.activitySearchInfoCity,
      activitySearchInfoRecommend: activitySearchInfoRecommend ?? this.activitySearchInfoRecommend,
      activitySearchInfoSubscribe: activitySearchInfoSubscribe ?? this.activitySearchInfoSubscribe,
      activitySearchInfoPersonal: activitySearchInfoPersonal ?? this.activitySearchInfoPersonal,
      activitySearchInfoHotTopics: activitySearchInfoHotTopics ?? this.activitySearchInfoHotTopics,
      activitySearchInfoTopics: activitySearchInfoTopics ?? this.activitySearchInfoTopics,
      activitySearchInfoOthers: activitySearchInfoOthers ?? this.activitySearchInfoOthers,
      activityAllLikePostIdList: activityAllLikePostIdList ?? this.activityAllLikePostIdList,

      checkInSearchList: checkInSearchList ?? this.checkInSearchList,
      visitorList: visitorList ?? this.visitorList,
      agentRewardRatioList: agentRewardRatioList ?? this.agentRewardRatioList,

      depositNumberOption: depositNumberOption ?? this.depositNumberOption,

      environment: environment ?? this.environment,
      commToken: commToken ?? this.commToken,
      jpushToken: jpushToken ?? this.jpushToken,
      rtmToken: rtmToken ?? this.rtmToken,
      rtcToken: rtcToken ?? this.rtcToken,
      phoneToken: phoneToken ?? this.phoneToken,
      deviceModel: deviceModel ?? this.deviceModel,
      userId: userId ?? this.userId,
      loginData: loginData?? this.loginData,
      userName: userName ?? this.userName,
      nickName: nickName ?? this.nickName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      inviteCode: inviteCode ?? this.inviteCode,
      unreadMesg: unreadMesg ?? this.unreadMesg,
      activityUnreadCount: activityUnreadCount ?? this.activityUnreadCount,
      isStrikeUpMateMode: isStrikeUpMateMode ?? this.isStrikeUpMateMode,
      userCallStatus: userCallStatus ?? this.userCallStatus,
      currentPage: currentPage ?? this.currentPage,
      isInChatroom: isInChatroom ?? this.isInChatroom,
      bannerInfo: bannerInfo ?? this.bannerInfo,
      currentChatUser: currentChatUser ?? this.currentChatUser,
      buttonConfigList: buttonConfigList ?? this.buttonConfigList,
      myVisitorExpireTime: myVisitorExpireTime ?? this.myVisitorExpireTime,

      theme: theme ?? this.theme,
      orderComputeCondition: orderComputeCondition ?? this.orderComputeCondition,
      callTimer: callTimer ?? this.callTimer,
      isClosePersonalizedRecommendations: isClosePersonalizedRecommendations ?? this.isClosePersonalizedRecommendations,
    );
  }
}