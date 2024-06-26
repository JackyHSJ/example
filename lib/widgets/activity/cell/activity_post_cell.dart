
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/tab/city/activity_city_tab_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:frechat/widgets/activity/activity_post_cell_content.dart';
import 'package:frechat/widgets/activity/activity_post_cell_actions.dart';
import 'package:frechat/widgets/activity/activity_post_cell_info.dart';
import 'package:frechat/widgets/activity/activity_post_cell_remind.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell_view_model.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class ActivityPostCell extends ConsumerStatefulWidget {
  const ActivityPostCell({super.key, required this.postInfo, required this.likeList,required this.onTap,required this.onTapMessageButton});
  final ActivityPostInfo postInfo;
  final List<dynamic> likeList;
  final Function() onTap;
  final Function() onTapMessageButton;

  @override
  ConsumerState<ActivityPostCell> createState() => _ActivityPostCellState();
}

class _ActivityPostCellState extends ConsumerState<ActivityPostCell> {
  ActivityPostInfo get postInfo => widget.postInfo;
  List<dynamic> get likeList => widget.likeList;
  late ActivityPostCellViewModel viewModel;
  final double _horizontal = WidgetValue.horizontalPadding + WidgetValue.separateHeight;
  final double _spacing = 40.w ;

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = ActivityPostCellViewModel(ref: ref, setState: setState);
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
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return InkWell(
      onTap: ()=> widget.onTap.call(),
      child: Container(
        color:  _appColorTheme.appBarBackgroundColor,
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _postRemindWidget(),
            _postInfoWidget(),
            _postContentWidget(),
            _postActionsWidget ()
          ],
        ),
      ),
    );
  }

  /// 貼文提示
  _postRemindWidget(){
    return Visibility(
      visible: postInfo.status == 0,
      child: Padding(
        padding: EdgeInsets.only(left: _horizontal, right: _horizontal),
        child:ActivityPostCellRemind(postInfo:postInfo),
      ),
    );
  }

  ///貼文資訊（頭貼/名字/性別/搭訕按鈕）
  _postInfoWidget(){
    return Padding(
      padding: EdgeInsets.only(left: _horizontal, right: _horizontal),
      child: ActivityPostCellInfo(postInfo: postInfo, viewModel: viewModel),
    );
  }

  ///貼文內容（文字/圖片）
  _postContentWidget(){
    return Padding(
      padding: EdgeInsets.only(left: _horizontal+_spacing),
      child: ActivityPostCellContent(postInfo: postInfo),
    );
  }

  ///貼文互動按鈕（打賞/按讚）
  _postActionsWidget(){
    return Padding(
      padding: EdgeInsets.only(left: _horizontal+_spacing,right: _horizontal),
      child: ActivityPostCellActions(
          postInfo: postInfo, viewModel: viewModel, likeList: likeList,onTapMessageButton: ()=> widget.onTapMessageButton.call(),),
    );
  }

}