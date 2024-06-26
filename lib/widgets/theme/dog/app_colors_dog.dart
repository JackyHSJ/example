import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

@immutable
/// TODO:『AppColorsDogMain』整理成一份
class
AppColorsDog {
  const AppColorsDog._();

  static const LinearGradient btnOrangeColors = LinearGradient(
    colors: [
      Color.fromRGBO(255, 154, 122, 1.0),
      Color.fromRGBO(255, 186, 122, 1)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient labelOrangeColors = LinearGradient(
    colors: [Color(0xFFE6803D), Color(0xFFEAB767)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient giftAndBagChargeTextColor = LinearGradient(
    colors: [
      Color.fromRGBO(169, 224, 255, 1),
      Color.fromRGBO(228, 200, 255, 1)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient intimacyRuleContentBackGroundColor = LinearGradient(
    colors: [
      Color.fromRGBO(169, 224, 255, 1),
      Color.fromRGBO(228, 200, 255, 1)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient intimacyDialogDividerColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.mainPink, AppColors.mainPetalPink],
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
    transform: GradientRotation(3.14),
  );

  static const LinearGradient intimacyStepsColor = pinkLightGradientColors;
  static const LinearGradient unReadBackGroundColor = pinkLightGradientColors;

  static const LinearGradient purpleGradientColors = LinearGradient(
    colors: [mainOrange, mainPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient officialAnnouncementLinearGradient = AppColors.periwinkleblueGradientColors;

  static const LinearGradient officialRewardsLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(92, 193, 138, 1),
      Color.fromRGBO(150, 254, 198, 1)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialMissionCompletedLinearGradient = LinearGradient(
    colors: [
      AppColors.mainYellow,
      AppColors.mainOrange
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialReviewLinearGradient = AppColors.pinkLightGradientColors;

  static const LinearGradient officialCharmLevelIncreaseLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(205, 157, 251, 1),
      Color.fromRGBO(55, 175, 243, 1)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialReportLinearGradient = LinearGradient(
    colors: [
      AppColors.textFormBlack,
      AppColors.textFormBlack
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialFreezeLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(0,40,87, 1),
      Color.fromRGBO(0,40,87, 1)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient pinkGradientColors = LinearGradient(
    colors: [mainPink, Color(0xFFF5713A)],
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkLightGradientColors = LinearGradient(
    colors: [mainPink, mainPetalPink],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient mistPinkGradientColors = LinearGradient(
    colors: [mainPink.withOpacity(0.2), mainPink.withOpacity(0.1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient mainSnowWhiteGradientColors = LinearGradient(
    colors: [mainSnowWhite, mainSnowWhite],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient periwinkleblueGradientColors = LinearGradient(
    colors: [mainSkyBlue, mainPeriwinkleBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient bluePurpleGradientColors = LinearGradient(
    colors: [Color(0xff37AFF3), Color(0xffCD9DFB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const greetColorList = [
    mainPink, mainYellow, mainBlue
  ];

  static const tagColorList = [
    Color.fromRGBO(249, 226, 231, 1),
    Color.fromRGBO(250, 233, 226, 1),
    Color.fromRGBO(243, 233, 216, 1),
    Color.fromRGBO(241, 247, 223, 1),
    Color.fromRGBO(227, 244, 233, 1),
    Color.fromRGBO(225, 237, 250, 1),
    Color.fromRGBO(234, 238, 250, 1),
    Color.fromRGBO(245, 235, 254, 1)
  ];

  static const cohesionLevelColor = [
    Color.fromRGBO(220, 183, 255, 1),
    Color.fromRGBO(172, 189, 255, 1),
    Color.fromRGBO(129, 179, 233, 1),
    Color.fromRGBO(98, 189, 130, 1),
    Color.fromRGBO(242, 177, 184, 1),
    Color.fromRGBO(231, 201, 233, 1),
    Color.fromRGBO(223, 138, 146, 1),
    Color.fromRGBO(204, 33, 26, 1),
    Color.fromRGBO(243, 166, 89, 1),
  ];

  static const swiperActiveColor = Color(0xFFDC4F27);
  static const swiperPassiveColor = Color(0xFFCACBCE);

  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color.fromRGBO(68, 70, 72, 1);
  static const Color textGrey = Color(0xFF7C7C7C);
  static const Color textGreyBackground = Color(0xFFE1E1E1);
  static const Color textBlue = Color(0xFF2399D7);
  static const Color textRed = Color(0xFFE674A3);
  static const Color textBackGroundGrey = Color(0xFFE0E0E0);
  static const Color textBackGroundPink = Color(0xFFF6EDEF);

  /// Divider
  static const Color dividerBlack = Color(0xFF1F2026);
  static const Color dividerGrey = Color(0xFFE3E3E3);

  /// TextForm
  static const Color textFormGrey = Color(0xFFE0E0E0);
  static const Color textFormBlack = Color(0xFF444648);
  static const Color textFormLightBlack = Color(0xFF999999);


  /// QR code
  static const Color qrCodeGrey = Color(0xFFBCBDBE);
  static const Color qrCodeBlack = Colors.black;


  ///MARK:主題色彩
  static const Color mainRed = Color(0xFFE55024);
  static const Color mainCrimson = Color(0xFFFF3333);
  static const Color mainYellow = Color(0xFFF5C370);
  static const Color mainOrange = Color(0xFFEE813B);
  static const Color mainGreen = Color(0xFF5CCE5B);
  static const Color mainTiffanyGreen = Color(0xFF41968B);
  static const Color mainPurple = Color(0xFFC279FF);
  static const Color mainPink = Color(0xFFEB5D8E);
  static const Color mainPetalPink = Color(0xFFF08ABF);
  static const Color mainBlue = Color(
      0xFF2399D7); //(35, 153, 215) 52, 158, 235, 1
  static const Color mainPeriwinkleBlue = Color(0xFF647DF6);
  static const Color mainSkyBlue = Color(0xFF59BBE0);
  static const Color mainDeepBlue = Color(0xFF0651AE); //(6, 81, 174)
  static const Color mainBlack = Colors.black;
  static const Color mainDark = Color(0xFF7F7F7F);
  static const Color mainGrey = Color(0xFFD1D1D1);
  static const Color mainLightGrey = Color(0xFFEFEFEF);
  static const Color mainSnowWhite = Color(0xFFF6F6F6);
  static const Color mainWhite = Color(0xFFFFFFFF);
  static const Color mainTransparent = Colors.transparent;

  static const Color mainBrown = Color.fromRGBO(123, 81, 74, 1);


  static const Color navigationBarRed = Color(0XFFEA7350);
  static const Color navigationBarOrange = Color(0XFFF7C344);
  static const Color navigationBarGreen = Color(0XFF95C155);
  static const Color navigationBarBlue = Color(0XFF4FADDF);
  static const Color navigationBarWhite = Color(0xFFFFFFFF);
  static const Color btnRed = Color(0XFFFADCD3);
  static const Color btnDeepGrey = Color(0xFFABA9AC);
  static const Color btnLightGrey = Color(0xFFEDEDED);
  static const Color mainPaleGrey = Color(0xFFEAEAEA);
  static const Color btnLightOrange = Color(0xFFF5EEE5);
  static const Color btnYellow = Color(0XFFFDF0D0);
  static const Color btnBlue = Color(0XFFD3EBF7);
  static const Color borderColor = Color(0XFF1F2026);
  static const Color progressGrey = Color(0XFFD2D2D4);
  static const Color dropDoneBlue = Color(0XFFCDE5F3);

  static const Color btnDeepBlue = Color(0XFF0052B4);
  static const Color btnSkyBlue = Color(0XFF338AF3);

  static const Color systemBlue = Color(0xff6B97E7);


  /// background
  static const Color globalBackGround = Color(0xFFFAFAFA);
  static const Color whiteBackGround = Colors.white;
  static const Color btnOrangeBackGround = Color(0xFFF4EDDD);
  static const Color btnPurpleBackGround = Color(0xFFECE7F5);


  /// textfield
  static const Color textFieldWhitBackGround = Color(0xFFF5F5F5);

  /// error status
  static const Color redErrorStatus = Color(0xFFFF584E);

  ///poker
  static const Color pokerBackground = Color.fromRGBO(249, 160, 206, 0.2);
  static const Color pokerTitleText = Color.fromRGBO(255, 116, 165, 1);
  static const Color pokerRefreshButton = Color.fromRGBO(255, 116, 165, 1);

  ///
  static const Color dialogBackgroundColor = Color.fromRGBO(252, 252, 252, 1);

  //progress bar
  static const Color progressbarindicatorColors = mainBrown; //完成進度條顏色
  static const Color progressbarLineColors = Color.fromRGBO(
      244, 228, 196, 1); //進度條底色

  ///tag
  static const Color tagTextColors = Color.fromRGBO(66, 44, 41, 1); //標籤文字顏色
  static const Color tagBackgroundColor = Color.fromRGBO(
      244, 228, 196, 1); //標籤背景色


  static const LinearGradient btnYellowColors = LinearGradient(
    colors: [
      Color.fromRGBO(250, 208, 12, 1),
      Color.fromRGBO(250, 208, 12, 1)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient btnLightYellowColors = LinearGradient(
    colors: [
      Color.fromRGBO(252, 239, 208, 1),
      Color.fromRGBO(252, 239, 208, 1)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient btnDisableColors = LinearGradient(
    colors: [
      Color.fromRGBO(207, 207, 207, 1),
      Color.fromRGBO(207, 207, 207, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonChooseMale = LinearGradient(
    colors: [
      Color.fromRGBO(131, 194, 195, 1),
      Color.fromRGBO(131, 194, 195, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonChooseFemale = LinearGradient(
    colors: [
      Color.fromRGBO(237, 114, 114, 1),
      Color.fromRGBO(237, 114, 114, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient buttonUnChooseGender = const LinearGradient(
    colors: [
      mainSnowWhite,
      mainSnowWhite,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient missionBgColor = LinearGradient(
    colors:  [
      Color.fromRGBO(255, 248, 235, 1),
      Color.fromRGBO(255, 248, 235, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient blueGradientColors = LinearGradient(
    colors: [Color(0xff2D72CC), Color(0xff54B5DF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient personalSettingCharmDialogLeftButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(252, 239, 208, 1),
      Color.fromRGBO(252, 239, 208, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient personalSettingCharmDialogRightButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(250, 208, 12, 1),
      Color.fromRGBO(250, 208, 12, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient intimacyStepsUnGetLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(207, 207, 207, 1),
      Color.fromRGBO(207, 207, 207, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient callingPageBeautyButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(250, 208, 12, 1),
      Color.fromRGBO(250, 208, 12, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  ///cat
  static const Color appBarBackgroundColor = Color.fromRGBO(252, 252, 252, 1);
  static const Color modifyDataButtonColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color tabBarBackgroundColor =  Color(0xffF2ECDF);
  static const Color missionAppBarBgColor =  Color.fromRGBO(255, 248, 235, 1);
  static const Color marqueeBackgroundColor =  whiteBackGround;
  static const Color marqueeImageColor =  Color.fromRGBO(247, 121, 114, 1);
  static const Color baseBackgroundColor =  Color.fromRGBO(244, 228, 196, 1);
  static const Color switchActiveColor = Color.fromRGBO(189, 150, 93, 1);
  static const Color switchInactiveColor = Color.fromRGBO(217, 217, 217, 1);
  static const Color chatRoomBottomBackgroundColor = Color.fromRGBO(123, 81, 74, 1);
  static const Color chatRoomFunctionIconColor = whiteBackGround;
  static const Color personalSettingAboutBorder = Color.fromRGBO(123, 81, 74, 1);
  static const Color globalBackgroundColor = Color.fromRGBO(255, 248, 235, 1);


  ///josh
  static const Color personalPercentTextColors = mainBrown;//編輯資料百分比
  static LinearGradient verifyTagBackgroundColor = const LinearGradient(
    colors: [mainBrown, mainBrown,],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color personalAudioColor = mainBrown;//錄音
  static const Color textFieldBackgroundColor = mainWhite;
  static const Color textFieldBorderColor = mainBrown;
  static const Color labelTextColor = mainBrown;
  static const Color editAudioBeginRecordTitleColor = Color.fromRGBO(66, 44, 41, 1);
  static const Color editAudioBeginRecordHintColor = Color.fromRGBO(66, 44, 41, 1);
  static const Color editAudioBeginRecordTimeColor = Color.fromRGBO(66, 44, 41, 1);
  static const Color editAudioBeginRecordUnRecordIconColor= mainBrown;
  static const Color editAudioBeginRecordRecordIconColor= Color.fromRGBO(255, 248, 235, 1);
  static const Color editAudioBeginRecordUnRecordBackgroundColor= Colors.transparent;
  static const Color editAudioBeginRecordRecordBackgroundColor=Color.fromRGBO(123, 81, 74, 0.5);
  static const Color editAudioBeginRecordIconProgressBordColor= mainBrown;
  static const Color editAudioBeginRecordBackgroundColor= Color.fromRGBO(232, 210, 194, 1);
  static const Color editAudioBeginRecordBordColor= mainBrown;
  static const Color editAudiodTitleColor= textFormBlack;
  static const Color editAudiodTextFieldBackgroundColor= Color.fromRGBO(255, 248, 235, 1);
  static const Color editAudiodTextFieldHintColor= mainBrown;
  static const LinearGradient editAudioBeginRecordDoneBackgroundColor = btnLightYellowColors;
  static const Color myTagColor= Color(0xffF6F6F6);
  static const Color myTagTextColor =Color(0xff444648);
  static const Color versionUpdateBackgroundColor= Color.fromRGBO(123, 81, 74, 1);



  // Chris
  static const LinearGradient depositBgColor = LinearGradient(
    colors: [Color.fromRGBO(255, 248, 235, 1), Color.fromRGBO(255, 248, 235, 1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient benefitBgColor = LinearGradient(
    colors: [Color.fromRGBO(255, 248, 235, 1), Color.fromRGBO(255, 248, 235, 1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color benefitAppBarColor = Color.fromRGBO(255, 248, 235, 1);


//169, 224, 255, 1
  static const LinearGradient commonLanguageButtonColor = LinearGradient(
    colors:  [
      Color.fromRGBO(123, 81, 74, 1),
      Color.fromRGBO(123, 81, 74, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  ///jerry
  static const Color myBubbleBackgroundColor = Color.fromRGBO(66, 44, 41, 1);
  static const Color otherSideBubbleBackgroundColor = Colors.white;


  // Chris
  static const Color benefitActiveBtnColor = Color(0xff7B514A);
  static const Color benefitUnActiveBtnColor = Color(0xffFFF8EB);
  static const Color benefitActiveTextColor = Color(0xffFFFFFF);
  static const Color benefitUnActiveTextColor = Color(0xff422C29);
  static const Color benefitPrimaryTextColor = Color(0xff444648);
  static const Color benefitSecondaryTextColor = Color(0xff7F7F7F);
  static const Color benefitInfoTextColor = Color(0xffFF3179);
  static const Color benefitLinkTextColor = Color(0xffFF3179);
  static const Color homeTabBarColor = Color(0xffFAD00C);
  static const Color homeTabBarUnSelect = Color(0xff7F7F7F);
  static const Color homeTabBarStrikeUpSelected = Color(0xff422C29);
  static const Color homeTabBarActivitySelected = Color(0xff422C29);
  static const Color homeTabBarVideoSelected = Color(0xff422C29);
  static const Color homeTabBarMessageSelected = Color(0xff422C29);
  static const Color homeTabBarProfileSelected = Color(0xff422C29);
  static const Color descriptionTextColor = Color(0xff7B514A);
  static const Color verifyCodeTextColor = AppColors.mainPink;
  static const Color inputFieldColor = Colors.white;
  static const Color dividerColor = Color(0xffEAEAEA);
  static const Color tvMainTextColor = Color(0xff444648);
  static const Color tvSubTextColor = Color(0xff7F7F7F);
  static const Color tvTitleBgColor = Color(0xFFF2A457);
  static const Color tvTitleTextColor = Color(0xffFFFFFF);
  static const Color tvTableBgColor =  Color(0xffFFFFFF);
  static const Color userInfoViewNavigatorBgColor =  Colors.white;
  static const Color hintPillsTextColor =  Color(0xffEC6193);




  static const Color textFieldFocusingColor = Color.fromRGBO(93, 153, 237, 1);
  static const Color howToTVUnderLineColor = Color.fromRGBO(131, 194, 195, 1);
  static const Color chatroomInformationBackGroundColor = AppColors.whiteBackGround;
  static const Color iconFriendsettingColor = Color.fromRGBO(66, 44, 41, 1);
  static const Color commonLanguageAddIconColor = Colors.black;
  static const Color commonLanguageCustomDeleteIconColor = Colors.red;
  static const Color freindSettingPageItemBackGroundColor = Colors.white;


  static const LinearGradient strikeUpListMarqueeBackgroundColor = LinearGradient(
    colors:  [
      Colors.white,
      Colors.white
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient chatroomRealNameTagColor = LinearGradient(
    colors: [Color.fromRGBO(84, 181, 223, 1), Color.fromRGBO(125, 215, 250, 1)],
    begin:  Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient chatroomRealPersonTagColor = LinearGradient(
    colors: [mainPeriwinkleBlue, AppColors.mainSkyBlue],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const Color bottomSheetBackgroundColor = Color.fromRGBO(0, 0, 0, 0.1);
  static Color checkedInBgColor = Color(0xffFFF6EE);
  static const Color notCheckInBgColor = Color(0xffF6F6F6);
  static const Color checkInBtnTextColor = Colors.white;
  static const Color checkInTitleTextColor = Color(0xff444648);
  static const Color personalProfilePrimaryTextColor = Color(0xff444648);
  static const Color personalProfileSecondaryTextColor = Color(0xff7F7F7F);

  static const LinearGradient commonLanguageCustomTagColor = AppColors.periwinkleblueGradientColors;
  static const Color friendEmptyPrimaryTextColor = Color(0xff444648);
  static const Color friendEmptySecondaryTextColor = Color(0xff444648);
  static const Color visitorEmptyPrimaryTextColor = Color(0xff444648);
  static const Color visitorEmptySecondaryTextColor = Color(0xff444648);
  static const Color tabBarBgColor = Color(0xfff5f5f5);
  static const Color tabBarIndicatorBgColor = Color(0xffffffff);
  static const Color tabBarSelectTextColor = Color(0xffFF3179);
  static const Color tabBarUnSelectTextColor = Color(0xff444648);
  static const Color friendPrimaryTextColor = Color(0xff7F7F7F);
  static const Color friendSecondaryTextColor = Color(0xff7F7F7F);
  static const Color visitorPrimaryTextColor = Color(0xff7F7F7F);
  static const Color visitorSecondaryTextColor = Color(0xff7F7F7F);
  static const Color visitorSeenTextColor = Color(0xffFD73A5);
  static const Color activityPostCellSeparatorLineColor = Color(0xFFEAEAEB);
  static const Color intimacyDialogCurrentIntimacyTextColor = AppColors.mainPeriwinkleBlue;
  static const Color intimacyDialogDifferenceInIntimacyTextColor = AppColors.mainPink;
  static const Color intimacyDialogNextStageOfRelationshipTextColor = AppColors.mainPink;
  static const Color iconIntimacyCheckColor = AppColors.mainPink;
  static const Color iconIntimacyLockColor = missionSecondaryTextColor;
  static const Color intimacyStepsLineColor = AppColors.mainPink;
  static const Color intimacyStepsTagBackGroundColor = Color.fromRGBO(253, 241, 246, 1);
  static const Color messageTabActionColor = Color.fromRGBO(152, 152, 154, 1);

  // Mission
  static const Color goToTextColor = Color(0xffFFFFFF);
  static const Color receiveTextColor = Color(0xffFFFFFF);
  static const Color completedTextColor = Color(0xff979797);
  static const Color missionTitleTextColor = Color(0xffFFBE3F);
  static const Color missionPrimaryTextColor = Color(0xff444648);
  static const Color missionSecondaryTextColor = Color(0xff7F7F7F);

  // Common
  static const Color btnConfirmTextColor = Color(0xffFFFFFF);
  static const Color btnCancelTextColor = Color(0xffEC6193);
  static const Color btnDisableTextColor = Color(0xffFFFFFF);
  static const Color chatroomTextFieldBackGroundColor =  AppColors.textFieldWhitBackGround;
  static const Color chatroomTextFieldFontColor =  AppColors.mainBlack;
  static const Color freindSettingPageItemBorderColor =  Color(0xffFFFFFF);
  static const Color giftAndBagMainColor = Color.fromRGBO(250, 208, 12, 1);
  static const Color intimacyRuleContentBorderColor =  Colors.transparent;
  static const Color intimacyWidgetBackGroundColor =  Colors.white;
  static const Color intimacyRuleContentTitleTextColor =  AppColors.textFormBlack;
  static const Color personalCertifiedTextColor =  Color(0xff979797);
  static const Color personalUncertifiedTextColor =  Color(0xffFFFFFF);
  static const Color personalProcessCertificationTextColor =  Color(0xffFFFFFF);
  static const Color personalProcessCertificationHintBgColor =  Color(0xffFFF5F8);
  static const Color personalProcessCertificationHintTextColor =  Color(0xffFF3179);
  static const Color customServicePrimaryTextColor =  Color(0xff444648);
  static const Color customServiceSecondaryTextColor = Color(0xff979797);
  static const Color customServiceAppbarColor =  Color(0xffFAFAFA);
  static const Color customServiceBgColor =  Color(0xffFAFAFA);
  static const Color registerGenderSelectTextColor = Color(0xffFFFFFF);
  static const Color registerGenderUnSelectTextColor =  Color(0xff444648);
  static const Color commonButtonContentBackGroundColor =  Color.fromRGBO(245, 245, 245, 0.7);
  static const Color commonButtonCancelBackGroundColor =  Colors.white;
  static const Color reportPageTextColor = AppColors.textFormBlack;
  static const Color reportPageAddImageBorderColor = Color.fromRGBO(234, 234, 234, 1);
  static const Color reportPageAddImageBackgroundColor = Colors.white;
  static const Color reportTextFieldBorderColor = Color.fromRGBO(234, 234, 234, 1);
  static const Color userInfoViewCellNameTextColor =  Color(0xff444648);
  static const Color userInfoViewCellTitleTextColor =  Color(0xff7F7F7F);
  static const Color userInfoViewCellPrimaryTextColor =  Color(0xff7F7F7F);
  static const Color userInfoViewCellSecondaryTextColor =  Color(0xff444648);

  static const Color promotionCenterChannelButtonBackgroundColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color userInfoViewEditTextColor =  Color(0xffEC6193);

  static const Color commonButtonDeleteTextColor = Color(0xFFFF3B30);

  static const Color blockBannerPrimaryTextColor =  Color(0xff444648);
  static const Color blockBannerSecondaryTextColor =  Color(0xff444648);
  static const Color teenBannerPrimaryTextColor =  Color(0xff444648);
  static const Color teenBannerSecondaryTextColor =  Color(0xff7F7F7F);
  static const Color pickerTextColor = Color(0xff444648);
  static const Color withdrawAccountBindPrimaryTextColor = Color(0xff444648);
  static const Color withdrawAccountBindSecondaryTextColor = Color(0xffCCCCCC);
  static const Color withdrawAccountBindLinkTextColor = Color(0xffF5317A);
  static const Color withdrawAccountBindBoxColor = Color(0xffFFFFFF);
  static const Color registerAwardGiftTextColor = Color(0xff444648);
  static const Color registerAwardCoinTextColor = Color(0xffFFC250);
  static const Color tvSelectedTextColor = Color(0xffFFFFFF);
  static const Color userInfoViewRemarkTextColor = Color(0xff444648);
  static const Color userInfoViewReportTextColor = Color(0xffFF3B30);
  static const Color userInfoViewBlockTextColor = Color(0xffFF3B30);
  static const Color bottomSheetCallTitleTextColor = Color(0xff444648);
  static Color bottomSheetCallSubTitleTextColor = const Color(0xff444648).withOpacity(0.8);
  static Color blockCellTitleTextColor = Color(0xff7F7F7F);
  static Color blockCellDesTextColor = Color(0xff7F7F7F);
  static Color depositBottomSheetCoinTextColor = Color(0xff444648);
  static Color depositBottomSheetAmountTextColor = AppColors.mainPink;
  static Color bannerViewIndicatorColor = Color.fromRGBO(250, 208, 12, 1);
  static Color primaryColor = Color.fromRGBO(250, 208, 12, 1);
  static const Color tagHintTextColor = Color(0xff444648);
  static const Color realPersonAuthHintError = Color(0xffFF3179);

}

