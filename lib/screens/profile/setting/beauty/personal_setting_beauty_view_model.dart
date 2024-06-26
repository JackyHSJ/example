
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_effects_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';

class PersonalSettingBeautyViewModel {

  WidgetRef ref;
  ViewChange setState;

  PersonalSettingBeautyViewModel({
    required this.setState,
    required this.ref,
  });

  bool isFacingCamera = true;
  bool isBeautyOpen = false;

  init() async {
    await _permissionRequest();
    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);

    await manager.initZegoEffect();
    expressService.turnCameraOn(true);
    await expressService.startPreview();
    manager.loadDbDateToCurrentValue();
    isBeautyOpen = await FcPrefs.getBeautyStatus();
    beautyParamsHandler();
    setState((){});
  }

  beautyParamsHandler() async {
    if (isBeautyOpen) {
      final manager = ref.read(zegoSDKManagerProvider);
      await manager.loadDbDateToCurrentValue();
      // getBeautyParam();
    } else {
      ZegoBeautyType.values.forEach((type) {
        final ZegoBeautyAbility? ability = getAbility(type);
        ability?.editor.enable(true);
        ability?.editor.apply(0);
        ability?.currentValue = 0;
      });
    }
  }

  // getBeautyParam(){
  //   final List<int?> beautyParams = [];
  //
  //   ZegoBeautyType.values.forEach((type) {
  //     final ZegoBeautyAbility? ability = getAbility(type);
  //     beautyParams.add(ability?.currentValue);
  //   });
  //
  //   print('beautyParams: $beautyParams');
  // }

  // 請求權限：攝影機 & 麥克風
  Future<void> _permissionRequest() async {
    await PermissionUtil.checkAndRequestCameraPermission();
  }

  // dispose
  dispose() {
    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);
    expressService.stopPreview();
    manager.disposeZegoEffect();
  }

  // 切換攝影機
  switchCameraBtn() async {
    isFacingCamera = !isFacingCamera;
    ref.read(expressServiceProvider).useFrontCamera(isFacingCamera);
  }

  // 打開美顏
  openBeauty(BuildContext context) async {
    await FcPrefs.setBeautyStatus(true);
    if(context.mounted) {
      BaseViewModel.popPage(context);
      BaseViewModel.showToast(context, '已开启美颜功能');
    }
  }

  // 關閉美顏
  closeBeauty(BuildContext context) async {
    await FcPrefs.setBeautyStatus(false);
    if(context.mounted) {
      BaseViewModel.popPage(context);
      BaseViewModel.popPage(context);
      BaseViewModel.showToast(context, '已关闭美颜功能');
    }
  }

  // 回預設值
  originBeauty(BuildContext context) async {
    await FcPrefs.setBeautyStatus(true);
    await returnToOriginalSetting();
    if (context.mounted) {
      BaseViewModel.popPage(context);
      BaseViewModel.popPage(context);
      BaseViewModel.showToast(context, '美颜设定已恢复默认');
    }
  }

  // 設定所有美顏參數
  returnToOriginalSetting() async {
    ZegoBeautyType.values.forEach((type) {
      ref.read(zegoBeautyModelNotifierProvider.notifier).setDataToSql(zegoBeautyModelList: [
        ZegoBeautyModel(
          beautyTypeIndex: type.index,
          currentValue: 50,
        )
      ]);
    });
  }

  ZegoBeautyAbility? getAbility (ZegoBeautyType? type) {
    final ZegoBeautyAbility? ability = ZegoEffectsService.instance.beautyAbilities[type];
    return ability;
  }
}