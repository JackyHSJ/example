import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/screens/profile/setting/privacy_setting/privacy_setting_page.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_recommend_tab_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_member_card.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import '../../system/providers.dart';
import '../../widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'strike_up_list_search_tab_view_model.dart';

class StrikeUpListRecommendTab extends ConsumerStatefulWidget {

  final ScrollController scrollController;

  const StrikeUpListRecommendTab({
    super.key,
    required this.scrollController
  });

  @override
  ConsumerState<StrikeUpListRecommendTab> createState() => _StrikeUpListRecommendTabState();
}

class _StrikeUpListRecommendTabState extends ConsumerState<StrikeUpListRecommendTab> with AutomaticKeepAliveClientMixin{

  ScrollController get scrollController => widget.scrollController;

  @override
  bool get wantKeepAlive => true;

  late StrikeUpListRecommendTabViewModel viewModel;
  late AppTheme _theme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    viewModel = StrikeUpListRecommendTabViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    return _buildRecommendedList();
  }

  Widget _buildRecommendedList() {
    String refreshIconString =_theme.getAppImageTheme.pullLoaderRefreshIcon;
    String fetchMoreIconString =_theme.getAppImageTheme.pullLoaderFetchMoreIcon;
    String loadingIconString =_theme.getAppImageTheme.pullLoaderLoadingIcon;
    bool  isClosePersonalized = ref.watch(userInfoProvider).isClosePersonalizedRecommendations ?? false;

    if (isClosePersonalized) {
      return _personalizedPromptContent();
    }

    return Consumer(builder: (context, ref, _) {
      List<FateListInfo> strikeUpListRecommendList = ref.watch(userInfoProvider).strikeUpListRecommendList?.list ?? [];
      return TopBottomPullLoader(
          onRefresh: () => viewModel.refreshRecommendList(),
          onFetchMore: () => viewModel.fetchMoreRecommendList(),
          enableFetchMore: !viewModel.noMoreData,
          refreshIcon: Image.asset(refreshIconString, width: 36.w, height: 36.w),
          fetchMoreIcon: Image.asset(fetchMoreIconString, width: 36.w, height: 36.w),
          loadingIcon: Image.asset(loadingIconString, width: 36.w, height: 36.w),
          child: strikeUpListRecommendList.isEmpty ? _buildEmptyView() : _buildListView(strikeUpListRecommendList));
    });
  }

  Widget _buildEmptyView() {
    return Center(child: SingleChildScrollView(child: _emptyWidget()));
  }

  Widget _buildListView(List<FateListInfo> strikeUpListRecommendList) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: strikeUpListRecommendList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Column(
          children: [
            StrikeUpListMemberCard(
              fateListInfo: strikeUpListRecommendList[index],
              taskManager: viewModel.taskManager,
            ),
            Visibility(
              visible: viewModel.noMoreData && index == strikeUpListRecommendList.length - 1,
              child: _buildNoMoreWidget(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoMoreWidget() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        child: Text("-没有更多数据-", style: _appTextTheme.labelSecondaryTextStyle,)
    );
  }


  ///個性化提示
  Widget _personalizedPromptContent(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.disabledPersonalizedSettingImage, size: 150.w),
        Text('开启个性化推荐', style: _appTextTheme.labelPrimarySubtitleTextStyle),
        SizedBox(height: WidgetValue.verticalPadding),
        Text('开启个性化推荐后可启动推荐列表',style: _appTextTheme.labelPrimaryContentTextStyle),
        SizedBox(height: WidgetValue.verticalPadding * 2),
        _personalizedSettingButton()
      ],
    );
  }

  ///個性化提示 - 前往個人化設置按鈕
  Widget _personalizedSettingButton() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        alignment: const Alignment(0, 0),
        height: 50.h,
        width: 150.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient:  LinearGradient(
            colors: [
              _appLinearGradientTheme.buttonPrimaryColor.colors[0],
              _appLinearGradientTheme.buttonPrimaryColor.colors[1],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text('立即开启',style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white
        )),
      ),
      onTap: (){
        BaseViewModel.pushPage(context, const PrivacySettingPage());
      },
    );
  }

  /// 無推薦
  Widget _emptyWidget() {
    String hint = '女神正在赶来的路上';
    if(ref.read(userInfoProvider).memberInfo?.gender == 0){
      hint = '小哥哥正在赶来的路上';
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(_appImageTheme.imageCallEmpty, size: 150.w),
          Text(hint, style: _appTextTheme.labelPrimarySubtitleTextStyle),
          SizedBox(height: WidgetValue.verticalPadding),
          Text('别错过缘分在等等呐～', style:_appTextTheme.labelPrimaryContentTextStyle),
          SizedBox(height: WidgetValue.verticalPadding * 2),
        ],
      ),
    );
  }
}
