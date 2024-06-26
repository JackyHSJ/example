/// @nodoc
enum ZegoBeautyType {
  // nothing.
  beautyNone,

  // Beauty
  // Beauty - Basic
  beautyBasicSmoothing, /// 1
  beautyBasicSkinTone, /// 2
  beautyBasicBlusher, /// 3
  beautyBasicSharpening, /// 4
  beautyBasicWrinkles, /// 5
  beautyBasicDarkCircles, /// 6

  // Beauty - Advanced
  beautyAdvancedFaceSlimming, /// 7
  beautyAdvancedEyesEnlarging, /// 8
  beautyAdvancedEyesBrightening, /// 9
  beautyAdvancedChinLengthening, /// 10
  beautyAdvancedMouthReshape, /// 11
  beautyAdvancedTeethWhitening, /// 12
  beautyAdvancedNoseSlimming, /// 13
  beautyAdvancedNoseLengthening, /// 14
  beautyAdvancedFaceShortening, /// 15
  beautyAdvancedMandibleSlimming, /// 16
  beautyAdvancedCheekboneSlimming, /// 17
  beautyAdvancedForeheadSlimming, /// 18

  // Beauty - Makeup
  // Beauty - Makeup - Lipstick
  beautyMakeupLipstickCameoPink, /// 19
  beautyMakeupLipstickSweetOrange, /// 20
  beautyMakeupLipstickRustRed, /// 21
  beautyMakeupLipstickCoral, /// 22
  beautyMakeupLipstickRedVelvet, /// 23

  // Beauty - Makeup - Blusher
  beautyMakeupBlusherSlightlyDrunk, /// 24
  beautyMakeupBlusherPeach, /// 25
  beautyMakeupBlusherMilkyOrange, /// 26
  beautyMakeupBlusherAprocitPink, /// 27
  beautyMakeupBlusherSweetOrange, /// 28

  // Beauty - Makeup - Eyelashes
  beautyMakeupEyelashesNatural, /// 29
  beautyMakeupEyelashesTender, /// 30
  beautyMakeupEyelashesCurl, /// 31
  beautyMakeupEyelashesEverlong, /// 32
  beautyMakeupEyelashesThick, /// 33

  // Beauty - Makeup - Eyeliner
  beautyMakeupEyelinerNatural, /// 34
  beautyMakeupEyelinerCatEye, /// 35
  beautyMakeupEyelinerNaughty, /// 36
  beautyMakeupEyelinerInnocent, /// 37
  beautyMakeupEyelinerDignified, /// 38

  // Beauty - Makeup - Eyeshadow
  beautyMakeupEyeshadowPinkMist, /// 39
  beautyMakeupEyeshadowShimmerPink, /// 40
  beautyMakeupEyeshadowTeaBrown, /// 41
  beautyMakeupEyeshadowBrightOrange, /// 42
  beautyMakeupEyeshadowMochaBrown, /// 43

  // Beauty - Makeup - Colored Contacts
  beautyMakeupColoredContactsDarknightBlack, /// 44
  beautyMakeupColoredContactsStarryBlue, /// 45
  beautyMakeupColoredContactsBrownGreen, /// 46
  beautyMakeupColoredContactsLightsBrown, /// 47
  beautyMakeupColoredContactsChocolateBrown, /// 48

  // Beauty - Style Makeup
  beautyStyleMakeupInnocentEyes, /// 49
  beautyStyleMakeupMilkyEyes, /// 50
  beautyStyleMakeupCutieCool, /// 51
  beautyStyleMakeupPureSexy, /// 52
  beautyStyleMakeupFlawless, /// 53

  // Filters
  // Filters - Natural
  filterNaturalCreamy, /// 54
  filterNaturalBrighten, /// 55
  filterNaturalFresh, /// 56
  filterNaturalAutumn, /// 57

  // Filters - Gray
  filterGrayMonet,  /// 58
  filterGrayNight,  /// 59
  filterGrayFilmlike,  /// 60

  // Filters - Dreamy
  filterDreamySunset,  /// 61
  filterDreamyCozily,  /// 62
  filterDreamySweet,  /// 63

  // Stickers
  stickerAnimal, /// 64
  stickerDive, /// 65
  stickerCat, /// 66
  stickerWatermelon, /// 67
  stickerDeer, /// 68
  stickerCoolGirl, /// 69
  stickerClown, /// 70
  stickerClawMachine, /// 71
  stickerSailorMoon, /// 72

  // Background
  // backgroundGreenScreenSegmentation,
  backgroundPortraitSegmentation, /// 73
  backgroundMosaicing, /// 74
  backgroundGaussianBlur, /// 75

  // Reset
  beautyBasicReset, /// 76
  beautyAdvancedReset, /// 77
  beautyMakeupLipstickReset, /// 78
  beautyMakeupBlusherReset, /// 79
  beautyMakeupEyelashesReset, /// 80
  beautyMakeupEyelinerReset, /// 81
  beautyMakeupEyeshadowReset, /// 82
  beautyMakeupColoredContactsReset, /// 83
  beautyStyleMakeupReset, /// 84
  filterReset, /// 85
  stickerReset, /// 86
  backgroundReset, /// 87
}

extension ZegoBeautyTypePath on ZegoBeautyType {
  String path(String folder) {
    if (index >= ZegoBeautyType.beautyBasicReset.index ||
        this == ZegoBeautyType.beautyNone) {
      return '';
    }
    return '$folder/AdvancedResources/$name.bundle';
  }
}
