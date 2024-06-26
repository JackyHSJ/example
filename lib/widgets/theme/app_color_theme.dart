

import 'dart:ui';

import 'package:frechat/widgets/theme/original/app_colors.dart';

class AppColorTheme {
  AppColorTheme({
    required this.primaryColor,
    required this.dialogBackgroundColor,
    required this.appBarBackgroundColor,
    required this.modifyDataButtonColor,
    required this.tabBarBackgroundColor,
    required this.bottomNavigationBarColor,
    required this.missionAppBarBgColor,
    required this.marqueeBackgroundColor,
    required this.marqueeImageColor,
    required this.baseBackgroundColor,
    required this.switchInactiveColor,
    required this.switchActiveColor,
    required this.chatRoomBottomBackgroundColor,
    required this.chatRoomFunctionIconColor,
    required this.personalSettingAboutBorder,
    required this.globalBackgroundColor,
    required this.progressbarLineColors,
    required this.progressbarIndicatorColors,
    required this.tagTextColors,
    required this.tagBackgroundColor,
    required this.personalPercentTextColor,
    required this.personalAudioColor,
    required this.benefitAppBarColor,
    required this.benefitActiveBtnColor,
    required this.benefitUnActiveBtnColor,
    required this.benefitActiveTextColor,
    required this.benefitUnActiveTextColor,
    required this.myBubbleBackgroundColor,
    required this.otherSideBubbleBackgroundColor,
    required this.textFieldBackgroundColor,
    required this.textFieldBorderColor,
    required this.textFieldFontColor,
    required this.editAudioBeginRecordTitleColor,
    required this.editAudioBeginRecordHintColor,
    required this.editAudioBeginRecordTimeColor,
    required this.editAudioBeginRecordUnRecordIconColor,
    required this.editAudioBeginRecordRecordIconColor,
    required this.editAudioBeginRecordUnRecordBackgroundColor,
    required this.editAudioBeginRecordRecordBackgroundColor,
    required this.editAudioBeginRecordIconProgressBordColor,
    required this.editAudioBeginRecordBackgroundColor,
    required this.editAudioBeginRecordBordColor,
    required this.editAudiodTitleColor,
    required this.editAudiodTextFieldBackgroundColor,
    required this.editAudiodTextFieldHintColor,
    required this.myTagColor,
    required this.myTagTextColor,
    required this.versionUpdateBackgroundColor,
    required this.textFieldFocusingColor,
    required this.howToTVUnderLineColor,
    required this.tabBarIndicatorColor,
    required this.homeTabBarColor,
    required this.homeTabBarUnSelect,
    required this.homeTabBarStrikeUpSelected,
    required this.homeTabBarActivitySelected,
    required this.homeTabBarVideoSelected,
    required this.homeTabBarMessageSelected,
    required this.homeTabBarProfileSelected,
    required this.descriptionTextColor,
    required this.verifyCodeTextColor,
    required this.inputFieldColor,
    required this.strikeupSearchTextFieldSearchBtnColor,
    required this.dividerColor,
    required this.tvMainTextColor,
    required this.tvSubTextColor,
    required this.tvTitleBgColor,
    required this.tvTitleTextColor,
    required this.tvTableBgColor,
    required this.userInfoViewNavigatorBgColor,
    required this.hintPillsTextColor,
    required this.chatroomInformationBackGroundColor,
    required this.iconFriendsettingColor,
    required this.awardBgColor,
    required this.bottomSheetBackgroundColor,
    required this.checkedInBgColor,
    required this.notCheckInBgColor,
    required this.checkInBtnTextColor,
    required this.checkInTitleTextColor,
    required this.personalProfilePrimaryTextColor,
    required this.personalProfileSecondaryTextColor,
    required this.commonLanguageAddIconColor,
    required this.commonLanguageCustomDeleteIconColor,
    required this.freindSettingPageItemBackGroundColor,
    required this.friendEmptyPrimaryTextColor,
    required this.friendEmptySecondaryTextColor,
    required this.visitorEmptyPrimaryTextColor,
    required this.visitorEmptySecondaryTextColor,
    required this.tabBarBgColor,
    required this.tabBarIndicatorBgColor,
    required this.tabBarSelectTextColor,
    required this.tabBarUnSelectTextColor,
    required this.friendPrimaryTextColor,
    required this.friendSecondaryTextColor,
    required this.visitorPrimaryTextColor,
    required this.visitorSecondaryTextColor,
    required this.visitorSeenTextColor,

    required this.goToTextColor,
    required this.receiveTextColor,
    required this.completedTextColor,
    required this.missionTitleTextColor,
    required this.missionPrimaryTextColor,
    required this.missionSecondaryTextColor,
    required this.btnConfirmTextColor,
    required this.btnCancelTextColor,
    required this.btnDisableTextColor,
    required this.chatroomTextFieldBackGroundColor,
    required this.chatroomTextFieldFontColor,
    required this.freindSettingPageItemBorderColor,
    required this.giftAndBagMainColor,
    required this.intimacyRuleContentBorderColor,
    required this.intimacyWidgetBackGroundColor,
    required this.intimacyRuleContentTitleTextColor,
    required this.activityPostCellSeparatorLineColor,
    required this.activityPostInputBackgroundColor,
    required this.intimacyDialogCurrentIntimacyTextColor,
    required this.intimacyDialogDifferenceInIntimacyTextColor,
    required this.intimacyDialogNextStageOfRelationshipTextColor,
    required this.iconIntimacyCheckColor,
    required this.iconIntimacyLockColor,
    required this.intimacyStepsLineColor,
    required this.intimacyStepsTagBackGroundColor,
    required this.messageTabActionColor,
    required this.personalCertifiedTextColor,
    required this.personalUncertifiedTextColor,
    required this.personalProcessCertificationTextColor,
    required this.personalProcessCertificationHintBgColor,
    required this.personalProcessCertificationHintTextColor,
    required this.customServicePrimaryTextColor,
    required this.customServiceSecondaryTextColor,
    required this.customServiceAppbarColor,
    required this.customServiceBgColor,
    required this.registerGenderSelectTextColor,
    required this.registerGenderUnSelectTextColor,
    required this.commonButtonContentBackGroundColor,
    required this.commonButtonCancelBackGroundColor,
    required this.reportPageTextColor,
    required this.reportPageAddImageBorderColor,
    required this.reportPageAddImageBackgroundColor,
    required this.reportTextFieldBorderColor,
    required this.userInfoViewCellTitleTextColor,
    required this.userInfoViewCellPrimaryTextColor,
    required this.userInfoViewCellSecondaryTextColor,
    required this.userInfoViewCellNameTextColor,
    required this.tagColorList,
    required this.promotionCenterChannelButtonBackgroundColor,
    required this.userInfoViewEditTextColor,
    required this.commonButtonDeleteTextColor,
    required this.blockBannerPrimaryTextColor,
    required this.blockBannerSecondaryTextColor,
    required this.teenBannerPrimaryTextColor,
    required this.teenBannerSecondaryTextColor,
    required this.benefitPrimaryTextColor,
    required this.benefitSecondaryTextColor,
    required this.benefitInfoTextColor,
    required this.benefitLinkTextColor,
    required this.pickerDialogBackgroundColor,
    required this.pickerDialogIconColor,
    required this.charmLevelTagBackgroundColor,
    required this.charmLevelTableTitleBackgroundColor,
    required this.charmLevelTableBackgroundColor,
    required this.charmLevelTableLineColor,
    required this.pickerTextColor,
    required this.withdrawAccountBindPrimaryTextColor,
    required this.withdrawAccountBindSecondaryTextColor,
    required this.withdrawAccountBindLinkTextColor,
    required this.withdrawAccountBindBoxColor,
    required this.personalGreetModelPlayButtonColor,
    required this.personalGreetAddRecordColor,
    required this.personalGreetAddRecordTimeColor,
    required this.registerAwardGiftTextColor,
    required this.registerAwardCoinTextColor,
    required this.tvSelectedTextColor,
    required this.userInfoViewRemarkTextColor,
    required this.userInfoViewReportTextColor,
    required this.userInfoViewBlockTextColor,
    required this.bottomSheetCallTitleTextColor,
    required this.bottomSheetCallSubTitleTextColor,
    required this.blockCellTitleTextColor,
    required this.blockCellDesTextColor,
    required this.depositBottomSheetCoinTextColor,
    required this.depositBottomSheetAmountTextColor,
    required this.bannerIndicatorColor,
    required this.tagHintTextColor,
    required this.realPersonAuthHintError,
});

  final Color primaryColor;
  final Color dialogBackgroundColor;
  final Color appBarBackgroundColor;
  final Color modifyDataButtonColor;
  final Color tabBarBackgroundColor;
  final Color bottomNavigationBarColor;
  final Color missionAppBarBgColor;
  final Color marqueeBackgroundColor;
  final Color marqueeImageColor;
  final Color baseBackgroundColor;
  final Color switchInactiveColor;
  final Color switchActiveColor;
  final Color chatRoomBottomBackgroundColor;
  final Color chatRoomFunctionIconColor;
  final Color personalSettingAboutBorder;
  final Color globalBackgroundColor;
  final Color progressbarLineColors;
  final Color progressbarIndicatorColors;
  final Color tagTextColors;
  final Color tagBackgroundColor;
  final Color personalPercentTextColor;
  final Color personalAudioColor;
  final Color myBubbleBackgroundColor;
  final Color otherSideBubbleBackgroundColor;
  final Color textFieldBackgroundColor;
  final Color textFieldBorderColor;
  final Color textFieldFontColor;
  final Color editAudioBeginRecordTitleColor ;
  final Color editAudioBeginRecordHintColor;
  final Color editAudioBeginRecordTimeColor ;
  final Color editAudioBeginRecordUnRecordIconColor;
  final Color editAudioBeginRecordRecordIconColor;
  final Color editAudioBeginRecordUnRecordBackgroundColor;
  final Color editAudioBeginRecordRecordBackgroundColor;
  final Color editAudioBeginRecordIconProgressBordColor;
  final Color editAudioBeginRecordBackgroundColor;
  final Color editAudioBeginRecordBordColor;
  final Color editAudiodTitleColor;
  final Color editAudiodTextFieldBackgroundColor;
  final Color editAudiodTextFieldHintColor;
  final Color myTagColor;
  final Color myTagTextColor;
  final Color versionUpdateBackgroundColor;
  final Color benefitAppBarColor;
  final Color benefitActiveBtnColor;
  final Color benefitUnActiveBtnColor;
  final Color benefitActiveTextColor;
  final Color benefitUnActiveTextColor;
  final Color textFieldFocusingColor;
  final Color howToTVUnderLineColor;
  final Color tabBarIndicatorColor;
  final Color homeTabBarColor;
  final Color homeTabBarUnSelect;
  final Color homeTabBarStrikeUpSelected;
  final Color homeTabBarActivitySelected;
  final Color homeTabBarVideoSelected;
  final Color homeTabBarMessageSelected;
  final Color homeTabBarProfileSelected;
  final Color descriptionTextColor;
  final Color verifyCodeTextColor;
  final Color inputFieldColor;
  final Color strikeupSearchTextFieldSearchBtnColor;
  final Color dividerColor;
  final Color tvMainTextColor;
  final Color tvSubTextColor;
  final Color tvTitleBgColor;
  final Color tvTitleTextColor;
  final Color tvTableBgColor;
  final Color userInfoViewNavigatorBgColor;
  final Color awardBgColor;
  final Color hintPillsTextColor;
  final Color chatroomInformationBackGroundColor;
  final Color iconFriendsettingColor;
  final Color bottomSheetBackgroundColor;
  final Color checkedInBgColor;
  final Color notCheckInBgColor;
  final Color checkInBtnTextColor;
  final Color checkInTitleTextColor;
  final Color personalProfilePrimaryTextColor;
  final Color personalProfileSecondaryTextColor;
  final Color commonLanguageAddIconColor;
  final Color commonLanguageCustomDeleteIconColor;
  final Color freindSettingPageItemBackGroundColor;
  final Color friendEmptyPrimaryTextColor;
  final Color friendEmptySecondaryTextColor;
  final Color visitorEmptyPrimaryTextColor;
  final Color visitorEmptySecondaryTextColor;
  final Color tabBarBgColor;
  final Color tabBarIndicatorBgColor;
  final Color tabBarSelectTextColor;
  final Color tabBarUnSelectTextColor;
  final Color friendPrimaryTextColor;
  final Color friendSecondaryTextColor;
  final Color visitorPrimaryTextColor;
  final Color visitorSecondaryTextColor;
  final Color visitorSeenTextColor;
  final Color activityPostCellSeparatorLineColor;
  final Color activityPostInputBackgroundColor;



  final Color goToTextColor;
  final Color receiveTextColor;
  final Color completedTextColor;
  final Color missionTitleTextColor;
  final Color missionPrimaryTextColor;
  final Color missionSecondaryTextColor;
  final Color chatroomTextFieldBackGroundColor;
  final Color chatroomTextFieldFontColor;
  final Color freindSettingPageItemBorderColor;
  final Color giftAndBagMainColor;
  final Color intimacyRuleContentBorderColor;
  final Color intimacyWidgetBackGroundColor;
  final Color intimacyRuleContentTitleTextColor;

  final Color btnConfirmTextColor;
  final Color btnCancelTextColor;
  final Color btnDisableTextColor;
  final Color intimacyDialogCurrentIntimacyTextColor;
  final Color intimacyDialogDifferenceInIntimacyTextColor;
  final Color intimacyDialogNextStageOfRelationshipTextColor;
  final Color iconIntimacyCheckColor;
  final Color iconIntimacyLockColor;
  final Color intimacyStepsLineColor;
  final Color intimacyStepsTagBackGroundColor;
  final Color messageTabActionColor;
  final Color personalCertifiedTextColor;
  final Color personalUncertifiedTextColor;
  final Color personalProcessCertificationTextColor;
  final Color personalProcessCertificationHintBgColor;
  final Color personalProcessCertificationHintTextColor;
  final Color customServicePrimaryTextColor;
  final Color customServiceSecondaryTextColor;
  final Color customServiceAppbarColor;
  final Color customServiceBgColor;
  final Color registerGenderSelectTextColor;
  final Color registerGenderUnSelectTextColor;
  final Color commonButtonContentBackGroundColor;
  final Color commonButtonCancelBackGroundColor;
  final Color reportPageTextColor;
  final Color reportPageAddImageBorderColor;
  final Color reportPageAddImageBackgroundColor;
  final Color reportTextFieldBorderColor;
  final Color userInfoViewCellTitleTextColor;
  final Color userInfoViewCellPrimaryTextColor;
  final Color userInfoViewCellSecondaryTextColor;
  final Color userInfoViewCellNameTextColor;
  final List<Color> tagColorList;
  final Color promotionCenterChannelButtonBackgroundColor;
  final Color userInfoViewEditTextColor;
  final Color commonButtonDeleteTextColor;
  final Color blockBannerPrimaryTextColor;
  final Color blockBannerSecondaryTextColor;
  final Color teenBannerPrimaryTextColor;
  final Color teenBannerSecondaryTextColor;
  final Color benefitPrimaryTextColor;
  final Color benefitSecondaryTextColor;
  final Color benefitInfoTextColor;
  final Color benefitLinkTextColor;
  final Color pickerDialogBackgroundColor;
  final Color pickerDialogIconColor;
  final Color charmLevelTagBackgroundColor;
  final Color charmLevelTableTitleBackgroundColor;
  final Color charmLevelTableBackgroundColor;
  final Color charmLevelTableLineColor;
  final Color pickerTextColor;
  final Color withdrawAccountBindPrimaryTextColor;
  final Color withdrawAccountBindSecondaryTextColor;
  final Color withdrawAccountBindLinkTextColor;
  final Color withdrawAccountBindBoxColor;
  final Color personalGreetModelPlayButtonColor;
  final Color personalGreetAddRecordColor;
  final Color personalGreetAddRecordTimeColor;
  final Color registerAwardGiftTextColor;
  final Color registerAwardCoinTextColor;
  final Color tvSelectedTextColor;
  final Color userInfoViewRemarkTextColor;
  final Color userInfoViewReportTextColor;
  final Color userInfoViewBlockTextColor;
  final Color bottomSheetCallTitleTextColor;
  final Color bottomSheetCallSubTitleTextColor;
  final Color blockCellTitleTextColor;
  final Color blockCellDesTextColor;
  final Color depositBottomSheetCoinTextColor;
  final Color depositBottomSheetAmountTextColor;
  final Color bannerIndicatorColor;
  final Color tagHintTextColor;
  final Color realPersonAuthHintError;
}