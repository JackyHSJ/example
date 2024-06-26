import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/cat/app_colors_cat.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

@immutable
class
AppTextCat {
  const AppTextCat._();

  static TextStyle buttonPrimaryTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
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
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(237, 114, 114, 1),
  );

  static TextStyle appbarTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(66, 44, 41, 1),
  );


  static TextStyle marqueeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(247, 121, 144, 1),
  );

  static TextStyle appbarActionTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(123, 81, 74, 1),
  );

  static TextStyle labelMainContentTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mainPink,
  );

  static TextStyle labelMainBoldContentTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.mainPink,
  );

  static TextStyle labelMainUnderLineTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.mainPink,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static TextStyle labelPrimaryTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textFormBlack,
  );

  static TextStyle labelSecondaryTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color:AppColors.textFormGrey,
  );

  static TextStyle labelPrimaryTitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textFormBlack,
  );

  static TextStyle labelSecondaryTitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textFormGrey,
  );

  static TextStyle labelPrimarySubtitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textFormBlack,
  );

  static TextStyle labelSecondarySubtitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textFormGrey,
  );

  static TextStyle labelPrimaryContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFormBlack,
  );

  static TextStyle labelSecondaryContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFormGrey,
  );

  static TextStyle labelThirdContentTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xff7F7F7F),
  );

  ///jerry
  static TextStyle commonLanguageTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(255, 248, 235, 1),
  );

  static TextStyle strikeUpListMarqueeTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(222, 85, 0, 1),
  );

  static TextStyle strikeUpListMarqueeDefaultTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///josh
  static TextStyle versionUpdateTitleTextStyle =  TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(66, 44, 41, 1),
  );
  static TextStyle versionUpdateSubTitleTextStyle =  TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(189, 150, 93, 1),
  );
  static TextStyle versionUpdateMessageTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(102, 102, 102, 1),
  );
  static TextStyle versionUpdateLaterButtonTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(102, 102, 102, 1),
    decoration: TextDecoration.underline,
    decorationColor:  Color.fromRGBO(102, 102, 102, 1),
  );
  static TextStyle howToTvTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(237, 114, 114, 1),
  );

  static TextStyle loginAgreeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decorationColor: Colors.black
  );

  static TextStyle zoomTabBarSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
    fontSize: 22,
    decoration: TextDecoration.none,
  );

  static TextStyle zoomTabBarUnSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
    fontSize: 16,
  );

  static TextStyle tabBarSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
    fontSize: 14,
    decoration: TextDecoration.none,
  );

  static TextStyle tabBarUnSelectTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
    fontSize: 14,
  );
  static TextStyle strikeUpMemberCardNameTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.4286,
    color: AppColorsCat.mainDark,
  );

  static TextStyle inputFieldTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColorsCat.textFormBlack,
  );

  static TextStyle strikeUpSearchEmptyTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: AppColorsCat.textFormBlack,
  );

  static TextStyle strikeUpSearchEmptySubTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColorsCat.textFormBlack,
  );

  static TextStyle userInfoViewAudioTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Color(0xff7F7F7F),
  );

  static TextStyle myBubbleMessageTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.white
  );

  static TextStyle otherSideBubbleMessageTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF444648)
  );

  static TextStyle cellListMainTextStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Color(0xff444648)
  );

  static TextStyle cellListSubTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Color(0xffCCCCCC)
  );

  static TextStyle tagTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Color(0xff7F7F7F)
  );
  static TextStyle dialogTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: AppColorsCat.textFormBlack,
  );
  static TextStyle dialogContentTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColorsCat.textFormBlack,
  );

  static TextStyle dialogConfirmButtonTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );

  static TextStyle dialogCancelButtonTextStyle = const TextStyle(
      color:  AppColorsCat.mainPink,
      fontSize: 14,
      fontWeight: FontWeight.w400
  );
  static TextStyle dialogDisableButtonTextStyle = const TextStyle(
      color:  AppColorsCat.completedTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );
  static TextStyle dialogLaterButtonTextStyle = const TextStyle(
    color:  AppColorsCat.mainGrey,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: AppColorsCat.mainGrey,
  );

  static TextStyle awardDefaultTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColorsCat.textFormBlack,
    fontSize: 12,
    height: 1.33,
  );
  static TextStyle awardHighlightTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.33,
    color: AppColorsCat.mainPink,
  );

  static TextStyle chatroomFriendInformationTitleTextStyle = const TextStyle(
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w500,
      color:  Color(0xFF444648)
    // color: Color(0xff444648)
  );

  static TextStyle missionDialogTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: Color(0xffEC6193),
  );

  static TextStyle missionDialogSubTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.5,
    color: Color(0xffEC6193),
  );
  static TextStyle missionDialogContentBoldTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: Color(0xff444648),
  );

  static TextStyle missionDialogContentTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: Color(0xff444648),
  );

  static TextStyle personalMissionCoinTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFBE3F)
  );


  static TextStyle depositCoinTotalTextStyle = const TextStyle(
      fontSize: 28,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w600);

  static TextStyle depositTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w600
  );
  static TextStyle depositCoinTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w600
  );
  static TextStyle depositCoinSubTitleTextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColorsCat.mainDark,
  );

  static TextStyle depositDirectionsTitleTextStyle = const TextStyle(
      color: AppColorsCat.mainBlack,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  static TextStyle depositDirectionsContentTextStyle = const TextStyle(
    color: AppColorsCat.mainBlack,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33333,
  );
  static TextStyle depositDirectionsHighLightTextStyle = const TextStyle(
    color: AppColorsCat.mainPink,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.underline,
    decorationColor:AppColorsCat.mainPink,
    decorationThickness: 1,
    height: 1.33333,
  );

  static TextStyle rechargeTitleTextStyle = const TextStyle(
      fontSize: 14,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w500
  );
  static TextStyle rechargeCoinTitleTextStyle = const TextStyle(
      fontSize: 12,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w700,
      height: 1.667
  );
  static TextStyle rechargeCoinSubTitleTextStyle = const TextStyle(
      fontSize: 8,
      color: AppColorsCat.mainDark,
      fontWeight: FontWeight.w400, height: 1
  );

  static TextStyle editAudioChangeWordTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColorsCat.mainWhite,
  );
  static TextStyle commonLanguagePageTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF444648));
  static TextStyle friendSettingPageItemTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(66, 44, 41, 1),
  );

  static TextStyle friendSettingPageUserNameTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(68, 70, 72, 1),
  );

  static TextStyle friendSettingPageUserInfoTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color:  Color.fromRGBO(68, 70, 72, 1),
  );

  static TextStyle friendSettingPageUserSelfIntroductionTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(127, 127, 127, 1),
  );

  static TextStyle intimacyDialogTitleTextStyle = const TextStyle(
      color: AppColors.mainPink,
      fontSize: 18,
      fontWeight: FontWeight.w700);

  static TextStyle intimacyDialogItemSubTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.textFormBlack,
  );

  static TextStyle intimacyStepsTagTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: Color.fromRGBO(236, 97, 147, 1),
  );

  static TextStyle intimacyStrategyTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColors.textFormBlack
  );

  static TextStyle messageTabItemRoomNameTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.mainDark,
  );

  static TextStyle messageTabItemRecentlyMessageTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mainDark,
  );

  static TextStyle messageTabItemTimeStampTextStyle = const TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: AppColors.mainDark,
  );

  static TextStyle messageTabEmptyTitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textFormBlack,
  );

  static TextStyle messageTabEmptySubTitleTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFormBlack,
  );

  static TextStyle cohesionLevelUpDialogContentTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textFormBlack,
  );

  static TextStyle reportTextFieldHintTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColors.mainGrey,
      fontSize: 14
  );

  static TextStyle reportTextFieldTextTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColors.textFormBlack,
      fontSize: 14
  );

  static TextStyle reportPageAppBarActionTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColors.textFormBlack,
      fontSize: 16
  );

  static TextStyle commonButtonCancelTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.textFormBlack,
      fontSize: 18
  );

  static TextStyle systemMessageTitleTextStyle = const TextStyle(
      color: AppColors.textFormBlack,
      fontWeight: FontWeight.w500,
      fontSize: 14
  );

  static TextStyle strikeUpMateDialogChargeTextStyle = const TextStyle(
      fontSize: 10,
      color: AppColorsCat.textFormBlack,
      fontWeight: FontWeight.w500,
  );

  static TextStyle activityEmptyTitleTextStyle = const TextStyle(
      color: AppColorsCat.textFormBlack,
      fontSize: 14,
      fontWeight: FontWeight.w700
  );
  static TextStyle activityEmptySubtitleTextStyle = const TextStyle(
      color: AppColorsCat.textFormBlack,
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostButtonTextStyle = const TextStyle(
      color: AppColorsCat.textWhite,
      fontSize: 12,
      fontWeight: FontWeight.w600
  );

  static TextStyle activityPostTitleTextStyle = const TextStyle(
    color: Color(0xff2a2b36),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    overflow: TextOverflow.ellipsis
  );

  static TextStyle activityPostContentTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostTagTextStyle = const TextStyle(
    color: AppColorsCat.btnDeepGrey,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle activityPostTopicTagTextStyle = const TextStyle(
      color: Color(0xff478AFB),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostDateTextStyle = const TextStyle(
      fontSize: 12,
      color: AppColorsCat.textGrey,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostAmountTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityHotTopicTitleTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 16,
      fontWeight: FontWeight.w700
  );

  static TextStyle activityHotTopicMoreTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 12,
      fontWeight: FontWeight.w500
  );

  static TextStyle activityHotTopicPostContentTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );
  static TextStyle activityTopicSubtitleTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostReplyTitleTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 14,
      fontWeight: FontWeight.w700
  );

  static TextStyle activityPostReplyContentTextStyle = const TextStyle(
      color: Color(0xff2a2b36),
      fontSize: 14,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostReplyDateTextStyle = const TextStyle(
      color:  Color(0xFF909090),
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle activityPostReplyActionTextStyle = const TextStyle(
      color: Color(0xFFFD73A5),
      fontWeight: FontWeight.w400,
      fontSize: 12,
  );

  static TextStyle activityPostReplyEmptyTextStyle = const TextStyle(
      color: const Color(0xffCFCFCF),
      fontWeight: FontWeight.w400,
      fontSize: 12
  );

  static TextStyle activityPostReplyHintTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.mainGrey,
  );
  static TextStyle activityPostReplyPostButtonTextStyle = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 1),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityPostReplyPostButtonDisableTextStyle = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 1),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityReportTagSelectedButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activityReportTagUnselectedButtonTextStyle = const TextStyle(
    color: AppColors.textFormBlack,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );


  static TextStyle benefitItemSelectedTextStyle = const TextStyle(
    color: Color(0xffFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle benefitItemUnSelectTextStyle = const TextStyle(
    color: Color(0xffFF3179),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle benefitItemDisableTextStyle = const TextStyle(
    color: Color(0xffD9D9D9),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalAgentTitleTextStyle = const TextStyle(
    color: Color(0xff2A77CC),
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle personalAgentSubtitleTextStyle = const TextStyle(
    color: Color(0xff2A77CC),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalAgentTabbarSelectTextStyle = const TextStyle(
    color: Color(0xff2A77CC),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle personalAgentTabbarUnselectTextStyle = const TextStyle(
    color: Color(0xffA1A2A3),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalAgentInviteButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle inviteCodeTextStyle = const TextStyle(
    color: AppColors.textFormBlack,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static TextStyle profileContactTodayTitleTextStyle = const TextStyle(
    color: AppColors.mainYellow,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactWeekTitleTextStyle = const TextStyle(
    color: AppColors.mainRed,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactLastWeekTitleTextStyle = const TextStyle(
    color: AppColors.mainBlue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileContactTodayContentTextStyle = const TextStyle(
    color: AppColors.mainYellow,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle profileContactWeekContentTextStyle = const TextStyle(
    color: AppColors.mainRed,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle profileContactLastWeekContentTextStyle = const TextStyle(
    color: AppColors.mainBlue,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle pickerDialogConfirmButtonTextStyle = const TextStyle(
    color: AppColors.textBlack,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle pickerDialogCancelButtonTextStyle = const TextStyle(
    color: AppColors.textBlack,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle pickerDialogContentTextStyle = const TextStyle(
    color: AppColors.textBlack,
    fontSize: 14,
  );
  static TextStyle charmLevelTitleTextStyle = const TextStyle(
    color: AppColors.mainPink,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelSubtitleTextStyle = const TextStyle(
    color: AppColors.mainPink,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelTagTextStyle = const TextStyle(
    color: AppColors.mainPink,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static TextStyle charmLevelTableTitleTextStyle = const TextStyle(
    color: AppColors.mainWhite,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle charmLevelTableContentTextStyle = const TextStyle(
    color: AppColors.mainPink,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );


  static TextStyle personalGreetModelNameTagTextStyle = const TextStyle(
    color: AppColors.mainWhite,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelUseTagTextStyle = const TextStyle(
    color: AppColors.mainWhite,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelReviewTagTextStyle = const TextStyle(
    color: Color(0xff979797),
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelReviewFailTagTextStyle = const TextStyle(
    color: Color(0xff979797),
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle personalGreetModelEditTagTextStyle = const TextStyle(
    color: AppColors.textBlack,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle chatMessageReviewWarningTextStyle = const TextStyle(
    color: Color(0xffEB5E5E),
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static TextStyle normalMainTextFieldTextStyle = const TextStyle(
    color: Color(0xff444648),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle normalMainTextFieldHintTextStyle = const TextStyle(
    color: Color(0xffCCCCCC),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalSettingCharmDialogTitleTextStyle = const TextStyle(
    color: Color(0xff444648),
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.44444,
  );

  static TextStyle personalSettingCharmDialogContentTextStyle = const TextStyle(
    color: Color(0xff444648),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.42857,
  );

  static TextStyle personalSettingCharmDialogLeftButtonTextStyle = const TextStyle(
    color: Color.fromRGBO(236, 97, 147, 1),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle personalSettingCharmDialogRightButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bottomRuleTableTextStyle = const   TextStyle(
      color: AppColors.textFormBlack,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1
  );

  static TextStyle withdrawAccountTitle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Color(0xff444648)
  );

  static TextStyle withdrawAccountSubTitle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Color(0xff7F7F7F)
  );

  static TextStyle callingPageBeautyButtonTextStyle = const TextStyle(
    color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.16667
  );
}

