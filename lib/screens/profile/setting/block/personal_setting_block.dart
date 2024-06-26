import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/screens/profile/setting/block/personal_setting_block_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../widgets/profile/cell/personal_block_cell.dart';
import '../../../../widgets/shared/list/main_list.dart';
import '../../../../widgets/theme/uidefine.dart';
import 'package:uuid/uuid.dart';

class PersonalSettingBlock extends ConsumerStatefulWidget {
  const PersonalSettingBlock({super.key});

  @override
  ConsumerState<PersonalSettingBlock> createState() => _PersonalSettingBlockState();
}

class _PersonalSettingBlockState extends ConsumerState<PersonalSettingBlock> {
  late PersonalSettingBlockViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    viewModel = PersonalSettingBlockViewModel(ref: ref, setState: setState);
    viewModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '黑名单',
        titleWidget: Text(
          "黑名单",
          style: _appTextTheme.appbarTextStyle,
        ),
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: _buildBlockList(),
    );
  }

  _buildBlockList() {
    return Consumer(builder: (context, ref, _){
      final WsNotificationBlockGroupRes blockList = ref.watch(userInfoProvider).notificationBlockGroup ?? WsNotificationBlockGroupRes();
      List<BlockListInfo> list = [];
      if(blockList.list!.isNotEmpty){
        list = blockList!.list!.where((info) => info.userName != null).toList();
      }
      final bool isEmpty = list.isEmpty;
      return (isEmpty) ? Center(child: _buildEmptyBlock()) : TopBottomPullLoader(
        enableRefresh: false,
        onRefresh: viewModel.refreshHandler,
        onFetchMore: () => viewModel.fetchMoreHandler(context),
        child: CustomList.separatedList(
          separator: SizedBox(height: WidgetValue.verticalPadding * 2), childrenNum: blockList?.list?.length ?? 0,
          children: (context, index) {
            return PersonalBlockCell(viewModel: viewModel, model: blockList!.list![index]);
          }
        ));
    });
  }

  _buildEmptyBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(_appImageTheme.imgBlockEmptyBanner, size: 144),
          Text('目前无黑名单', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _appColorTheme.blockBannerPrimaryTextColor)),
          SizedBox(height: 2),
          Text('透过将某人添加到黑名单，您可以限制他们对您的互动或内容的访问', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: _appColorTheme.blockBannerSecondaryTextColor), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}