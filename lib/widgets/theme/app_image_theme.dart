

import 'dart:ui';

import 'package:frechat/widgets/theme/original/app_colors.dart';

class AppImageTheme {
  AppImageTheme({
    required this.splashBg,
    required this.logingBg,
    required this.phoneLoginBg,
    required this.iconBack,
    required this.iconPhone,
    required this.iconVerificationCode,
    required this.personalTabHome,
    required this.personalTabBackground,
    required this.profileContactCoinOrangeIcon,
    required this.profileDepositWalletBtnIcon,
    required this.profileBenefitWalletBtnIcon,
    required this.friendEmptyBanner,
    required this.strikeUp,
    required this.strikeUpLight,
    required this.messenger,
    required this.messengerUnread,
    required this.messengerLight,
    required this.messengerLightUnread,
    required this.profile,
    required this.profileLight,
    required this.imageMessageEmpty,
    required this.imageCohesionEmpty,
    required this.imageCallEmpty,
    required this.imageVisitorEmpty,
    required this.missionBgIcon,
    required this.missionCoinIcon,
    required this.iconRightArrow,
    required this.appIcon,
    required this.javaSystemIcon,

    // Chris
    required this.imageContactEmpty,
    required this.imageDetailEmpty,
    required this.iconCoin,
    required this.iconStrikeUpUnselect,
    required this.iconStrikeUpSelected,
    required this.iconActivityUnselect,
    required this.iconActivitySelected,
    required this.iconVideoUnselect,
    required this.iconVideoSelected,
    required this.iconMessageUnselect,
    required this.iconMessageSelected,
    required this.iconProfileUnselect,
    required this.iconProfileSelected,
    required this.iconAppSmall,
    required this.iconTagRealPerson,
    required this.iconTagRealName,
    required this.imgHowToTVBanner,
    required this.imgHowToTVTitle,
    required this.imgHowToTVHeadline,
    required this.iconUserInfoViewAudioPlay,
    required this.iconUserInfoViewAudioPause,
    required this.iconPersonalProfileEdit,
    required this.iconAddFile,
    required this.iconAgreeCheck,
    required this.iconAgreeUncheck,
    required this.iconAudioRecording,
    required this.iconAudioRecord,
    required this.iconCopy,

    ///josh
    required this.teenSettingDialogImage,
    required this.teenSettingOpenImage,
    required this.teenSettingCloseImage,
    required this.teenSettingInputImage,
    required this.versionUpdateBackgroundImage,
    required this.registerAvatarDefault,
    required this.registerAvatarDefaultMale,
    required this.registerAvatarDefaultFemale,
    required this.howToTv,
    required this.howToTvArrow,
    required this.howToTvTitleNumberOne,
    required this.howToTvTitleNumberTwo,
    required this.howToTvTitleWantOnTV,
    required this.howToTvTitleAnonymous,
    required this.pullLoaderRefreshIcon,
    required this.pullLoaderFetchMoreIcon,
    required this.pullLoaderLoadingIcon,
    required this.strikeUpListSearchEmpty,
    required this.certificationStatusIcon,
    required this.basicInformationIcon,
    required this.recentPhotosIcon,
    required this.missionCompleteImage,
    required this.checkBoxTrueIcon,
    required this.checkBoxFalseIcon,
    required this.profileBenefitBtnIcon,
    required this.bottomSheetCancelBtnIcon,
    required this.chatroomIconCollapse,
    required this.chatroomIconExpand,
    required this.firstRechargeImage,
    required this.iconCancel,
    required this.iconActivityPostImage,
    required this.iconActivityPostVideo,
    required this.iconActivityPostHint,
    required this.iconActivityPostLocation,
    required this.iconActivityPostCancel,
    required this.iconActivityVideoPlaySmall,
    required this.iconActivityVideoPlayLarge,
    required this.iconActivityVideoPauseSmall,
    required this.iconActivityVideoPauseLarge,
    required this.iconActivityMore,
    required this.iconActivityPostTypePhoto,
    required this.iconActivityPostTypeVideo,
    required this.iconActivityNotification,
    required this.iconActivityNotificationUnread,
    required this.iconActivityPostButton,
    required this.chatroomIconSend,
    required this.chatroomIconMicNotRecording,
    required this.chatroomIconMicReadyToRecord,
    required this.chatroomIconMicRecording,
    required this.chatroomIconMicRecordingCompleted,
    required this.iconActivityPostDonate,
    required this.iconActivityPostLike,
    required this.iconActivityPostAlreadyLike,
    required this.iconActivityPostMessage,
    required this.imageActivityEmpty,
    required this.iconActivityArrowForward,
    required this.intimacyButtonCancel,
    required this.iconPersonalCertificationPhone,
    required this.iconPersonalCertificationPersonal,
    required this.iconPersonalCertificationName,
    required this.iconPersonalCertificationHint,
    required this.defaultFemaleAvatar,
    required this.defaultMaleAvatar,
    required this.iconKBArrowUp,
    required this.iconKBArrowDown,
    required this.iconOnlineService,
    required this.iconMaleSelected,
    required this.iconMaleUnSelect,
    required this.iconFemaleSelected,
    required this.iconFemaleUnSelect,
    required this.strikeUpVoiceMateBackgroundImage,
    required this.strikeUpVideoMateBackgroundImage,
    required this.strikeUpMateSearchBackgroundImage,
    required this.strikeUpVoiceMateImage,
    required this.strikeUpVideoMateImage,
    required this.disabledPersonalizedSettingImage,
    required this.iconTagRealNameAuth,
    required this.iconTagRealPersonAuth,
    required this.iconCallingFree,
    required this.iconOnline,
    required this.iconVip,
    required this.reportPageTitleIcon,
    required this.promotionCenterIconlink,
    required this.promotionCenterIconQrcode,
    required this.promotionCenterIconWechatFreind,
    required this.promotionCenterIconWechatMoments,
    required this.iconChat,
    required this.iconStrikeUp,
    required this.iconPinTop,
    required this.iconPoints,
    required this.iconExchange,
    required this.wechatShareAppIcon,
    required this.imgBlockEmptyBanner,
    required this.iconProfileAgentIncome,
    required this.iconProfileAgentText,
    required this.iconProfileAgentGift,
    required this.iconProfileAgentCallVoice,
    required this.iconProfileAgentCallVideo,
    required this.iconProfileAgentStrikeUp,
    required this.iconProfileAgentActivityDonate,
    required this.iconProfileAgentCopy,
    required this.iconProfileAgentWallet,
    required this.iconProfileAgentTime,
    required this.iconProfileAgentHeart,
    required this.iconProfileAgentMedalStar,
    required this.iconProfileAgentHelp,
    required this.imageProfileContactTodayItem,
    required this.imageProfileContactWeekItem,
    required this.imageProfileContactLastWeekItem,
    required this.iconEditPrices,
    required this.imagePersonalGreetEmpty,
    required this.iconPersonalGreetPin,
    required this.iconPersonalGreetUse,
    required this.iconPersonalGreetReview,
    required this.iconPersonalGreetReviewFail,
    required this.iconPersonalGreetEdit,
    required this.imagePersonalGreetVoice,
    required this.iconRealtimeDepositActivate,
    required this.iconRealtimeDepositDeactivate,
    required this.iconBenefitCloudCheckActivate,
    required this.iconBenefitCloudCheckDeactivate,
    required this.imgEmptyBookkeepingBanner,
    required this.iconClose,
    required this.iconCalendar,
    required this.iconChatMessageSending,
    required this.iconChatMessageResend,
    required this.iconChatMessageError,
    required this.iconChatMessageReviewWarning,
    required this.imgInviteFriendBanner,
    required this.firstRechargeBanner,
    required this.iconProfileRealPersonAuthError,
    required this.iconCallOpposite,
    required this.iconCallPersonal,
    required this.iconVideoOpposite,
    required this.iconVideoPersonal,
    required this.iconCallCancelOpposite,
    required this.iconCallCancelPersonal,
    required this.iconVideoCancelOpposite,
    required this.iconVideoCancelPersonal,
  });

  final String splashBg;
  final String logingBg;
  final String phoneLoginBg;
  final String iconBack;
  final String iconPhone;
  final String iconVerificationCode;
  final String personalTabHome;
  final String personalTabBackground;
  final String profileContactCoinOrangeIcon;
  final String profileDepositWalletBtnIcon;
  final String profileBenefitWalletBtnIcon;
  final String friendEmptyBanner;
  final String strikeUp;
  final String strikeUpLight;
  final String messenger;
  final String messengerUnread;
  final String messengerLight;
  final String messengerLightUnread;
  final String profile;
  final String profileLight;
  final String imageMessageEmpty;
  final String imageCohesionEmpty;
  final String imageCallEmpty;
  final String imageVisitorEmpty;
  final String missionBgIcon;
  final String missionCoinIcon;
  final String iconRightArrow;
  final String appIcon;

  // Chris
  final String imageContactEmpty;
  final String imageDetailEmpty;
  final String iconCoin;
  final String iconStrikeUpUnselect;
  final String iconStrikeUpSelected;
  final String iconActivityUnselect;
  final String iconActivitySelected;
  final String iconVideoUnselect;
  final String iconVideoSelected;
  final String iconMessageUnselect;
  final String iconMessageSelected;
  final String iconProfileUnselect;
  final String iconProfileSelected;
  final String iconAppSmall;
  final String iconTagRealPerson;
  final String iconTagRealName;
  final String imgHowToTVBanner;
  final String imgHowToTVTitle;
  final String imgHowToTVHeadline;
  final String iconUserInfoViewAudioPlay;
  final String iconUserInfoViewAudioPause;
  final String iconPersonalProfileEdit;
  final String iconAddFile;
  final String iconAgreeCheck;
  final String iconAgreeUncheck;
  final String iconAudioRecording;
  final String iconAudioRecord;
  final String iconCopy;


  /// josh
  final String teenSettingDialogImage;
  final String teenSettingOpenImage;
  final String teenSettingCloseImage;
  final String teenSettingInputImage;
  final String versionUpdateBackgroundImage;
  final String registerAvatarDefault;
  final String registerAvatarDefaultMale;
  final String registerAvatarDefaultFemale;
  final String howToTv;
  final String howToTvArrow;
  final String howToTvTitleWantOnTV;
  final String howToTvTitleAnonymous;
  final String howToTvTitleNumberOne;
  final String howToTvTitleNumberTwo;
  final String pullLoaderRefreshIcon;
  final String pullLoaderFetchMoreIcon;
  final String pullLoaderLoadingIcon;
  final String strikeUpListSearchEmpty;
  final String javaSystemIcon;
  final String certificationStatusIcon;
  final String basicInformationIcon;
  final String recentPhotosIcon;
  final String missionCompleteImage;
  final String checkBoxTrueIcon;
  final String checkBoxFalseIcon;
  final String profileBenefitBtnIcon;
  final String bottomSheetCancelBtnIcon;
  final String chatroomIconCollapse;
  final String chatroomIconExpand;

  final String firstRechargeImage;
  final String iconCancel;
  final String iconActivityPostImage ;
  final String iconActivityPostVideo;
  final String iconActivityPostHint ;
  final String iconActivityPostLocation ;
  final String iconActivityPostCancel;
  final String iconActivityVideoPlaySmall;
  final String iconActivityVideoPlayLarge;
  final String iconActivityVideoPauseSmall;
  final String iconActivityVideoPauseLarge;
  final String iconActivityMore;
  final String iconActivityPostTypePhoto;
  final String iconActivityPostTypeVideo;
  final String iconActivityNotification;
  final String iconActivityNotificationUnread;
  final String iconActivityPostButton;
  final String chatroomIconSend;
  final String chatroomIconMicNotRecording;
  final String chatroomIconMicReadyToRecord;
  final String chatroomIconMicRecording;
  final String chatroomIconMicRecordingCompleted;
  final String iconActivityPostDonate;
  final String iconActivityPostLike;
  final String iconActivityPostAlreadyLike;
  final String iconActivityPostMessage;
  final String imageActivityEmpty;
  final String iconActivityArrowForward;
  final String intimacyButtonCancel;
  final String iconPersonalCertificationPhone;
  final String iconPersonalCertificationPersonal;
  final String iconPersonalCertificationName;
  final String iconPersonalCertificationHint;
  final String defaultFemaleAvatar;
  final String defaultMaleAvatar;
  final String iconKBArrowUp;
  final String iconKBArrowDown;
  final String iconOnlineService;
  final String iconMaleSelected;
  final String iconMaleUnSelect;
  final String iconFemaleSelected;
  final String iconFemaleUnSelect;

  final String strikeUpVoiceMateBackgroundImage;
  final String strikeUpVideoMateBackgroundImage;
  final String strikeUpMateSearchBackgroundImage;
  final String strikeUpVoiceMateImage;
  final String strikeUpVideoMateImage;

  final String disabledPersonalizedSettingImage;
  final String iconTagRealNameAuth;
  final String iconTagRealPersonAuth;
  final String iconCallingFree;
  final String iconOnline;
  final String iconVip;
  final String reportPageTitleIcon;
  final String promotionCenterIconlink;
  final String promotionCenterIconQrcode;
  final String promotionCenterIconWechatFreind;
  final String promotionCenterIconWechatMoments;
  final String iconChat;
  final String iconStrikeUp;
  final String iconPinTop;
  final String iconPoints;
  final String iconExchange;
  final String wechatShareAppIcon;
  final String imgBlockEmptyBanner;
  final String iconProfileAgentIncome;
  final String iconProfileAgentText;
  final String iconProfileAgentGift;
  final String iconProfileAgentCallVoice;
  final String iconProfileAgentCallVideo;
  final String iconProfileAgentStrikeUp;
  final String iconProfileAgentActivityDonate;
  final String iconProfileAgentCopy;
  final String iconProfileAgentWallet;
  final String iconProfileAgentTime;
  final String iconProfileAgentHeart;
  final String iconProfileAgentMedalStar;
  final String iconProfileAgentHelp;
  final String imageProfileContactTodayItem;
  final String imageProfileContactWeekItem;
  final String imageProfileContactLastWeekItem;
  final String iconEditPrices;
  final String imagePersonalGreetEmpty;
  final String iconPersonalGreetPin;
  final String iconPersonalGreetUse;
  final String iconPersonalGreetReview;
  final String iconPersonalGreetReviewFail;
  final String iconPersonalGreetEdit;
  final String imagePersonalGreetVoice;
  final String iconRealtimeDepositActivate;
  final String iconRealtimeDepositDeactivate;
  final String iconBenefitCloudCheckActivate;
  final String iconBenefitCloudCheckDeactivate;
  final String imgEmptyBookkeepingBanner;
  final String iconClose;
  final String iconCalendar;
  final String iconChatMessageSending;
  final String iconChatMessageResend;
  final String iconChatMessageError;
  final String iconChatMessageReviewWarning;
  final String imgInviteFriendBanner;
  final String firstRechargeBanner;
  final String iconProfileRealPersonAuthError;
  final String iconCallOpposite;
  final String iconCallPersonal;
  final String iconVideoOpposite;
  final String iconVideoPersonal;
  final String iconCallCancelOpposite;
  final String iconCallCancelPersonal;
  final String iconVideoCancelOpposite;
  final String iconVideoCancelPersonal;
}