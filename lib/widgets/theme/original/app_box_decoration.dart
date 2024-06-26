import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

@immutable
class
AppBoxDecoration {
  const AppBoxDecoration._();
  static BoxDecoration strikeUpListMarqueeBoxDecoration =  BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    gradient:AppColors.strikeUpListMarqueeBackgroundColor,
  );

  static BoxDecoration personalPropertyBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Color(0xffF9F9F9),
  );

  static BoxDecoration checkInBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: Color(0xffEAEAEA)),
      color: Colors.white
  );

  static BoxDecoration personalProfileCellListBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white
  );

  static BoxDecoration userInfoViewDataCellBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(width: 1, color: Color(0xffEAEAEA)),
      color: Colors.white
  );

  static BoxDecoration strikeUpTvBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(width: 1, color: Color(0xffFFFFFF)),
      color: Colors.white
  );

  static BoxDecoration tvSelectedBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: AppColors.mainPink),
      color: Colors.white
  );

  static BoxDecoration tvUnSelectBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: Colors.white),
      color: Colors.white
  );

  static BoxDecoration tvSelectedTextBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(99),
    gradient: AppColors.pinkLightGradientColors,
  );

  static BoxDecoration userInfoViewAudioBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      border: Border.all(width: 1, color: AppColors.mainPink),
      color: Colors.white
  );

  static BoxDecoration personalProfileEditBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(99),
        bottomLeft: Radius.circular(99)
    ),
    color: Color.fromRGBO(0, 0, 0, 0.3),
  );

  static BoxDecoration personalEditBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white
  );

  static BoxDecoration albumCellBoxDecoration = BoxDecoration(
    border: Border.all(width: 1, color: AppColors.dividerGrey),
    borderRadius: BorderRadius.circular(8),
    color: Colors.white
  );

  static BoxDecoration dialogBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white
  );
  static BoxDecoration awardDailyTagBoxDecoration = BoxDecoration(
    color:  Color.fromRGBO(255, 194, 80, 1),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

  static BoxDecoration hintPillsBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      color: Color(0xffFDF1F6)
  );

  static BoxDecoration checkInBtnBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(99),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF5C370),
        Color(0xFFEE813B),
      ],
    )
  );

  static BoxDecoration checkInBtnDisableBoxDecoration = BoxDecoration(
    color: AppColors.mainGrey,
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration cellBoxDecoration = BoxDecoration(
      border: Border.all(width: 1, color: AppColors.mainPaleGrey),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white
  );

  static BoxDecoration tagTextBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: Color(0xffEAEAEA),
  );

  static BoxDecoration normalTextFieldBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(width: 1,color: Color(0xffEAEAEA)),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  static BoxDecoration cellSelectBoxDecoration = BoxDecoration(
      border: Border.all(width: 1, color: AppColors.mainPink),
      borderRadius: BorderRadius.circular(12),
      color:  const Color(0xFFFFEBF2)
  );

  static BoxDecoration editAudioInitBoxDecoration = const BoxDecoration(
    color: Color(0xffD9D9D9),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration editAudioDoneBoxDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffFF3179),Color(0xffFF7B31)],
    ),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration editAudioChangeWordBoxDecoration = const BoxDecoration(
    color: Color(0xffF5E9EE),
    borderRadius: BorderRadius.all(Radius.circular(99)),
  );
  static BoxDecoration strikeUpMateDialogChargeBoxDecoration = BoxDecoration(
    color:Colors.white,
    borderRadius: BorderRadius.circular(24),
  );

  // Mission
  static BoxDecoration goToBtnBoxDecoration = BoxDecoration(
    color: Color(0xffFF3179),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration receiveBtnBoxDecoration = BoxDecoration(
    color: Color(0xffFFBE3F),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration completedBtnBoxDecoration = BoxDecoration(
    color: Color(0xffD9D9D9),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration activityPostButtonBoxDecoration = const BoxDecoration(
    gradient: AppColors.pinkLightGradientColors,
    shape: BoxShape.circle,
    // borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
    boxShadow: [BoxShadow(color:AppColors.mainGrey, blurRadius: 10)],
  );

  static BoxDecoration btnConfirmBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffEB5D8E), Color(0xffF08ABF)],
    ),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration btnCancelBoxDecoration = BoxDecoration(
    color: const Color(0xffF2E7EC),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration btnDisableBoxDecoration = BoxDecoration(
    color: const Color(0xffB4B5B6),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration activityHotTopicsBannerBoxDecoration =  BoxDecoration(
      gradient: AppColors.topicsBannerGradientColors,
      borderRadius: BorderRadius.circular(16)
  );

  static BoxDecoration activityHotTopicsPostBoxDecoration = BoxDecoration(
      color: AppColors.whiteBackGround,
      borderRadius: BorderRadius.circular(8)
  );

  static BoxDecoration activityHotTopicsTagBoxDecoration = BoxDecoration(
      color: AppColors.whiteBackGround,
      borderRadius: BorderRadius.circular(16)
  );

  static BoxDecoration activityHotTopicsBackgroundBoxDecoration = const BoxDecoration(
      gradient: AppColors.hotTopicsPageGradientColors
  );

  static BoxDecoration activityHotTopicsListContentBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color:AppColors.mainBlack.withOpacity(0.1), blurRadius: 10)],
  );

  static BoxDecoration activityTopicsAppBarBoxDecoration = const BoxDecoration(
      gradient: AppColors.topicsBannerGradientColors
  );

  static BoxDecoration activityPostReplyInputBoxDecoration = const BoxDecoration(
    color: Colors.white,
    border: Border(
      top: BorderSide(
        color: Color(0xffF4F5F7),
        width: 1.0,
      ),
    ),
  );

  static BoxDecoration activityPostReplyPostButtonBoxDecoration = const BoxDecoration(
    color: Color(0xffFD73A5),
    borderRadius: BorderRadius.all(Radius.circular(99)),
  );

  static BoxDecoration activityPostReplyPostButtonDisableBoxDecoration = const BoxDecoration(
    color:Color(0xffCFCFCF),
    borderRadius: BorderRadius.all(Radius.circular(99),
    ),
  );

  static BoxDecoration personalCertificationCellBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration personalCertifiedBoxDecoration = BoxDecoration(
    color: Color(0xffEAEAEA),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalUncertifiedBoxDecoration = BoxDecoration(
    color: Color(0xffFF3179),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalProcessCertificationBoxDecoration = BoxDecoration(
    color: Color(0xff444648),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration certificationStepBoxDecoration = BoxDecoration(
      color: Color(0xffFAFAFA),
      borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration customServiceCellBoxDecoration = BoxDecoration(
    color: Color(0xffFFFFFFF),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration registerAgeBoxDecoration = BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Color(0xffEAEAEA),
        width: 1.0,
      )
  );

  static BoxDecoration tagGenderAgeFemaleBoxDecoration = BoxDecoration(
    color: Color(0xffFD73A5),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration tagGenderAgeMaleBoxDecoration = BoxDecoration(
    color: Color(0xff54B5DF),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration tagCharmLevelBoxDecoration = BoxDecoration(
    color: const Color(0xff9469BB),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xffCD9DFB), Color(0xff37AFF3)],
      ),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration userInfoViewEditBtnBoxDecoration = BoxDecoration(
      color: Color(0xffF9E2E7),
      borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration userInfoViewStrikeBtnBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffEB5D8E),Color(0xffF08ABF)],
    ),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration userInfoViewChatBtnBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff0052B4),Color(0xff338AF3)],
    ),
    borderRadius: BorderRadius.circular(99),
  );

  static BoxDecoration personalAgentItemBoxDecoration = BoxDecoration(
      border: Border.all(width: 1,color:AppColors.globalBackGround ),
      borderRadius: BorderRadius.circular(16),
      color: Colors.white
  );

  static BoxDecoration benefitSelectViewBoxDecoration = BoxDecoration(
    border: Border.all(width: 1,color:  Color(0xffEAEAEA)),
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration benefitTabActiveBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffEB5D8E),Color(0xffF08ABF)],//RGB(255, 210, 144, 1) ,RGB(195, 166, 123, 1)
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitTabUnActiveBoxDecoration = BoxDecoration(
    color: Color(0xffFFEAF2),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitItemSelectedBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffEB5D8E),Color(0xffF08ABF)],
    ),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      width: 1,
      color: Color(0xffEA2E01),
    )
  );

  static BoxDecoration benefitItemUnSelectBoxDecoration = BoxDecoration(
    color: Color(0xffFFEAF2),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration benefitItemDisableBoxDecoration = BoxDecoration(
    color: Color(0xffFAFAFA),
    borderRadius: BorderRadius.circular(12),
  );
  static BoxDecoration personalAgentTabbarBoxDecoration = BoxDecoration(
    color: AppColors.tabBarBgColor,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalAgentTabbarIndicatorBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration withdrawAccountBoxDecoration = BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(width: 1,color: Color(0xffEAEAEA)),
  );

  static BoxDecoration personalGreetModelNameTagBoxDecoration = BoxDecoration(
    color: AppColors.mainPink,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelUseTagBoxDecoration = BoxDecoration(
    color: Color(0xffFF3179),
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelReviewTagBoxDecoration = BoxDecoration(
    color: AppColors.mainPaleGrey,
    borderRadius: BorderRadius.circular(48),
  );

  static BoxDecoration personalGreetModelEditTagBoxDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(48),
    border: Border.all(width: 1, color: AppColors.textBlack),
  );

  static BoxDecoration personalGreetAddRecordBoxDecoration = BoxDecoration(
    color: AppColors.mainGrey,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration personalGreetAddRecordFinishBoxDecoration = BoxDecoration(
    gradient: AppColors.pinkGradientColors,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration versionUpdateNowBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffEC6193),Color(0xffEC6193)],
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration versionUpdateLaterBoxDecoration = const BoxDecoration(
    color: Colors.transparent,
  );

  static BoxDecoration unReadMsgSwiperBoxDecoration = BoxDecoration(
    gradient: AppColors.pinkLightGradientColors,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration unReadMsgCountBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: const Color(0xffF44236),
  );
}