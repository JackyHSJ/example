import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// 我的標籤
class PersonalEditTag extends ConsumerStatefulWidget {

  const PersonalEditTag({
    super.key
  });

  @override
  ConsumerState<PersonalEditTag> createState() => _PersonalEditTagState();

  static List<String>? chooseList;
}

class _PersonalEditTagState extends ConsumerState<PersonalEditTag> {

  List<String> tagList = [];
  List<Widget> widgetList = [];
  bool isLoading = true;
  List<Color> colorList = [];
  List<String> chooseList = [];

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {

    if (PersonalEditTag.chooseList != null) {
      chooseList = PersonalEditTag.chooseList!;
    }

    loadTagText();
    // colorList = AppColors.tagColorList;
    super.initState();
  }

  Future<void> loadTagText() async {
    String data = await rootBundle.loadString('assets/txt/tag.txt');
    tagList = const LineSplitter().convert(data);
    tidyTagWidget();
  }

  void tidyTagWidget() {
    for (int i = 0; i < tagList.length; i++) {
      widgetList.add(tagWidget(tagList[i], i));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    colorList = _appColorTheme.tagColorList;

    return MainScaffold(
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      isFullScreen: true,
      needSingleScroll:false,
      needBackground: true,
      appBar: _appBar(),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: (isLoading) ? _buildLoading() : _buildMainContent()
    );
  }

  Widget _buildLoading() {
    return Center(child: LoadingAnimation.discreteCircle(size: 36.w,color: _appColorTheme.primaryColor));
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHint(),
          _buildTagsWidget(),
        ],
      ),
    );
  }

  MainAppBar _appBar() {
    return MainAppBar(
      theme: _theme,
      title: '',
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      titleWidget: Text('我的标签', style: _appTextTheme.appbarTextStyle),
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
      actions: [
        InkWell(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 16.w),
            child: Text('保存', style: _appTextTheme.appbarActionTextStyle),
          ),
          onTap: () {
            chooseList.removeWhere((value) => value.isEmpty);
            setState(() {});
            Navigator.pop(context, chooseList);
            BaseViewModel.showToast(context, '记得再次点击保存才会储存设定哦');
            },
        ),
      ],
    );
  }

  Widget tagWidget(String content, int index) {
    Color color = _appColorTheme.myTagColor;
    Color textColor = _appColorTheme.myTagTextColor;

    if (chooseList.isNotEmpty) {
      for (int i = 0; i < chooseList.length; i++) {
        if (chooseList[i] == (content)) {
          color = colorList[i];
          textColor = Colors.black;
          break;
        }
      }
    }

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(48)),
        ),
        child: Text(
          content,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
        ),
      ),
      onTap: () {
        if (chooseList.contains(content)) {
          int index = chooseList.indexOf(content);
          chooseList.removeAt(index);
          chooseList.insert(index, '');
          widgetList = [];
          tidyTagWidget();
        } else {
          if (chooseList.contains('')) {
            int index = chooseList.indexOf('');
            chooseList.removeAt(index);
            chooseList.insert(index, content);
            widgetList = [];
            tidyTagWidget();
          } else {
            if (chooseList.length < 8) {
              setState(() {
                chooseList.add(content);
                widgetList = [];
                tidyTagWidget();
              });
            } else {
              BaseViewModel.showToast(context, '最多选8个');
            }
          }
        }
      },
    );
  }

  Widget _buildHint() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Center(
        child: Text('从下方选择标签',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _appColorTheme.tagHintTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: MainWrap().wrap(children: widgetList),
    );
  }

  Color backgroundColor(int index) {
    if (index < 8) {
      return colorList[index];
    } else {
      return colorList[index % 8];
    }
  }

  //保存
  Widget saveButton() {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 149.5, vertical: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.mainPink, AppColors.mainPetalPink],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: const Text("确定",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.none,
            )),
      ),
      onTap: () {
        chooseList.removeWhere((value) => value.isEmpty);
        setState(() {});
        Navigator.pop(context, chooseList);
        BaseViewModel.showToast(context, '记得再次点击保存才会储存设定哦');
      },
    );
  }
}
