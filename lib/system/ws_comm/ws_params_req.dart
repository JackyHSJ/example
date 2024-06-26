import 'package:frechat/models/ws_req/ws_base_req.dart';

mixin WsParamsReq {
  /// repeat login
  static WsBaseReq get repeatLogin =>
      WsBaseReq.create(f: '998', tId: '', msg: '');

  /// check
  static WsBaseReq get handshake => WsBaseReq.create(f: '0', tId: '', msg: '');

  /// contact
  static WsBaseReq get contactSearchList =>
      WsBaseReq.create(f: '1-1', tId: '', msg: '');
  static WsBaseReq get contactSearchForm =>
      WsBaseReq.create(f: '1-2', tId: '', msg: '');
  static WsBaseReq get contactSearchFriendBenefit =>
      WsBaseReq.create(f: '1-3', tId: '', msg: '');
  static WsBaseReq get contactInviteFriend =>
      WsBaseReq.create(f: '1-4', tId: '', msg: '');
  /// member
  static WsBaseReq get memberApplyCancel =>
      WsBaseReq.create(f: '2-1', tId: '', msg: '');
  static WsBaseReq get memberInfo =>
      WsBaseReq.create(f: '2-2', tId: '', msg: '');
  static WsBaseReq get memberFateRecommend =>
      WsBaseReq.create(f: '2-3', tId: '', msg: '');
  static WsBaseReq get memberFateOnline =>
      WsBaseReq.create(f: '2-4', tId: '', msg: '');
  static WsBaseReq get memberRealPersonVeri =>
      WsBaseReq.create(f: '2-5', tId: '', msg: '');
  static WsBaseReq get memberDeleteAlbumPhoto =>
      WsBaseReq.create(f: '2-6', tId: '', msg: '');
  static WsBaseReq get memberMoveAlbumPhoto =>
      WsBaseReq.create(f: '2-7', tId: '', msg: '');

  static WsBaseReq get memberPointCoinInfo =>
      WsBaseReq.create(f: '2-8', tId: '', msg: '');
  static WsBaseReq get memberTeenStatus =>
      WsBaseReq.create(f: '2-9', tId: '', msg: '');
  static WsBaseReq get memberEnableTeen =>
      WsBaseReq.create(f: '2-10', tId: '', msg: '');
  static WsBaseReq get memberDisableTeen =>
      WsBaseReq.create(f: '2-11', tId: '', msg: '');
  static WsBaseReq get memberTeenForgetPassword =>
      WsBaseReq.create(f: '2-12', tId: '', msg: '');
  static WsBaseReq get memberRealNameAuth =>
      WsBaseReq.create(f: '2-13', tId: '', msg: '');
  static WsBaseReq get memberNewUserToTopList =>
      WsBaseReq.create(f: '2-14', tId: '', msg: '');

  /// account interact
  static WsBaseReq get accountSpeak =>
      WsBaseReq.create(f: '3-1', tId: '', msg: '');
  static WsBaseReq get accountOnTV =>
      WsBaseReq.create(f: '3-2', tId: '', msg: '');
  static WsBaseReq get accountShumeiViolate =>
      WsBaseReq.create(f: '3-4', tId: '', msg: '');
  static WsBaseReq get accountIntimacyLevelUp =>
      WsBaseReq.create(f: '3-5', tId: '', msg: '');

  static WsBaseReq get accountGetGiftType =>
      WsBaseReq.create(f: '3-90', tId: '', msg: '');
  static WsBaseReq get accountGetGiftDetail =>
      WsBaseReq.create(f: '3-91', tId: '', msg: '');
  static WsBaseReq get accountUpdatePackageGift =>
      WsBaseReq.create(f: '3-92', tId: '', msg: '');
  static WsBaseReq get accountCallPackage =>
      WsBaseReq.create(f: '3-93', tId: '', msg: '');

  static WsBaseReq get accountQuickMatchList =>
      WsBaseReq.create(f: '3-94', tId: '', msg: '');
  static WsBaseReq get accountCallCharge =>
      WsBaseReq.create(f: '3-95', tId: '', msg: '');
  static WsBaseReq get accountCallVerification =>
      WsBaseReq.create(f: '3-96', tId: '', msg: '');
  static WsBaseReq get accountEndCall =>
      WsBaseReq.create(f: '3-97', tId: '', msg: '');
  static WsBaseReq get accountGetRTMToken =>
      WsBaseReq.create(f: '3-98', tId: '', msg: '');
  static WsBaseReq get accountGetRTCToken =>
      WsBaseReq.create(f: '3-99', tId: '', msg: '');

  static WsBaseReq get accountRemark =>
      WsBaseReq.create(f: '5-1', tId: '', msg: '');
  static WsBaseReq get accountFollow =>
      WsBaseReq.create(f: '5-2', tId: '', msg: '');
  static WsBaseReq get accountFollowAndFansList =>
      WsBaseReq.create(f: '5-3', tId: '', msg: '');

  /// notification list
  static WsBaseReq get notificationSearchList =>
      WsBaseReq.create(f: '4-1', tId: '', msg: '');
  static WsBaseReq get notificationStrikeUp =>
      WsBaseReq.create(f: '4-2', tId: '', msg: '');
  static WsBaseReq get notificationLeaveGroupBlock =>
      WsBaseReq.create(f: '4-3', tId: '', msg: '');
  static WsBaseReq get notificationBlockGroup =>
      WsBaseReq.create(f: '4-4', tId: '', msg: '');
  static WsBaseReq get notificationPressBtnAndRemoveBlackAccount =>
      WsBaseReq.create(f: '4-5', tId: '', msg: '');
  static WsBaseReq get notificationSearchIntimacyLevelInfo =>
      WsBaseReq.create(f: '4-6', tId: '', msg: '');
  static WsBaseReq get notificationSearchInfoWithType =>
      WsBaseReq.create(f: '4-7', tId: '', msg: '');
  static WsBaseReq get notificationSearchOnlineStatus =>
      WsBaseReq.create(f: '4-8', tId: '', msg: '');

  /// report
  static WsBaseReq get reportSearchType =>
      WsBaseReq.create(f: '6-1', tId: '', msg: '');

  /// detail
  static WsBaseReq get detailSearchListCoin =>
      WsBaseReq.create(f: '7-1', tId: '', msg: '');
  static WsBaseReq get detailSearchListIncome =>
      WsBaseReq.create(f: '7-2', tId: '', msg: '');

  /// deposit
  static WsBaseReq get depositMoney =>
      WsBaseReq.create(f: '8-1', tId: '', msg: '');
  static WsBaseReq get depositNumberOption =>
      WsBaseReq.create(f: '8-2', tId: '', msg: '');
  static WsBaseReq get depositAliPayReplyError =>
      WsBaseReq.create(f: '8-3', tId: '', msg: '');
  static WsBaseReq get depositAppleReplyReceipt =>
      WsBaseReq.create(f: '8-4', tId: '', msg: '');
  static WsBaseReq get depositWeChatPaySign =>
      WsBaseReq.create(f: '8-5', tId: '', msg: '');

  /// withdraw
  static WsBaseReq get withdrawMoney =>
      WsBaseReq.create(f: '9-1', tId: '', msg: '');
  static WsBaseReq get withdrawSearchRecord =>
      WsBaseReq.create(f: '9-2', tId: '', msg: '');
  static WsBaseReq get withdrawMemberIncome =>
      WsBaseReq.create(f: '9-3', tId: '', msg: '');
  static WsBaseReq get withdrawMemberPointToCoin =>
      WsBaseReq.create(f: '9-4', tId: '', msg: '');
  static WsBaseReq get withdrawCloudAgreement =>
      WsBaseReq.create(f: '9-5', tId: '', msg: '');
  static WsBaseReq get withdrawSearchPayment =>
      WsBaseReq.create(f: '9-6', tId: '', msg: '');
  static WsBaseReq get withdrawSaveAlipay =>
      WsBaseReq.create(f: '9-7', tId: '', msg: '');
  static WsBaseReq get withdrawRechargeReward =>
      WsBaseReq.create(f: '9-8', tId: '', msg: '');

  /// greet
  static WsBaseReq get greetModuleList =>
      WsBaseReq.create(f: '10-1', tId: '', msg: '');
  static WsBaseReq get greetModuleDelete =>
      WsBaseReq.create(f: '10-2', tId: '', msg: '');
  static WsBaseReq get greetModuleEditRemark =>
      WsBaseReq.create(f: '10-3', tId: '', msg: '');
  static WsBaseReq get greetModuleUse =>
      WsBaseReq.create(f: '10-4', tId: '', msg: '');

  /// Charging and Charm Value Settings
  static WsBaseReq get settingCharge =>
      WsBaseReq.create(f: '13-1', tId: '', msg: '');
  static WsBaseReq get settingCharmAchievement =>
      WsBaseReq.create(f: '13-2', tId: '', msg: '');

  /// Check In
  static WsBaseReq get checkIn => WsBaseReq.create(f: '14-1', tId: '', msg: '');
  static WsBaseReq get checkInSearchList =>
      WsBaseReq.create(f: '14-2', tId: '', msg: '');

  /// Mission
  static WsBaseReq get missionSearchStatus =>
      WsBaseReq.create(f: '15-1', tId: '', msg: '');
  static WsBaseReq get missionGetAward =>
      WsBaseReq.create(f: '15-2', tId: '', msg: '');

  /// Agent
  static WsBaseReq get agentMemberList =>
      WsBaseReq.create(f: '16-1', tId: '', msg: '');
  static WsBaseReq get agentPromoterInfo =>
      WsBaseReq.create(f: '16-2', tId: '', msg: '');
  static WsBaseReq get agentSecondMemberList =>
      WsBaseReq.create(f: '16-3', tId: '', msg: '');
  static WsBaseReq get agentThirdMemberList =>
      WsBaseReq.create(f: '16-4', tId: '', msg: '');
  static WsBaseReq get agentSecondFriendList =>
      WsBaseReq.create(f: '16-5', tId: '', msg: '');
  static WsBaseReq get agentRewardRatioList =>
      WsBaseReq.create(f: '16-6', tId: '', msg: '');

  /// benefit
  static WsBaseReq get benefitInfo =>
      WsBaseReq.create(f: '17-1', tId: '', msg: '');

  /// Banner
  static WsBaseReq get bannerInfo =>
      WsBaseReq.create(f: '18-1', tId: '', msg: '');

  static WsBaseReq get customerServiceHours =>
      WsBaseReq.create(f: '18-3', tId: '', msg: '');

  /// Activity Wall
  static WsBaseReq get activitySearchInfo =>
      WsBaseReq.create(f: '19-1', tId: '', msg: '');

  static WsBaseReq get activitySearchReplyInfo =>
      WsBaseReq.create(f: '19-2', tId: '', msg: '');

  static WsBaseReq get activityAddReply =>
      WsBaseReq.create(f: '19-3', tId: '', msg: '');

  static WsBaseReq get activityDelete =>
      WsBaseReq.create(f: '19-4', tId: '', msg: '');

  static WsBaseReq get activityHotTopicList =>
      WsBaseReq.create(f: '19-5', tId: '', msg: '');

  static WsBaseReq get activityDeleteReply =>
      WsBaseReq.create(f: '19-6', tId: '', msg: '');

  static WsBaseReq get activityDonatePost =>
      WsBaseReq.create(f: '19-7', tId: '', msg: '');

  /// Post like
  static WsBaseReq get postAddLike =>
      WsBaseReq.create(f: '20-1', tId: '', msg: '');

  static WsBaseReq get postReturnLike =>
      WsBaseReq.create(f: '20-2', tId: '', msg: '');

  ///visitor
  static WsBaseReq get visitorList =>
      WsBaseReq.create(f: '22-1', tId: '', msg: '');
}
