import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/yueyuan/app_colors_yueyuan.dart';
import 'package:frechat/widgets/theme/yueyuan/app_colors_yueyuan_main.dart';

@immutable
class
AppBoxDecorationYueyuan {
  const AppBoxDecorationYueyuan._();
  static BoxDecoration strikeUpListMarqueeBoxDecoration =  BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkStroke),
    gradient:AppColorsYueYuanMain.darkRectangleGradient,
  );

  static BoxDecoration personalPropertyBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
    color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration checkInBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration personalProfileCellListBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration userInfoViewDataCellBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkStroke),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration strikeUpTvBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration tvSelectedBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.goldsGoldText),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration tvUnSelectBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkStroke),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration tvSelectedTextBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(99),
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
  );

  static BoxDecoration userInfoViewAudioBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.goldsGoldText),
      color: AppColorsYueYuanMain.darkSecondary
  );

  static BoxDecoration personalProfileEditBoxDecoration = const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(99),
        bottomLeft: Radius.circular(99)
      ),
      color: Color.fromRGBO(255, 255, 255, 0.4),
  );

  static BoxDecoration personalEditBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration albumCellBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: AppColorsYueYuanMain.darkSecondary
  );

  static BoxDecoration hintPillsBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      color: AppColorsYueYuanMain.darkGold
  );

  static BoxDecoration checkInBtnBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      gradient: AppColorsYueYuanMain.goldsGoldGradient
  );

  static BoxDecoration checkInBtnDisableBoxDecoration = BoxDecoration(
      color: AppColors.mainGrey,
      borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration checkInBtnBoxDisableDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      gradient: AppColorsYueYuanMain.goldsGoldGradient
  );

  static BoxDecoration cellBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(width: 1, color: AppColorsYueYuanMain.darkDarkerText),
    color: AppColorsYueYuanMain.darkRectangle
  );
  static BoxDecoration cellSelectBoxDecoration = BoxDecoration(
      border: Border.all(width: 1, color: AppColorsYueYuanMain.goldsGoldText),
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xFFC5A87C).withOpacity(0.3),
  );

  static BoxDecoration tagTextBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: AppColorsYueYuanMain.darkStroke
  );

  static BoxDecoration dialogBoxDecoration = BoxDecoration(
      border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
      borderRadius: BorderRadius.circular(16),
      color: AppColorsYueYuanMain.darkRectangle
  );
  static BoxDecoration awardDailyTagBoxDecoration = BoxDecoration(
    color:  AppColorsYueYuanMain.goldsGold,
    border: Border.all(width: 1,color: Colors.white),
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  );

  static BoxDecoration normalTextFieldBoxDecoration = BoxDecoration(
    color:  AppColorsYueYuanMain.darkRectangle,
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration editAudioInitBoxDecoration = BoxDecoration(
    color:  AppColorsYueYuanMain.darkRectangle,
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration editAudioDoneBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration editAudioChangeWordBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkRectangle,
    border: Border.all(width: 1,color: AppColorsYueYuanMain.goldsGoldText),
    borderRadius: const BorderRadius.all(Radius.circular(99)),
  );

  static BoxDecoration strikeUpMateDialogChargeBoxDecoration = BoxDecoration(
    color:AppColorsYueYuanMain.darkTab,
    borderRadius: BorderRadius.circular(24),
  );

  // Mission
  static BoxDecoration goToBtnBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration receiveBtnBoxDecoration = BoxDecoration(
    border: Border.all(width: 1,color: AppColorsYueYuanMain.goldsGoldText),
    color:AppColorsYueYuanMain.darkRectangle,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration completedBtnBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkDisabled,
    borderRadius: BorderRadius.circular(99),
  );


  static BoxDecoration activityPostButtonBoxDecoration = const BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    shape: BoxShape.circle,
    boxShadow: [BoxShadow(color:AppColors.mainGrey, blurRadius: 10)],
  );

  static BoxDecoration btnConfirmBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration btnCancelBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration btnDisableBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkDisabled,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration activityHotTopicsBannerBoxDecoration =  BoxDecoration(
      gradient: AppColorsYueYuanMain.darkRectangleGradient,
      border: Border.all(width: 1,color: AppColorsYueYuanMain.goldsGoldText),
      borderRadius: BorderRadius.circular(16)
  );

  static BoxDecoration activityHotTopicsPostBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkStroke,
      borderRadius: BorderRadius.circular(8)
  );

  static BoxDecoration activityHotTopicsTagBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkStroke,
      borderRadius: BorderRadius.circular(16)
  );

  static BoxDecoration activityHotTopicsBackgroundBoxDecoration = const BoxDecoration(
      gradient:const LinearGradient(colors:[ Color(0xff8F7959), Color(0xff5E4C31)]),
  );

  static BoxDecoration activityHotTopicsListContentBoxDecoration = BoxDecoration(
    color: Colors.black.withOpacity(0.4),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color:AppColors.mainBlack.withOpacity(0.1), blurRadius: 10)],
  );

  static BoxDecoration activityTopicsAppBarBoxDecoration = const BoxDecoration(
    color: AppColorsYueYuanMain.darkTab,
  );

  static BoxDecoration activityPostReplyInputBoxDecoration = const BoxDecoration(
    color: AppColorsYueYuanMain.darkTab,
    border: Border(
      top: BorderSide(
        color: AppColorsYueYuanMain.darkStroke,
        width: 1.0,
      ),
    ),
  );

  static BoxDecoration activityPostReplyPostButtonBoxDecoration = const BoxDecoration(
    gradient:AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.all(Radius.circular(99)),
  );

  static BoxDecoration activityPostReplyPostButtonDisableBoxDecoration = const BoxDecoration(
    color: AppColorsYueYuanMain.darkDisabled,
    borderRadius: BorderRadius.all(Radius.circular(99),
    ),
  );

  static BoxDecoration personalCertificationCellBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkRectangle,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColorsYueYuanMain.darkDarkerText,
      width: 1.0,
    )
  );

  static BoxDecoration personalCertifiedBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkDisabled,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalUncertifiedBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalProcessCertificationBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkSecondary,
      borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration certificationStepBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkRectangle,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColorsYueYuanMain.darkDarkerText,
        width: 1.0,
      )
  );

  static BoxDecoration customServiceCellBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkRectangle,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColorsYueYuanMain.darkDarkerText,
        width: 1.0,
      )
  );

  static BoxDecoration registerAgeBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.darkRectangle,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColorsYueYuanMain.darkDarkerText,
        width: 1.0,
      )
  );

  static BoxDecoration tagGenderAgeFemaleBoxDecoration = BoxDecoration(
      color: AppColorsYueYuanMain.supportiveGirl,
      borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration tagGenderAgeMaleBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.supportiveBlue,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration tagCharmLevelBoxDecoration = BoxDecoration(
    color: const Color(0xff9469BB),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration userInfoViewEditBtnBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkRectangle,
    borderRadius: BorderRadius.circular(99),
    border: Border.all(
      color: AppColorsYueYuanMain.goldsGoldText,
      width: 1.0,
    )
  );

  static BoxDecoration userInfoViewStrikeBtnBoxDecoration = BoxDecoration(
      gradient: AppColorsYueYuanMain.goldsGoldGradient,
      borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration userInfoViewChatBtnBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalAgentItemBoxDecoration = BoxDecoration(
      border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
      borderRadius: BorderRadius.circular(16),
      color: AppColorsYueYuanMain.darkRectangle
  );

  static BoxDecoration benefitSelectViewBoxDecoration = BoxDecoration(
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
    color: AppColorsYueYuanMain.darkRectangle,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration benefitTabActiveBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColorsYueYuanMain.goldsGold, Color(0xffC3A67B)],
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitTabUnActiveBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitItemSelectedBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColorsYueYuanMain.goldsGold, Color(0xffC3A67B)],
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitItemUnSelectBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitItemDisableBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkDisabled,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration personalAgentTabbarBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkTab,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalAgentTabbarIndicatorBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(48),
  );

  static TextStyle profileContactTodayTitleTextStyle = const TextStyle(
    color: Color(0xffFFBE3F),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static BoxDecoration withdrawAccountBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkRectangle,
    border: Border.all(width: 1,color: AppColorsYueYuanMain.darkDarkerText),
    borderRadius: BorderRadius.circular(12),
  );


  static BoxDecoration personalGreetModelNameTagBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.goldsGoldText,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelUseTagBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.supportiveSuccess,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelReviewTagBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelEditTagBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetAddRecordBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkRectangle,
    borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppColorsYueYuanMain.darkDarkerText,
        width: 1.0,
      )
  );

  static BoxDecoration personalGreetAddRecordFinishBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration versionUpdateNowBoxDecoration = BoxDecoration(
    gradient: AppColorsYueYuanMain.goldsGoldGradient,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration versionUpdateLaterBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkSecondary,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration unReadMsgSwiperBoxDecoration = BoxDecoration(
    color: AppColorsYueYuanMain.darkTab,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      width: 1,
      color: AppColorsYueYuanMain.darkDarkerText
    ),
  );

  static BoxDecoration unReadMsgCountBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(99),
    color: const Color(0xffEC6193),
  );

}