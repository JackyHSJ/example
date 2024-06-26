import 'package:flutter/material.dart';
import 'package:frechat/system/zego_call/components/zego_defines.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_item.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';


class ZegoBeautyData {
  static List<ZegoEffectModel> get data => [
        basicModel,
        advancedModel,
        filtersModel,
        lipsModel,
        blusherModel,
        eyelashesModel,
        eyelinerModel,
        eyeshadowModel,
        coloredContactsModel,
        styleMakeupModel,
        // stickersModel,
        // backgroundModel,
      ];

  static ZegoEffectModel basicModel = ZegoEffectModel(
    title: '基本',
    type: ZegoEffectModelType.basic,
    items: [
      ZegoBeautyType.beautyBasicReset,
      ZegoBeautyType.beautyBasicSmoothing,
      ZegoBeautyType.beautyBasicSkinTone,
      ZegoBeautyType.beautyBasicBlusher,
      ZegoBeautyType.beautyBasicSharpening,
      ZegoBeautyType.beautyBasicWrinkles,
      ZegoBeautyType.beautyBasicDarkCircles,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel advancedModel = ZegoEffectModel(
      title: '进阶',
      type: ZegoEffectModelType.advanced,
      items: [
        ZegoBeautyType.beautyAdvancedReset,
        ZegoBeautyType.beautyAdvancedFaceSlimming,
        ZegoBeautyType.beautyAdvancedEyesEnlarging,
        ZegoBeautyType.beautyAdvancedEyesBrightening,
        ZegoBeautyType.beautyAdvancedChinLengthening,
        ZegoBeautyType.beautyAdvancedMouthReshape,
        ZegoBeautyType.beautyAdvancedTeethWhitening,
        ZegoBeautyType.beautyAdvancedNoseSlimming,
        ZegoBeautyType.beautyAdvancedNoseLengthening,
        ZegoBeautyType.beautyAdvancedFaceShortening,
        ZegoBeautyType.beautyAdvancedMandibleSlimming,
        ZegoBeautyType.beautyAdvancedCheekboneSlimming,
        ZegoBeautyType.beautyAdvancedForeheadSlimming,
      ].map((type) {
        return ZegoEffectItem(
          type: type,
          icon: icon(type),
          selectIcon: selectedIcon(type),
          iconText: beautyItemText(type),
          textStyle: textStyle(type),
          selectedTextStyle: selectedTextStyle(type),
        );
      }).toList());

  static ZegoEffectModel filtersModel = ZegoEffectModel(
    title: '滤镜',
    type: ZegoEffectModelType.filter,
    items: [
      ZegoBeautyType.filterReset,
      ZegoBeautyType.filterNaturalCreamy,
      ZegoBeautyType.filterNaturalBrighten,
      ZegoBeautyType.filterNaturalFresh,
      ZegoBeautyType.filterNaturalAutumn,
      ZegoBeautyType.filterGrayMonet,
      ZegoBeautyType.filterGrayNight,
      ZegoBeautyType.filterGrayFilmlike,
      ZegoBeautyType.filterDreamySunset,
      ZegoBeautyType.filterDreamyCozily,
      ZegoBeautyType.filterDreamySweet
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel lipsModel = ZegoEffectModel(
    title: '口红',
    type: ZegoEffectModelType.lipstick,
    items: [
      ZegoBeautyType.beautyMakeupLipstickReset,
      ZegoBeautyType.beautyMakeupLipstickCameoPink,
      ZegoBeautyType.beautyMakeupLipstickSweetOrange,
      ZegoBeautyType.beautyMakeupLipstickRustRed,
      ZegoBeautyType.beautyMakeupLipstickCoral,
      ZegoBeautyType.beautyMakeupLipstickRedVelvet,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel blusherModel = ZegoEffectModel(
    title: '腮红',
    type: ZegoEffectModelType.blusher,
    items: [
      ZegoBeautyType.beautyMakeupBlusherReset,
      ZegoBeautyType.beautyMakeupBlusherSlightlyDrunk,
      ZegoBeautyType.beautyMakeupBlusherPeach,
      ZegoBeautyType.beautyMakeupBlusherMilkyOrange,
      ZegoBeautyType.beautyMakeupBlusherAprocitPink,
      ZegoBeautyType.beautyMakeupBlusherSweetOrange,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel eyelashesModel = ZegoEffectModel(
    title: '睫毛',
    type: ZegoEffectModelType.eyelash,
    items: [
      ZegoBeautyType.beautyMakeupEyelashesReset,
      ZegoBeautyType.beautyMakeupEyelashesNatural,
      ZegoBeautyType.beautyMakeupEyelashesTender,
      ZegoBeautyType.beautyMakeupEyelashesCurl,
      ZegoBeautyType.beautyMakeupEyelashesEverlong,
      ZegoBeautyType.beautyMakeupEyelashesThick,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel eyelinerModel = ZegoEffectModel(
    title: '眼线',
    type: ZegoEffectModelType.eyeliner,
    items: [
      ZegoBeautyType.beautyMakeupEyelinerReset,
      ZegoBeautyType.beautyMakeupEyelinerNatural,
      ZegoBeautyType.beautyMakeupEyelinerCatEye,
      ZegoBeautyType.beautyMakeupEyelinerNaughty,
      ZegoBeautyType.beautyMakeupEyelinerInnocent,
      ZegoBeautyType.beautyMakeupEyelinerDignified,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel eyeshadowModel = ZegoEffectModel(
    title: '眼影',
    type: ZegoEffectModelType.eyeshadow,
    items: [
      ZegoBeautyType.beautyMakeupEyeshadowReset,
      ZegoBeautyType.beautyMakeupEyeshadowPinkMist,
      ZegoBeautyType.beautyMakeupEyeshadowShimmerPink,
      ZegoBeautyType.beautyMakeupEyeshadowTeaBrown,
      ZegoBeautyType.beautyMakeupEyeshadowBrightOrange,
      ZegoBeautyType.beautyMakeupEyeshadowMochaBrown,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel coloredContactsModel = ZegoEffectModel(
    title: '眼球',
    type: ZegoEffectModelType.coloredContacts,
    items: [
      ZegoBeautyType.beautyMakeupColoredContactsReset,
      ZegoBeautyType.beautyMakeupColoredContactsDarknightBlack,
      ZegoBeautyType.beautyMakeupColoredContactsStarryBlue,
      ZegoBeautyType.beautyMakeupColoredContactsBrownGreen,
      ZegoBeautyType.beautyMakeupColoredContactsLightsBrown,
      ZegoBeautyType.beautyMakeupColoredContactsChocolateBrown,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  static ZegoEffectModel styleMakeupModel = ZegoEffectModel(
    title: '造型',
    type: ZegoEffectModelType.style,
    items: [
      ZegoBeautyType.beautyStyleMakeupReset,
      ZegoBeautyType.beautyStyleMakeupInnocentEyes,
      ZegoBeautyType.beautyStyleMakeupMilkyEyes,
      ZegoBeautyType.beautyStyleMakeupCutieCool,
      ZegoBeautyType.beautyStyleMakeupPureSexy,
      ZegoBeautyType.beautyStyleMakeupFlawless,
    ].map((type) {
      return ZegoEffectItem(
        type: type,
        icon: icon(type),
        selectIcon: selectedIcon(type),
        iconText: beautyItemText(type),
        textStyle: textStyle(type),
        selectedTextStyle: selectedTextStyle(type),
      );
    }).toList(),
  );

  // static ZegoEffectModel stickersModel = ZegoEffectModel(
  //   title: 'Stickers',
  //   type: ZegoEffectModelType.sticker,
  //   items: [
  //     ZegoBeautyType.stickerReset,
  //     ZegoBeautyType.stickerAnimal,
  //     ZegoBeautyType.stickerDive,
  //     ZegoBeautyType.stickerCat,
  //     ZegoBeautyType.stickerWatermelon,
  //     ZegoBeautyType.stickerDeer,
  //     ZegoBeautyType.stickerCoolGirl,
  //     ZegoBeautyType.stickerClown,
  //     ZegoBeautyType.stickerClawMachine,
  //     ZegoBeautyType.stickerSailorMoon,
  //   ].map((type) {
  //     return ZegoEffectItem(
  //       type: type,
  //       icon: icon(type),
  //       selectIcon: selectedIcon(type),
  //       iconText: beautyItemText(type),
  //       textStyle: textStyle(type),
  //       selectedTextStyle: selectedTextStyle(type),
  //     );
  //   }).toList(),
  // );

  // static ZegoEffectModel backgroundModel = ZegoEffectModel(
  //   title: 'Background',
  //   type: ZegoEffectModelType.background,
  //   items: [
  //     ZegoBeautyType.backgroundReset,
  //     ZegoBeautyType.backgroundPortraitSegmentation,
  //     ZegoBeautyType.backgroundMosaicing,
  //     ZegoBeautyType.backgroundGaussianBlur,
  //   ].map((type) {
  //     return ZegoEffectItem(
  //       type: type,
  //       icon: icon(type),
  //       selectIcon: selectedIcon(type),
  //       iconText: beautyItemText(type),
  //       textStyle: textStyle(type),
  //       selectedTextStyle: selectedTextStyle(type),
  //     );
  //   }).toList(),
  // );

  static String beautyItemText(ZegoBeautyType type) {
    switch (type) {
      // Basic
      case ZegoBeautyType.beautyBasicReset:
        return '重置';
      case ZegoBeautyType.beautyBasicSmoothing:
        return '平滑';
      case ZegoBeautyType.beautyBasicSkinTone:
        return '肤色';
      case ZegoBeautyType.beautyBasicBlusher:
        return '腮红';
      case ZegoBeautyType.beautyBasicSharpening:
        return '锐化';
      case ZegoBeautyType.beautyBasicWrinkles:
        return '皱纹';
      case ZegoBeautyType.beautyBasicDarkCircles:
        return '黑眼圈';

      // Advanced
      case ZegoBeautyType.beautyAdvancedReset:
        return '重置';
      case ZegoBeautyType.beautyAdvancedFaceSlimming:
        return '瘦脸';
      case ZegoBeautyType.beautyAdvancedEyesEnlarging:
        return '大眼';
      case ZegoBeautyType.beautyAdvancedEyesBrightening:
        return '明眸';
      case ZegoBeautyType.beautyAdvancedChinLengthening:
        return '下巴延长';
      case ZegoBeautyType.beautyAdvancedMouthReshape:
        return '嘴巴重塑';
      case ZegoBeautyType.beautyAdvancedTeethWhitening:
        return '牙齿美白';
      case ZegoBeautyType.beautyAdvancedNoseSlimming:
        return '缩鼻';
      case ZegoBeautyType.beautyAdvancedNoseLengthening:
        return '鼻子拉长';
      case ZegoBeautyType.beautyAdvancedFaceShortening:
        return '小脸';
      case ZegoBeautyType.beautyAdvancedMandibleSlimming:
        return '下颌瘦身';
      case ZegoBeautyType.beautyAdvancedCheekboneSlimming:
        return '颧骨瘦身';
      case ZegoBeautyType.beautyAdvancedForeheadSlimming:
        return '额头瘦身';

      // Filter
      case ZegoBeautyType.filterReset:
        return '无';
      case ZegoBeautyType.filterNaturalCreamy:
        return '自然柔滑';
      case ZegoBeautyType.filterNaturalBrighten:
        return '自然明亮';
      case ZegoBeautyType.filterNaturalFresh:
        return '自然清新';
      case ZegoBeautyType.filterNaturalAutumn:
        return '自然秋天';
      case ZegoBeautyType.filterGrayMonet:
        return '灰色莫奈';
      case ZegoBeautyType.filterGrayNight:
        return '灰色夜晚';
      case ZegoBeautyType.filterGrayFilmlike:
        return '灰色胶片';
      case ZegoBeautyType.filterDreamySunset:
        return '梦幻夕阳';
      case ZegoBeautyType.filterDreamyCozily:
        return '梦幻温馨';
      case ZegoBeautyType.filterDreamySweet:
        return '梦幻甜蜜';
      case ZegoBeautyType.beautyMakeupLipstickReset:
        return '无';
      case ZegoBeautyType.beautyMakeupLipstickCameoPink:
        return '粉贝壳粉';
      case ZegoBeautyType.beautyMakeupLipstickSweetOrange:
        return '甜橙色';
      case ZegoBeautyType.beautyMakeupLipstickRustRed:
        return '赭石红';
      case ZegoBeautyType.beautyMakeupLipstickCoral:
        return '珊瑚色';
      case ZegoBeautyType.beautyMakeupLipstickRedVelvet:
        return '红丝绒';

      // Makeup - Blusher
      case ZegoBeautyType.beautyMakeupBlusherReset:
        return '无';
      case ZegoBeautyType.beautyMakeupBlusherSlightlyDrunk:
        return '微醺';
      case ZegoBeautyType.beautyMakeupBlusherPeach:
        return '桃色';
      case ZegoBeautyType.beautyMakeupBlusherMilkyOrange:
        return '乳橙色';
      case ZegoBeautyType.beautyMakeupBlusherAprocitPink:
        return '杏粉色';
      case ZegoBeautyType.beautyMakeupBlusherSweetOrange:
        return '甜橙色';

      // Makeup - Eyelashes
      case ZegoBeautyType.beautyMakeupEyelashesReset:
        return '无';
      case ZegoBeautyType.beautyMakeupEyelashesNatural:
        return '自然';
      case ZegoBeautyType.beautyMakeupEyelashesTender:
        return '柔软';
      case ZegoBeautyType.beautyMakeupEyelashesCurl:
        return '卷翘';
      case ZegoBeautyType.beautyMakeupEyelashesEverlong:
        return '刷长';
      case ZegoBeautyType.beautyMakeupEyelashesThick:
        return '浓密';

      // Makeup - Eyeliner
      case ZegoBeautyType.beautyMakeupEyelinerReset:
        return '无';
      case ZegoBeautyType.beautyMakeupEyelinerNatural:
        return '自然';
      case ZegoBeautyType.beautyMakeupEyelinerCatEye:
        return '貓眼';
      case ZegoBeautyType.beautyMakeupEyelinerNaughty:
        return '俏皮';
      case ZegoBeautyType.beautyMakeupEyelinerInnocent:
        return '清純';
      case ZegoBeautyType.beautyMakeupEyelinerDignified:
        return '庄重';

      // Makeup - Eyeshadow
      case ZegoBeautyType.beautyMakeupEyeshadowReset:
        return '无';
      case ZegoBeautyType.beautyMakeupEyeshadowPinkMist:
        return '粉色薄雾';
      case ZegoBeautyType.beautyMakeupEyeshadowShimmerPink:
        return '闪粉粉色';
      case ZegoBeautyType.beautyMakeupEyeshadowTeaBrown:
        return '茶色棕';
      case ZegoBeautyType.beautyMakeupEyeshadowBrightOrange:
        return '明亮橙色';
      case ZegoBeautyType.beautyMakeupEyeshadowMochaBrown:
        return '摩卡棕色';

      // Makeup - Colored Contacts
      case ZegoBeautyType.beautyMakeupColoredContactsReset:
        return '无';
      case ZegoBeautyType.beautyMakeupColoredContactsDarknightBlack:
        return '暗夜黑';
      case ZegoBeautyType.beautyMakeupColoredContactsStarryBlue:
        return '星空蓝';
      case ZegoBeautyType.beautyMakeupColoredContactsBrownGreen:
        return '棕绿色';
      case ZegoBeautyType.beautyMakeupColoredContactsLightsBrown:
        return '亮棕色';
      case ZegoBeautyType.beautyMakeupColoredContactsChocolateBrown:
        return '巧克力棕';

      // Style Makeup
      case ZegoBeautyType.beautyStyleMakeupReset:
        return '无';
      case ZegoBeautyType.beautyStyleMakeupInnocentEyes:
        return '清纯眼妆';
      case ZegoBeautyType.beautyStyleMakeupMilkyEyes:
        return '乳白眼妆';
      case ZegoBeautyType.beautyStyleMakeupCutieCool:
        return '可爱帅气';
      case ZegoBeautyType.beautyStyleMakeupPureSexy:
        return '纯粹性感';
      case ZegoBeautyType.beautyStyleMakeupFlawless:
        return '无瑕美妆';

      // Stickers
      // case ZegoBeautyType.stickerReset:
      //   return 'None';
      // case ZegoBeautyType.stickerAnimal:
      //   return 'Animal';
      // case ZegoBeautyType.stickerDive:
      //   return 'Dive';
      // case ZegoBeautyType.stickerCat:
      //   return 'Cat';
      // case ZegoBeautyType.stickerWatermelon:
      //   return 'Watermelon';
      // case ZegoBeautyType.stickerDeer:
      //   return 'Deer';
      // case ZegoBeautyType.stickerCoolGirl:
      //   return 'Cool Girl';
      // case ZegoBeautyType.stickerClown:
      //   return 'Clown';
      // case ZegoBeautyType.stickerClawMachine:
      //   return 'Claw Machine';
      // case ZegoBeautyType.stickerSailorMoon:
      //   return 'Sailor Moon';

      // Background
      // case ZegoBeautyType.backgroundReset:
      //   return 'None';
      // case ZegoBeautyType.backgroundPortraitSegmentation:
      //   return 'Portrait Segmentation';
      // case ZegoBeautyType.backgroundMosaicing:
      //   return 'Mosaicing';
      // case ZegoBeautyType.backgroundGaussianBlur:
      //   return 'Gaussian Blur';
      default:
        return type.name;
    }
  }

  static String beautyIconPath(String name) => 'assets/beautyIcons/$name.png';

  static ButtonIcon icon(ZegoBeautyType type) {
    return ButtonIcon(
      icon: Image.asset(beautyIconPath(type.name)),
    );
  }

  static ButtonIcon selectedIcon(ZegoBeautyType type) {
    var radius = 24.0;
    if (type.index >= ZegoBeautyType.beautyStyleMakeupInnocentEyes.index) {
      radius = 8.0;
    }
    Color? color = const Color(0xffA653FF);
    if (type.index >= ZegoBeautyType.beautyBasicReset.index) {
      color = null;
    }
    return ButtonIcon(
      icon: Image.asset(beautyIconPath(type.name)),
      borderColor: color,
      borderWidth: 2.0,
      borderRadius: radius,
    );
  }

  static TextStyle textStyle(ZegoBeautyType type) {
    return const TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle selectedTextStyle(ZegoBeautyType type) {
    if (type.index >= ZegoBeautyType.beautyBasicReset.index) {
      return textStyle(type);
    }
    return const TextStyle(
      color: Color(0xffA653FF),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    );
  }
}
