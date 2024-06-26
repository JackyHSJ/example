import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/greet/personal_greet_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../widgets/profile/cell/personal_greet_cell.dart';
import '../../../widgets/theme/original/app_colors.dart';
import '../../../widgets/theme/uidefine.dart';
import 'add/personal_greet_add.dart';
import 'package:uuid/uuid.dart';

class PersonalGreet extends ConsumerStatefulWidget {
  const PersonalGreet({super.key});

  @override
  ConsumerState<PersonalGreet> createState() => _PersonalGreetState();
}

class _PersonalGreetState extends ConsumerState<PersonalGreet> {
  late PersonalGreetViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  @override
  void initState() {
    viewModel = PersonalGreetViewModel(ref: ref, setState: setState);
    viewModel.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    final greetList = ref.watch(userInfoProvider).greetModuleList?.list ?? [];
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return MainScaffold(
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      isFullScreen: true,
      appBar: MainAppBar(
        theme: _theme,
        title: '招呼设置',
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
        actions: [_buildBtn()],
      ),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: greetList.isEmpty ? _buildEmpty() : _buildGreetList(),
    );
  }

  _buildBtn() {
    final greetList = ref.watch(userInfoProvider).greetModuleList?.list ?? [];
    return Offstage(
      offstage: greetList.isEmpty,
      child: TextButton(
        onPressed: (){
          if(greetList.length >= 5) {
            BaseViewModel.showToast(context, '招呼模板已达上限');
            return ;
          }
          BaseViewModel.pushPage(context, PersonalGreetAdd(moduleNameList: greetList, type: GreetType.add));
        },
        child:  Text('新建', style:_appTextTheme.labelPrimaryTitleTextStyle),
      ),
    );
  }

  _buildGreetList() {
    return Consumer(builder: (context, ref, _){
      final greetList = ref.watch(userInfoProvider).greetModuleList?.list ?? [];
      return CustomList.separatedList(
          key: ValueKey(Uuid().v4()),
          physics: const NeverScrollableScrollPhysics(),
          separator: SizedBox(height: WidgetValue.separateHeight),
          childrenNum: greetList.length,
          children: (context, index) {
            final id = greetList[index].id ?? 0;
            final status = (greetList[index].status == 0) ? 1 : 0;
            return InkWell(
              onTap: () => viewModel.useGreet(context, id: id, status: status, onShowAuthDialog: () => _buildDialog()),
              child: PersonalGreetCell(moduleNameList: greetList, model: greetList[index], randomColor: AppColors.greetColorList[index % 3]),
            );
          }
      );
    });
  }

  void _buildDialog() {
    CheckDialog.show(context,
        appTheme: _theme,
        titleText: '审核未通过',
        messageText: '请点选编辑修改模板内容再次送出审核',
        barrierDismissible: false,
        messageTextStyle: TextStyle(color: AppColors.textFormBlack,fontSize: 14.sp,fontWeight: FontWeight.w400)
    );
  }

  _buildEmpty() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.imagePersonalGreetEmpty, size: 150),
        Text('您尚未添加招呼', style:_appTextTheme.labelPrimarySubtitleTextStyle),
        Text('添加自订义打招呼，会优先推荐给男用户喔', style: _appTextTheme.labelPrimaryContentTextStyle),
        SizedBox(height: WidgetValue.verticalPadding * 3,),
        _addModuleBtn(),
      ],
    );
  }

  _addModuleBtn() {
    final greetList = ref.watch(userInfoProvider).greetModuleList?.list ?? [];
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        width: 180.w,
        height: 48.h,
        text: '新建模板',
        textStyle: _appTextTheme.buttonPrimaryTextStyle,
        colorBegin: _appLinearGradientTheme.buttonPrimaryColor.colors[0],
        colorEnd: _appLinearGradientTheme.buttonPrimaryColor.colors[1],
        onTap: () => BaseViewModel.pushPage(context, PersonalGreetAdd(moduleNameList: greetList, type: GreetType.add),
        ),
    );
  }
}