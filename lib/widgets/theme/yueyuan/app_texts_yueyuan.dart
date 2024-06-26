import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/yueyuan/app_colors_yueyuan_main.dart';

@immutable
class
AppTextYueYuan {
  const AppTextYueYuan._();

  static TextStyle buttonPrimaryTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsYueYuanMain.absoluteBlack,
  );

  static TextStyle buttonSecondaryTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(66, 44, 41, 1),
  );

  static TextStyle buttonDisableTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(140, 121, 123, 1),
  );

  static TextStyle protocolTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: AppColorsYueYuanMain.supportiveBlue,
    decoration: TextDecoration.underline,
    decorationColor: AppColorsYueYuanMain.supportiveBlue,
  );

  static TextStyle appbarTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.absoluteWhite
  );

  static TextStyle marqueeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(197, 168 ,124, 1),
  );

  static TextStyle appbarActionTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.goldsGoldText,
  );

  static TextStyle labelMainContentTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.goldsGoldText,
  );

  static TextStyle labelMainBoldContentTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.goldsGoldText,
  );

  static TextStyle labelMainUnderLineTextStyle = TextStyle(
    fontSize: 14,
    color: AppColorsYueYuanMain.goldsGoldText,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    decorationColor: AppColorsYueYuanMain.goldsGoldText,
  );
  static TextStyle labelPrimaryTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle labelSecondaryTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkDarkerText,
  );

  static TextStyle labelPrimaryTitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle labelSecondaryTitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.darkDarkerText,
  );

  static TextStyle labelPrimarySubtitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle labelSecondarySubtitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.darkDarkerText,
  );

  static TextStyle labelPrimaryContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle labelSecondaryContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkDarkerText,
  );

  static TextStyle labelThirdContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkDarkerText,
  );

  ///jerry
  static TextStyle commonLanguageTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(197, 168, 124, 1),
  );

  static TextStyle strikeUpListMarqueeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle strikeUpListMarqueeDefaultTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColorsYueYuanMain.darkText,
  );

  ///josh
  static TextStyle versionUpdateTitleTextStyle =  TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.goldsGold2,
  );
  static TextStyle versionUpdateSubTitleTextStyle =  TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color:AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle versionUpdateMessageTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color:AppColorsYueYuanMain.darkText,
  );
  static TextStyle versionUpdateLaterButtonTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color:AppColorsYueYuanMain.absoluteWhite,
    decoration: TextDecoration.underline,
    decorationColor: AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle howToTvTextStyle = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColorsYueYuanMain.supportiveBlue,
  );



  static TextStyle zoomTabBarSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 22,
    decoration: TextDecoration.none,
  );

  static TextStyle zoomTabBarUnSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColorsYueYuanMain.darkText,
    fontSize: 16,
  );
  static TextStyle tabBarSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
    decoration: TextDecoration.none,
  );

  static TextStyle tabBarUnSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkText,
    fontSize: 14,
  );
  static TextStyle strikeUpMemberCardNameTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.4286,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle loginAgreeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: AppColorsYueYuanMain.absoluteWhite,
    decoration: TextDecoration.none,
    decorationColor: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle inputFieldTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle strikeUpSearchEmptyTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle strikeUpSearchEmptySubTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle userInfoViewAudioTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle dialogTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle dialogContentTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColorsYueYuanMain.absoluteWhite,
  );
  static TextStyle dialogConfirmButtonTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteBlack,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );
  static TextStyle dialogCancelButtonTextStyle = const TextStyle(
      color:  AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14,
      fontWeight: FontWeight.w400
  );

  static TextStyle dialogDisableButtonTextStyle = const TextStyle(
      color:  AppColorsYueYuanMain.darkText,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );

  static TextStyle dialogLaterButtonTextStyle = const TextStyle(
    color:  AppColorsYueYuanMain.absoluteWhite,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle awardDefaultTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 12,
    height: 1.33,
  );
  static TextStyle awardHighlightTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.33,
    color: AppColorsYueYuanMain.goldsGoldText,
  );

  static TextStyle myBubbleMessageTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite
  );

  static TextStyle otherSideBubbleMessageTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColorsYueYuanMain.absoluteWhite
  );

  static TextStyle cellListMainTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite
  );

  static TextStyle cellListSubTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColorsYueYuanMain.darkText
  );

  static TextStyle tagTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: AppColorsYueYuanMain.darkText
  );

  static TextStyle chatroomFriendInformationTitleTextStyle = const TextStyle(
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w500,
      color: Colors.white
    // color: Color(0xff444648)
  );

  static TextStyle missionDialogTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color:AppColorsYueYuanMain.goldsGold,
  );

  static TextStyle missionDialogSubTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.5,
    color:AppColorsYueYuanMain.goldsGold,
  );
  static TextStyle missionDialogContentBoldTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color:AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle missionDialogContentTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color:AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle personalMissionCoinTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColorsYueYuanMain.goldsGoldText
  );


  static TextStyle depositCoinTotalTextStyle = const TextStyle(
      fontSize: 28,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w600);

  static TextStyle depositTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w600
  );
  static TextStyle depositCoinTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w600
  );
  static TextStyle depositCoinSubTitleTextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle depositDirectionsTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  static TextStyle depositDirectionsContentTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33333,
  );
  static TextStyle depositDirectionsHighLightTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.supportiveBlue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.underline,
    decorationColor:AppColorsYueYuanMain.supportiveBlue,
    decorationThickness: 1,
    height: 1.33333,
  );

  static TextStyle rechargeTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w600
  );
  static TextStyle rechargeCoinTitleTextStyle = const TextStyle(
      fontSize: 12,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w700
  );
  static TextStyle rechargeCoinSubTitleTextStyle = const TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColorsYueYuanMain.darkText,
  );
  static TextStyle strikeUpMateDialogChargeTextStyle = const TextStyle(
    fontSize: 10,
    color: AppColorsYueYuanMain.absoluteWhite,
    fontWeight: FontWeight.w500,
  );

  static TextStyle editAudioChangeWordTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsYueYuanMain.goldsGoldText
  );
  static TextStyle commonLanguagePageTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white);

  static TextStyle friendSettingPageItemTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColorsYueYuanMain.absoluteWhite
  );

  static TextStyle friendSettingPageUserNameTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle friendSettingPageUserInfoTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle friendSettingPageUserSelfIntroductionTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(152, 152, 152, 1),
  );

  static TextStyle intimacyDialogTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.goldsGoldText,
      fontSize: 18,
      fontWeight: FontWeight.w700);

  static TextStyle intimacyDialogItemSubTitleTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle intimacyStepsTagTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColorsYueYuanMain.goldsGoldText,
  );

  static TextStyle intimacyStrategyTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColorsYueYuanMain.darkText
  );

  static TextStyle messageTabItemRoomNameTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle messageTabItemRecentlyMessageTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle messageTabItemTimeStampTextStyle = const TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle messageTabEmptyTitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle messageTabEmptySubTitleTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.darkText,
  );

  static TextStyle cohesionLevelUpDialogContentTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle reportTextFieldHintTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColorsYueYuanMain.darkText,
      fontSize: 14
  );

  static TextStyle reportTextFieldTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14
  );

  static TextStyle reportPageAppBarActionTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColorsYueYuanMain.darkText,
      fontSize: 16
  );

  static TextStyle commonButtonCancelTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 18
  );

  static TextStyle systemMessageTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontWeight: FontWeight.w500,
      fontSize: 14
  );

  static TextStyle activityPostButtonTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteBlack,
      fontSize: 12,
      fontWeight: FontWeight.w600
  );
  static TextStyle activityEmptyTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );
  static TextStyle activityEmptySubtitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.darkText,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      overflow: TextOverflow.ellipsis
  );

  static TextStyle activityPostContentTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle activityPostTopicTagTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.supportiveBlue,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostDateTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.darkText,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostAmountTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityHotTopicTitleTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 16,
      fontWeight: FontWeight.w700
  );

  static TextStyle activityHotTopicMoreTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w500
  );

  static TextStyle activityHotTopicPostContentTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );
  static TextStyle activityTopicSubtitleTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );


  static TextStyle activityPostReplyTitleTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );

  static TextStyle activityPostReplyContentTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.absoluteWhite,
      fontSize: 14,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostReplyDateTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.darkText,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostReplyActionTextStyle = const TextStyle(
    color:AppColorsYueYuanMain.supportiveBlue,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static TextStyle activityPostReplyEmptyTextStyle = const TextStyle(
      color:AppColorsYueYuanMain.darkText,
      fontWeight: FontWeight.w400,
      fontSize: 12
  );

  static TextStyle activityPostReplyHintTextStyle = const TextStyle(
    color:AppColorsYueYuanMain.darkText,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static TextStyle activityPostReplyPostButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteBlack,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityPostReplyPostButtonDisableTextStyle = const TextStyle(
    color:AppColorsYueYuanMain.darkText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityReportTagSelectedButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteBlack,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityReportTagUnselectedButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle benefitItemSelectedTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteBlack,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle benefitItemUnSelectTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle benefitItemDisableTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalAgentTitleTextStyle = labelPrimaryTitleTextStyle;

  static TextStyle personalAgentSubtitleTextStyle = const TextStyle(
    color:  AppColorsYueYuanMain.goldsGoldText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalAgentTabbarSelectTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle personalAgentTabbarUnselectTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalAgentInviteButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteBlack,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle inviteCodeTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );


  static TextStyle profileContactTodayTitleTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactWeekTitleTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactLastWeekTitleTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactTodayContentTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle profileContactWeekContentTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle profileContactLastWeekContentTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle pickerDialogConfirmButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle pickerDialogCancelButtonTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle pickerDialogContentTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
  );

  static TextStyle charmLevelTitleTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.goldsGoldText,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelSubtitleTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.goldsGoldText,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.goldsGoldText,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static TextStyle charmLevelTableTitleTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelTableContentTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.goldsGoldText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalGreetModelNameTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelUseTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelReviewTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelReviewFailTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.supportiveError,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelEditTagTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle chatMessageReviewWarningTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.supportiveError,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static TextStyle normalMainTextFieldTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.absoluteWhite,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle normalMainTextFieldHintTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalSettingCharmDialogTitleTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.44444,
  );

  static TextStyle personalSettingCharmDialogContentTextStyle = const TextStyle(
    color: AppColorsYueYuanMain.darkText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.42857,
  );

  static TextStyle personalSettingCharmDialogLeftButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalSettingCharmDialogRightButtonTextStyle = const TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bottomRuleTableTextStyle = const TextStyle(
      color: AppColorsYueYuanMain.absoluteWhite,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1
  );

  static TextStyle withdrawAccountTitle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: AppColorsYueYuanMain.absoluteWhite,
  );

  static TextStyle withdrawAccountSubTitle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColorsYueYuanMain.darkText
  );

  static TextStyle callingPageBeautyButtonTextStyle = const TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.16667
  );
}

