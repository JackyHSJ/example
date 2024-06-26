

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/beauty_setting_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_item.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_beauty_data.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_effects_service.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
// import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';

class BeautyBottomSheetViewModel {
  BeautyBottomSheetViewModel({
    required this.ref
  });
  WidgetRef ref;
  ZegoEffectModel? selectEffectModel;
  ZegoBeautyType? selectedEffectType;
  bool isResetType = true;

  init() {
    selectEffectModel = ZegoBeautyData.data.first;
    selectedEffectType = selectEffectModel?.items.first.type;
  }

  dispose() {
  }


  // 設置美顏參數
  void setBeautyOption(double value) {
    // final List<BeautySettingModel> beautyParamList = ref.read(userInfoProvider).beautyParamsSetting ?? [];
    final ability = getAbility(selectedEffectType);
    ability?.editor.enable(true);
    ability?.editor.apply(value.toInt());
    ability?.currentValue = value.toInt();
  }

  // 重製美顏參數
  void resetBeautyOption() {
    selectEffectModel?.items.forEach((effect) {
      final ZegoBeautyAbility? ability = getAbility(effect.type);
      ability?.reset();
    });
    ref.read(zegoBeautyModelNotifierProvider.notifier).reset(whereEffectModelType: selectEffectModel?.type);
  }


  saveBeautySetting(BuildContext context) {

    // final List<int?> beautySettings = [];

    ZegoBeautyType.values.forEach((type) {

      final ZegoBeautyAbility? ability = getAbility(type);
      ref.read(zegoBeautyModelNotifierProvider.notifier).setDataToSql(zegoBeautyModelList: [
        ZegoBeautyModel(
          beautyTypeIndex: type.index,
          currentValue: ability?.currentValue
        )
      ]);
      // beautySettings.add(ability?.currentValue);
    });

    // print('beautySettings: $beautySettings');
  }

  cancelBeautySetting(BuildContext context) {
    BaseViewModel.popPage(context);
    BaseViewModel.popPage(context);
  }

  ZegoBeautyAbility? getAbility (ZegoBeautyType? type) {
    final ZegoBeautyAbility? ability = ZegoEffectsService.instance.beautyAbilities[type];
    return ability;
  }
}