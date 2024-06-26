
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_detail_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_coin_view.dart';
import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_income_view.dart';
import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_withdraw_view.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/tab_bar/custom_indicator.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalBookkeeping extends ConsumerStatefulWidget {

  final int index;
  final bool isFromBannerView;

  const PersonalBookkeeping({
    super.key,
    required this.index,
    required this.isFromBannerView
  });

  @override
  ConsumerState<PersonalBookkeeping> createState() => _PersonalBookkeepingState();
}

class _PersonalBookkeepingState extends ConsumerState<PersonalBookkeeping> with SingleTickerProviderStateMixin {

  late TabController _tabController; // tabController
  List<Tab> tabTitles = []; // tabTitle
  List<GiftListInfo> giftListInfo = []; // 禮物 list
  bool isLoading = true; // isLoading
  bool showWithdrawType = false; // 審核開關 // 6. 提現
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    _buttonConfigInit();
    getGiftCategoryDetail();
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // 取得禮物列表
  Future<void> getGiftCategoryDetail() async {
    String resultCodeCheck = '';
    final WsAccountGetGiftDetailReq reqBody = WsAccountGetGiftDetailReq.create(type: 1);
    final WsAccountGetGiftDetailRes res = await ref.read(accountWsProvider).wsAccountGetGiftDetail(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      giftListInfo = res.giftList!;
      isLoading = false;
      setState(() {});
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }

  // 後台開關設置
  void _buttonConfigInit() {
    showWithdrawType = ref.read(userInfoProvider).buttonConfigList?.withdrawType == 1 ? true : false;
    if (showWithdrawType) {
      tabTitles = [_fitTab(text: '金币'), _fitTab(text: '收益'), _fitTab(text: '提现记录')];
    } else {
      tabTitles = [_fitTab(text: '金币'), _fitTab(text: '收益')];
    }
    _tabController = TabController(initialIndex: widget.index, length: tabTitles.length, vsync: this);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;

    return Scaffold(
      appBar: MainAppBar(
        theme: _theme,
        title: '收支明细',
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      body: Container(
        color: _appColorTheme.appBarBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: _buildTabBarView(),
              ),
            ],
          ),
        ),
      )
    );
  }

  //TabBar
  Widget _buildTabBar() {

    return MainTabBar(
        controller: _tabController!, tabList: tabTitles)
        .tabBar(
      padding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.center,
      isScrollable: true,
      indicator: CustomIndicator(color: _appColorTheme.tabBarIndicatorColor, indicatorWidth: 16.w),
      selectTextStyle: _appTextTheme.tabBarSelectTextStyle,
      unSelectTextStyle: _appTextTheme.tabBarUnSelectTextStyle,
    );
  }

  //Tab內容
  Widget _buildTabBarView() {

    List<Widget> tabContentList = [
      PersonalBookkeepingCoinView(giftListInfo: giftListInfo),
      PersonalBookkeepingIncomeView(giftListInfo: giftListInfo),
      if (showWithdrawType) const PersonalBookkeepingWithdrawView()
    ];

    return (isLoading)
        ? LoadingAnimation.discreteCircle()
        : TabBarView(
      controller: _tabController,
      children: tabContentList
    );
  }

  _fitTab({
    required String text
  }) {
    return Tab(
      child: FittedBox(
        child: Text(text),
      ),
    );
  }



}
