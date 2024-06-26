import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/yueyuan/app_colors_yueyuan_main.dart';

@immutable

/// TODO:『AppColorsYueYuanMain』整理成一份
/// AppColorsYueYuan
class
AppColorsYueYuan {
  const AppColorsYueYuan._();

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

  static const LinearGradient purpleGradientColors = LinearGradient(
    colors: [mainOrange, mainPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
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

  // 標籤顏色
  static const List<Color> tagColorList = [
    Color(0xffC7A8AF),
    Color(0xffBB9F93),
    Color(0xffB4A78F),
    Color(0xffAFB895),
    Color(0xff8AA995),
    Color(0xff93A4B5),
    Color(0xff999FB1),
    Color(0xd1d7d4fc)
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
  static const Color mainBg = Color(0xFFFCFCFC);
  static const Color mainPrimary = Color(0xFFFAD00C);
  static const Color mainSecondary = Color(0xFFFCEFD0);
  static const Color mainDisable = Color(0xFFE0E0E0);
  static const Color mainTextBlack = Color(0xFF422C29);
  static const Color mainTextDarkGray = Color(0xFF7F7F7F);
  static const Color mainTextTeal = Color(0xFF83C2C3);
  static const Color mainTextCoralRed = Color(0xFFED7272);
  static const Color mainSystemMeadowGreen = Color(0xFF94B662);
  static const Color mainSystemOrangeRed = Color(0xFFDE5500);





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
  static const Color progressbarIndicatorColors = AppColorsYueYuanMain.goldsGold;
  static const Color progressbarLineColors = AppColorsYueYuanMain.darkSecondary;

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
      AppColorsYueYuanMain.supportiveBlue,
      AppColorsYueYuanMain.supportiveBlue
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonChooseFemale = LinearGradient(
    colors: [
      AppColorsYueYuanMain.supportiveGirl,
      AppColorsYueYuanMain.supportiveGirl
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient buttonUnChooseGender = const LinearGradient(
    colors: [
      AppColorsYueYuanMain.darkSecondary,
      AppColorsYueYuanMain.darkSecondary
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

  ///cat
  static const Color appBarBackgroundColor = AppColorsYueYuanMain.darkBg;
  static const Color modifyDataButtonColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color tabBarBackgroundColor =  Color(0xffF2ECDF);
  static const Color missionAppBarBgColor =  Color.fromRGBO(255, 248, 235, 1);
  static const Color marqueeBackgroundColor =  Color.fromRGBO(56, 48, 34, 1);
  static const Color marqueeImageColor =  Color.fromRGBO(197, 168, 124, 1);
  static const Color baseBackgroundColor =  Color.fromRGBO(244, 228, 196, 1);
  static const Color switchActiveColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color switchInactiveColor = AppColorsYueYuanMain.darkDarkerText;
  static const Color chatRoomBottomBackgroundColor = AppColorsYueYuanMain.darkTab;
  static const Color chatRoomFunctionIconColor = AppColorsYueYuanMain.darkDarkerText;
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
  static const Color textFieldBackgroundColor = AppColorsYueYuanMain.darkRectangle;
  static const Color textFieldBorderColor = AppColorsYueYuanMain.darkDarkerText;
  static const Color labelTextColor = mainBrown;
  static const Color editAudioBeginRecordTitleColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color editAudioBeginRecordHintColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color editAudioBeginRecordTimeColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color editAudioBeginRecordUnRecordIconColor= mainBrown;
  static const Color editAudioBeginRecordRecordIconColor= AppColorsYueYuanMain.goldsGoldText;
  static const Color editAudioBeginRecordUnRecordBackgroundColor= Colors.transparent;
  static const Color editAudioBeginRecordRecordBackgroundColor=Color.fromRGBO(123, 81, 74, 0.5);
  static const Color editAudioBeginRecordIconProgressBordColor= mainBrown;
  static const Color editAudioBeginRecordBackgroundColor= Color.fromRGBO(232, 210, 194, 1);
  static const Color editAudioBeginRecordBordColor= mainBrown;
  static const Color editAudiodTitleColor= AppColorsYueYuanMain.absoluteWhite;
  static const Color editAudiodTextFieldBackgroundColor= AppColorsYueYuanMain.darkRectangle;
  static const Color editAudiodTextFieldHintColor= AppColorsYueYuanMain.absoluteWhite;
  static const LinearGradient editAudioBeginRecordDoneBackgroundColor = btnLightYellowColors;
  static const Color myTagColor= AppColorsYueYuanMain.darkSecondary;
  static const Color myTagTextColor = AppColorsYueYuanMain.absoluteWhite;
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
      Color.fromRGBO(56, 48, 34, 1),
      Color.fromRGBO(56, 48, 34, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  ///jerry
  static const Color myBubbleBackgroundColor = Color.fromRGBO(143, 122, 90, 1);
  static const Color otherSideBubbleBackgroundColor = Color.fromRGBO(64, 64, 64, 1);


  // Chris
  static const Color benefitActiveBtnColor = Color(0xff7B514A);
  static const Color benefitUnActiveBtnColor = Color(0xffFFF8EB);
  static const Color benefitActiveTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color benefitUnActiveTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color benefitPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color benefitSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color benefitInfoTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color benefitLinkTextColor = AppColorsYueYuanMain.supportiveBlue;
  static const Color homeTabBarColor = AppColorsYueYuanMain.darkTab;
  static const Color homeTabBarUnSelect = AppColorsYueYuanMain.darkDarkerText;
  static const Color homeTabBarStrikeUpSelected = AppColorsYueYuanMain.goldsGoldText;
  static const Color homeTabBarActivitySelected = AppColorsYueYuanMain.goldsGoldText;
  static const Color homeTabBarVideoSelected = AppColorsYueYuanMain.goldsGoldText;
  static const Color homeTabBarMessageSelected = AppColorsYueYuanMain.goldsGoldText;
  static const Color homeTabBarProfileSelected = AppColorsYueYuanMain.goldsGoldText;
  static const Color descriptionTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color verifyCodeTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color inputFieldColor = AppColorsYueYuanMain.darkRectangle;
  static const Color dividerColor = AppColorsYueYuanMain.darkDarkerText;
  static const Color tvMainTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color tvSubTextColor = AppColorsYueYuanMain.darkText;
  static const Color tvTitleBgColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color tvTitleTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color tvTableBgColor =  AppColorsYueYuanMain.darkRectangle;
  static const Color userInfoViewNavigatorBgColor =  AppColorsYueYuanMain.darkTab;
  static const Color userInfoViewAudioTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color hintPillsTextColor =  AppColorsYueYuanMain.goldsGoldText;

  static const Color chatroomInformationBackGroundColor = Color.fromRGBO(38, 38, 38, 1);
  static const Color iconFriendsettingColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color commonLanguageAddIconColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color commonLanguageCustomDeleteIconColor = AppColorsYueYuanMain.supportiveError;
  static const Color freindSettingPageItemBackGroundColor = Color.fromRGBO(38, 38, 38, 1);

  static const Color textFieldFocusingColor = Color.fromRGBO(93, 153, 237, 1);
  static const Color howToTVUnderLineColor = Color.fromRGBO(131, 194, 195, 1);



  static const LinearGradient strikeUpListMarqueeBackgroundColor = LinearGradient(
    colors:  [
      Colors.white,
      Colors.white
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient maleActiveBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColorsYueYuanMain.supportiveBlue, AppColorsYueYuanMain.supportiveBlue],
  );

  static const LinearGradient femaleActiveBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColorsYueYuanMain.supportiveGirl, AppColorsYueYuanMain.supportiveGirl],
  );


  static const Color bottomSheetBackgroundColor = Color.fromRGBO(255, 255, 255, 0.2);
  static Color checkedInBgColor = AppColorsYueYuanMain.goldsGoldText.withOpacity(0.4);
  static const Color notCheckInBgColor = AppColorsYueYuanMain.darkSecondary;
  static const Color checkInBtnTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color checkInTitleTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color personalProfilePrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color personalProfileSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color friendEmptyPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color friendEmptySecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color visitorEmptyPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color visitorEmptySecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color tabBarBgColor = AppColorsYueYuanMain.darkTab;
  static const Color tabBarIndicatorBgColor = AppColorsYueYuanMain.darkSecondary;
  static const Color tabBarSelectTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color tabBarUnSelectTextColor = AppColorsYueYuanMain.darkText;

  static const Color friendPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color friendSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color visitorPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color visitorSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color visitorSeenTextColor = AppColorsYueYuanMain.goldsGoldText;


  // Mission
  static const Color goToTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color receiveTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color completedTextColor = AppColorsYueYuanMain.darkText;
  static const Color missionTitleTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color missionPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color missionSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color chatroomTextFieldBackGroundColor =  Color.fromRGBO(25, 25, 25, 1);
  static const Color chatroomTextFieldFontColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color freindSettingPageItemBorderColor =  Color.fromRGBO(102, 102, 102, 1);
  static const Color giftAndBagMainColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color intimacyRuleContentBorderColor =  Color.fromRGBO(102, 102, 102, 1);
  static const Color intimacyWidgetBackGroundColor =  Color.fromRGBO(255, 255, 225, 0.15);
  static const Color intimacyRuleContentTitleTextColor =  Color.fromRGBO(255, 255, 225, 1);
  static const Color intimacyDialogCurrentIntimacyTextColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color intimacyDialogDifferenceInIntimacyTextColor =  AppColorsYueYuanMain.supportiveError;
  static const Color intimacyDialogNextStageOfRelationshipTextColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color iconIntimacyCheckColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color iconIntimacyLockColor =  AppColorsYueYuanMain.darkText;

  static const Color personalCertifiedTextColor =  AppColorsYueYuanMain.darkText;
  static const Color personalUncertifiedTextColor =  AppColorsYueYuanMain.absoluteBlack;
  static const Color personalProcessCertificationTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color personalProcessCertificationHintBgColor =  AppColorsYueYuanMain.darkGold;
  static const Color personalProcessCertificationHintTextColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color customServicePrimaryTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color customServiceSecondaryTextColor =  AppColorsYueYuanMain.darkText;
  static const Color customServiceAppbarColor =  AppColorsYueYuanMain.darkTab;
  static const Color customServiceBgColor =  AppColorsYueYuanMain.darkBg;
  static const Color registerGenderSelectTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color registerGenderUnSelectTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color userInfoViewCellNameTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color userInfoViewCellTitleTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color userInfoViewCellPrimaryTextColor =  AppColorsYueYuanMain.darkText;
  static const Color userInfoViewCellSecondaryTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color userInfoViewEditTextColor =  AppColorsYueYuanMain.goldsGoldText;
  static const Color blockBannerPrimaryTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color blockBannerSecondaryTextColor =  AppColorsYueYuanMain.darkSecondary;
  static const Color teenBannerPrimaryTextColor =  AppColorsYueYuanMain.absoluteWhite;
  static const Color teenBannerSecondaryTextColor =  AppColorsYueYuanMain.darkText;

  // Common
  static const Color btnConfirmTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color btnCancelTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color btnDisableTextColor = AppColorsYueYuanMain.darkText;
  static const Color intimacyStepsLineColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color intimacyStepsTagBackGroundColor = AppColorsYueYuanMain.darkGold;
  static const Color messageTabActionColor = AppColorsYueYuanMain.darkText;
  static const Color commonButtonContentBackGroundColor = AppColorsYueYuanMain.darkSecondary;
  static const Color commonButtonCancelBackGroundColor = AppColorsYueYuanMain.darkDarkerText;
  static const Color reportPageTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color reportPageAddImageBorderColor = AppColorsYueYuanMain.darkSecondary;
  static const Color reportPageAddImageBackgroundColor = AppColorsYueYuanMain.darkSecondary;
  static const Color reportTextFieldBorderColor = AppColorsYueYuanMain.darkDarkerText;
  static const Color promotionCenterChannelButtonBackgroundColor = AppColorsYueYuanMain.darkSecondary;
  static const Color commonButtonDeleteTextColor = AppColorsYueYuanMain.supportiveError;
  static const Color pickerTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color withdrawAccountBindPrimaryTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color withdrawAccountBindSecondaryTextColor = AppColorsYueYuanMain.darkText;
  static const Color withdrawAccountBindLinkTextColor = AppColorsYueYuanMain.supportiveBlue;
  static const Color withdrawAccountBindBoxColor = AppColorsYueYuanMain.darkDarkerText;

  static const Color registerAwardGiftTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color registerAwardCoinTextColor = AppColorsYueYuanMain.goldsGoldText;
  static const Color tvSelectedTextColor = AppColorsYueYuanMain.absoluteBlack;
  static const Color userInfoViewRemarkTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color userInfoViewReportTextColor = AppColorsYueYuanMain.supportiveError;
  static const Color userInfoViewBlockTextColor = AppColorsYueYuanMain.supportiveError;
  static const Color bottomSheetCallTitleTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color bottomSheetCallSubTitleTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color blockCellTitleTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color blockCellDesTextColor = AppColorsYueYuanMain.darkText;
  static const Color depositBottomSheetCoinTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color depositBottomSheetAmountTextColor = AppColorsYueYuanMain.goldsGoldText;
  static Color indicatorColor = const Color.fromRGBO(0, 0, 0, 0.5);
  static const Color tagHintTextColor = AppColorsYueYuanMain.absoluteWhite;
  static const Color realPersonAuthHintError = AppColorsYueYuanMain.supportiveError;
  static const Color bannerIndicatorColor = AppColorsYueYuanMain.darkTab;
}

