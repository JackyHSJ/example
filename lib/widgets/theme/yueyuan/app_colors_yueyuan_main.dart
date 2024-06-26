import 'package:flutter/material.dart';

@immutable

/// TODO:『AppColorsYueYuan』整理成一份
class
AppColorsYueYuanMain {
  const AppColorsYueYuanMain._();

  static const Color absoluteWhite = Color(0xffFFFFFF); //RGB(255,255,255,1)
  static const Color absoluteBlack = Color(0xff000000); //RGB(0,0,0,1)

  static const Color supportiveBlue = Color(0xff4595B8); //RGB(69, 149, 184, 1)
  static const Color supportiveGirl = Color(0xffD76790); //RGB(215, 103, 144, 1)
  static const Color supportiveError = Color(0xffDE5500); //RGB(222, 85, 0, 1)
  static const Color supportiveSuccess = Color(0xff94B662); //RGB(148, 182, 98, 1)

  static const Color darkBg = Color(0xff111111); //RGB(17,17,17,1)
  static const Color darkRectangle = Color(0xff191919); //RGB(25,25,25,1)
  static const Color darkTab = Color(0xff202020); //RGB(32,32,32,1)
  static const Color darkStroke = Color(0xff262626); //RGB(38, 38, 38, 1)
  static const Color darkSecondary = Color(0xff404040); //RGB(64, 64, 64, 1)
  static const Color darkDisabled = Color(0xff555555); //RGB(85, 85, 85, 1)
  static const Color darkDarkerText = Color(0xff666666); //RGB(102, 102, 102, 1)
  static const Color darkText = Color(0xff98989A) ;//RGB(152, 152, 154, 1)


  static const Color goldsGoldText = Color(0xffC5A87C); //RGB(197, 168, 124, 1)
  static const Color goldsGold = Color(0xffFFD290); //RGB(255, 210, 144, 1)
  static const Color goldsGold2 = Color(0xffC79160); //RGB(255, 210, 144, 1)
  static const Color darkGold = Color(0xff383022); //RGB(56, 48, 34, 1)


  static const LinearGradient goldsGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldsGold,Color(0xffC3A67B)],//RGB(255, 210, 144, 1) ,RGB(195, 166, 123, 1)
  );

  static const LinearGradient personalSettingCharmDialogLeftButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(64, 64, 64, 1),
      Color.fromRGBO(64, 64, 64, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient personalSettingCharmDialogRightButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(250, 210, 144, 1),
      Color.fromRGBO(195, 166, 123, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient intimacyStepsUnGetLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(152, 152, 154, 1),
      Color.fromRGBO(152, 152, 154, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient callingPageBeautyButtonLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 210, 144, 1),
      Color.fromRGBO(195, 166, 123, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient officialAnnouncementLinearGradient = LinearGradient(
    colors: [supportiveBlue,supportiveBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialRewardsLinearGradient = LinearGradient(
    colors: [supportiveSuccess,supportiveSuccess],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialMissionCompletedLinearGradient = LinearGradient(
    colors: [goldsGoldText,goldsGoldText],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialReviewLinearGradient = LinearGradient(
    colors: [supportiveError, supportiveError],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient officialCharmLevelIncreaseLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(148, 105, 187, 1),
      Color.fromRGBO(148, 105, 187, 1),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialReportLinearGradient = LinearGradient(
    colors: [
      absoluteBlack,
      absoluteBlack
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient officialFreezeLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(0,40,87, 1),
      Color.fromRGBO(0,40,87, 1),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient giftAndBagChargeTextColor = LinearGradient(
    colors: [goldsGoldText, goldsGoldText],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient intimacyRuleContentBackGroundColor = LinearGradient(
    colors: [ Color.fromRGBO(25, 25, 25, 1), Color.fromRGBO(25, 25, 25, 1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient intimacyDialogDividerColor = LinearGradient(
    colors: [ darkDarkerText, darkDarkerText],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient intimacyStepsColor = LinearGradient(
    colors: [goldsGold, Color.fromRGBO(195, 166, 123, 1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient unReadBackGroundColor = LinearGradient(
    colors: [supportiveError, supportiveError],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldsButtonBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffE2BD86),Color(0xffC3A67B)],//RGB(255, 210, 144, 1) ,RGB(195, 166, 123, 1)
  );

  static const LinearGradient goldsGold2Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFf2B781), Color(0xFFc79160)]//RGB(242, 183, 129, 1) ,RGB(199, 145, 96, 1)
  );

  static const LinearGradient darkSecondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSecondary,darkSecondary],//RGB(64, 64, 64, 1) ,RGB(64, 64, 64, 1)
  );
  static const LinearGradient darkDisabledGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkDisabled,darkDisabled],//RGB(64, 64, 64, 1) ,RGB(64, 64, 64, 1)
  );

  static const LinearGradient darkRectangleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkRectangle,darkRectangle],//RGB(25,25,25,1) ,RGB(25,25,25,1)
  );

  static const LinearGradient supportiveBlueGradient = LinearGradient(
    begin:  Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [supportiveBlue,supportiveBlue],//RGB(69, 149, 184, 1) ,RGB(69, 149, 184, 1)
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBg,darkBg],//RGB(17,17,17,1) ,RGB(17,17,17,1)
  );
}

