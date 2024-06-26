import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';

import 'package:frechat/system/zego_call/components/zego_beauty_icon_button.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_item.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_beauty_data.dart';
import 'package:frechat/system/base_view_model.dart';

import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/bottom_sheet/profile_setting_beauty/beauty_bottom_sheet_view_model.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class SettingBeautyBottomSheet extends ConsumerStatefulWidget {
  const SettingBeautyBottomSheet({super.key});

  @override
  _SettingBeautyBottomSheetState createState() => _SettingBeautyBottomSheetState();
}

class _SettingBeautyBottomSheetState extends ConsumerState<SettingBeautyBottomSheet> {
  late BeautyBottomSheetViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = BeautyBottomSheetViewModel(ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return sheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDivider(),
            _buildBtn(),
            Visibility(
              visible: !viewModel.isResetType,
              child: _slider(),
            ),
            sheetTitle(),
            Container(height: 1.0, color: Colors.white),
            sheetContent(),
          ],
        ));
  }

  _buildBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextBtn(title: '取消', onTap: () {
          CommDialog(context).build(
            theme: _theme,
            title: '是否保存美颜设定？',
            contentDes: '您尚未储存美颜设定，离开后将不保存变更',
            leftBtnTitle: '取消',
            leftAction: () => BaseViewModel.popPage(context),
            rightBtnTitle: '保存',
            rightAction: () {
              viewModel.saveBeautySetting(context);
              BaseViewModel.popPage(context);
              BaseViewModel.popPage(context);
              BaseViewModel.showToast(context, '已保存您的美颜设置！');
            }
          );
        }),
        _buildTextBtn(title: '保存', onTap: () {
          viewModel.saveBeautySetting(context);
          BaseViewModel.popPage(context);
          BaseViewModel.showToast(context, '已保存您的美颜设置！');
        })
      ],
    );
  }

  _buildTextBtn({
    required String title,
    required Function() onTap
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        child: Text(title, style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  _buildDivider() {
    return SizedBox(
      width: 30,
      height: 4.0,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            color: Colors.white),
      ),
    );
  }

  Widget sheetTitle() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        // controller: titleController,
        itemCount: ZegoBeautyData.data.length,
        scrollDirection: Axis.horizontal,
        cacheExtent: 800,
        itemBuilder: (context, index) {
          final model = ZegoBeautyData.data[index];
          final bool isSelected = model.type == viewModel.selectEffectModel?.type;
          final textColor = isSelected ? AppColors.textWhite : AppColors.textWhite;
          final textStyle = isSelected
              ? const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Color(0xffA653FF))
              : const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: AppColors.textWhite);
          return TextButton(
            onPressed: () {
              viewModel.selectEffectModel = model;
              setState(() {});
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(textColor),
            ),
            child: Text(model.title, style: textStyle),
          );
        },
      ),
    );
  }

  Widget sheetContent() {
    final List<ZegoEffectItem> effectsList = viewModel.selectEffectModel?.items ?? [];
    return SizedBox(
        height: 105,
        child: ListView.builder(
          cacheExtent: 74.0 * effectsList.length,
          scrollDirection: Axis.horizontal,
          itemCount: effectsList.length,
          itemBuilder: (context, index) {
            final ZegoEffectItem item = effectsList[index];
            final icon = item.type == viewModel.selectedEffectType ? item.selectIcon : item.icon;
            final textStyle = item.type == viewModel.selectedEffectType ? item.selectedTextStyle : item.textStyle;
            return ZegoTextIconButton(
              buttonSize: const Size(74, 74),
              iconSize: const Size(48, 48),
              icon: icon,
              text: item.iconText,
              textStyle: textStyle,
              onPressed: () {
                viewModel.isResetType = viewModel.selectEffectModel?.items.first.type == effectsList[index].type;
                viewModel.selectedEffectType = effectsList[index].type;
                if(viewModel.isResetType) {
                  viewModel.resetBeautyOption();
                }
                setState(() {});
              },
            );
          },
        ));
  }

  Widget sheet({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.mainBlack.withOpacity(0.6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(WidgetValue.btnRadius),
          topRight: Radius.circular(WidgetValue.btnRadius),
        ),
      ),
      child: child,
    );
  }

  _slider() {
    final ZegoBeautyType? type = viewModel.selectedEffectType;
    final ZegoBeautyAbility? ability = viewModel.getAbility(type);
    return SizedBox(
      width: UIDefine.getWidth() / 1.5,
      child: Platform.isIOS ? _buildIosStyleSlider(ability) : _buildAndroidStyleSlider(ability),
    );
  }

  _buildAndroidStyleSlider(ZegoBeautyAbility? ability) {
    return Slider(
      activeColor: AppColors.mainBlue,
      thumbColor: AppColors.mainBlue,
      value: ability?.currentValue.toDouble() ?? 0,
      min: ability?.minValue.toDouble() ?? 0,
      max: ability?.maxValue.toDouble() ?? 100,
      divisions: 20,
      onChanged: (value) {
        viewModel.setBeautyOption(value);
        setState(() {});
      },
    );
  }

  _buildIosStyleSlider(ZegoBeautyAbility? ability) {
    return CupertinoSlider(
      activeColor: AppColors.mainBlue,
      thumbColor: AppColors.mainBlue,
      value: ability?.currentValue.toDouble() ?? 0,
      min: ability?.minValue.toDouble() ?? 0,
      max: ability?.maxValue.toDouble() ?? 100,
      divisions: 20,
      onChanged: (value) {
        viewModel.setBeautyOption(value);
        setState(() {});
      },
    );
  }

  _buildBeautyDialog({
    required String title,
    required String subTitle,
    required String confirmBtn,
    required Function() onTap,
  }){
    showDialog(
      context: BaseViewModel.getGlobalContext(),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.transparent,
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textFormBlack
                  )),
                  SizedBox(height: 8),
                  Text(subTitle, style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textFormBlack
                  ),),
                  SizedBox(height: 16),
                  _buildBeautyDialogBtn(confirmBtn: confirmBtn, onTap: onTap),
                ],
              ),
            )
        );
      },
    );
  }

  _buildBeautyDialogBtn({
    required String confirmBtn,
    required Function() onTap
  }){
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient:  AppColors.mistPinkGradientColors,
              ),
              child:  InkWell(
                onTap: (){
                  viewModel.cancelBeautySetting(context);
                },
                child: const Center(
                  child: Text('离开',style: TextStyle(color: Color(0xFFEC6193))
                  ),
                ),
              )
          ),
        ),
        const SizedBox(width: 7),
        Expanded(child: Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: AppColors.pinkLightGradientColors,
            ),
            child:  InkWell(
              onTap: () => onTap(),
              child: Center(
                  child: Text(confirmBtn, style: const TextStyle(color: Color(0xFFFFFFFF)))),
            )
        )
        ),
      ],
    );
  }
}
