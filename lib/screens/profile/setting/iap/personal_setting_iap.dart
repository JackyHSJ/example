import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/profile/personal_setting_iap_model.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/profile/setting/charm/personal_setting_charm.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../../widgets/profile/cell/personal_setting_iap_cell.dart';

class PersonalSettingIAP extends ConsumerStatefulWidget {
  const PersonalSettingIAP({super.key});

  @override
  ConsumerState<PersonalSettingIAP> createState() => _PersonalSettingIAPState();
}

class _PersonalSettingIAPState extends ConsumerState<PersonalSettingIAP> {
  late PersonalSettingIAPViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  @override
  void initState() {
    viewModel = PersonalSettingIAPViewModel(ref: ref, setState: setState);
    viewModel.getCharmInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '收费设置',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildList(),
            SizedBox(height: WidgetValue.verticalPadding * 3),
            _buildIntro()
          ],
        ),
      ),
    );
  }

  _buildList() {
    return Consumer(builder: (context, ref, _){
      final WsSettingCharmAchievementRes charmAchievement = ref.watch(userInfoProvider).charmAchievement ?? WsSettingCharmAchievementRes();
      viewModel.getCharmAchievement(charmAchievement);
      return CustomList.separatedList(
       separator: SizedBox(height: WidgetValue.separateHeight),
       childrenNum: viewModel.selectList.length,
       children: (context, index) {
         return InkWell(
           onTap: () {
             final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
             if (isPipMode) {
               CommDialog(context).build(
                 theme: _theme,
                 title: '提醒',
                 contentDes: '您现在正在通话中，无法更改收费设置',
                 rightBtnTitle: '确定',
                 rightAction: () {
                   BaseViewModel.popupDialog();
                   BaseViewModel.popPage(context);
                 },
               );
               return;
             }
             switch(index) {
               case 0:
                 PersonalSettingIAPModel personalSettingIAPModel = viewModel.selectList[0];
                 int defaultIndex= getPickerDefault(viewModel.messageList, personalSettingIAPModel.phraseNum.toString());
                 _buildPicker(index,defaultIndex, viewModel.messageList);
                 break;
               case 1:
                 PersonalSettingIAPModel personalSettingIAPModel = viewModel.selectList[1];
                 int defaultIndex= getPickerDefault(viewModel.voiceList, personalSettingIAPModel.phraseNum.toString());
                 _buildPicker(index,defaultIndex, viewModel.voiceList);
                 break;
               case 2:
                 PersonalSettingIAPModel personalSettingIAPModel = viewModel.selectList[2];
                 int defaultIndex= getPickerDefault(viewModel.videoList, personalSettingIAPModel.phraseNum.toString());
                 _buildPicker(index,defaultIndex, viewModel.videoList);
                 break;
             }},
           child: PersonalSettingIAPCell(model: viewModel.selectList[index]),
         );
       });
    });
  }

  int getPickerDefault(List list ,String target){
    for(int i =0;i<list.length;i++){
      SettingIAPModel settingIAPModel = list[i];
      if(settingIAPModel.selectNum == target){
        return i;
      }
    }
    return 0 ;
  }

  _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('说明', style: _appTextTheme.labelPrimarySubtitleTextStyle),
        CustomList.separatedList(
            separator: SizedBox(height: WidgetValue.separateHeight),
            childrenNum: viewModel.introList.length,
            children: (context, index) {
              final bool enableAction = viewModel.introList[index].enableAction;
              if (enableAction) {
                return InkWell(
                  onTap: () =>
                      BaseViewModel.pushPage(context, PersonalSettingCharm()),
                  child: Text(' • ${viewModel.introList[index].title}',
                      style: _appTextTheme.labelMainContentTextStyle),
                );
              } else {
                return Text(' • ${viewModel.introList[index].title}', style: _appTextTheme.labelPrimaryTextStyle);
              }
            }),
      ],
    );
  }

  _buildPicker(int index, int defaultIndex, List<SettingIAPModel> list) {
    FixedExtentScrollController fixedExtentScrollController = FixedExtentScrollController(initialItem: defaultIndex);
    Picker.iconDataPicker(context,
      appTheme: _theme,
      length: list.length,
      defaultIndex: defaultIndex,
      fixedExtentScrollController: fixedExtentScrollController,
      itemBuilder: (context, index) => _buildPickerItem(index, list),
      onSelect: (selectIndex) {
        if (list[selectIndex].needLock) {
          BaseViewModel.showToast(context, '亲～您的魅力等级不足呦');
        } else {
          viewModel.selectList[index].phraseNum = int.tryParse(list[selectIndex].selectNum) ?? 0;
          viewModel.chargeSetting(context);
          setState(() {});
          Navigator.of(context).pop();
        }
      },
      onCancel: () => Navigator.of(context).pop()
    );
  }

  _buildPickerItem(int index, List<SettingIAPModel> list) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Visibility(
            visible: list[index].needLock,
            child: Icon(Icons.lock,color: _appColorTheme.pickerDialogIconColor,)),
          SizedBox(width: 10.0),
          Text(list[index].title,style: _appTextTheme.pickerDialogContentTextStyle,),
        ],
      ),
    );
  }
}
