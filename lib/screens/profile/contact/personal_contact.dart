import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/screens/profile/contact/personal_contact_view_model.dart';
import 'package:frechat/screens/profile/contact/score_detail/personal_score_detail.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_frined.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_contact_cell.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../system/util/avatar_util.dart';
import '../../../widgets/shared/app_bar.dart';
import '../../../widgets/shared/main_scaffold.dart';
import '../../../widgets/theme/original/app_colors.dart';
import '../../../widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PersonalContact extends ConsumerStatefulWidget {
  const PersonalContact({super.key});

  @override
  ConsumerState<PersonalContact> createState() => _PersonalContactState();
}

class _PersonalContactState extends ConsumerState<PersonalContact> {
  late PersonalContactViewModel viewModel;
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;

  @override
  void initState() {
    viewModel = PersonalContactViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  ///滚动监听器
  Future<void> _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      if(!viewModel.isNoMoreData){
        isLoading = true;
        setState(() {});
        await viewModel.searchContactList();
        isLoading = false;
        setState(() {});
      }
      print('已经到达底部');
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ContactListInfo> list = ref.watch(userInfoProvider).contactSearchList?.list ?? [];
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return Scaffold(
      appBar: MainAppBar(
        theme: _theme,
        title: '我的人脉',
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        actions: [_buildHelpBtn()],
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      floatingActionButton: (list.isEmpty) ? null : _inviteBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: _appColorTheme.baseBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildUserImg(),
                SizedBox(height: 12.h),
                _buildNickName(),
                SizedBox(height: 4.h),
                _buildTagList(),
                SizedBox(height: 24.h),
                _buildScoreTitle(),
                _buildScoreList(),
                SizedBox(height: 24.h),
                _buildContactTitle(count: list.length),
                _buildContactList(list),
              ],
            ),
          )
        ),
      ),
    );
  }

  _buildHelpBtn() {
    return InkWell(
      onTap: () {
        _showModalBottomSheet();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        child: ImgUtil.buildFromImgPath(_appImageTheme.iconProfileAgentHelp, size: 24),
      )
    );
  }

  // 活動規則底部彈窗
  void _showModalBottomSheet() {
    showModalBottomSheet(
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32.h),
                child: Text('活动规则', style: _appTextTheme.dialogTitleTextStyle,),
              ),
              Container(
                margin: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.ruleData.length,
                      itemBuilder: (context, index) {
                        return ruleContentWidget(viewModel.ruleData[index]);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 活動規則內容
  Widget ruleContentWidget(String content) {
    return Text(content, style: _appTextTheme.dialogContentTextStyle,);
  }

  _buildUserImg() {
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';

    return (avatarPath == '')
        ? AvatarUtil.defaultAvatar(gender, size: 72.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 72.w);
  }

  _buildNickName() {
    final userName = ref.read(userInfoProvider).userName ?? '';
    final nickName = ref.read(userInfoProvider).nickName;

    final String name = (nickName == '' || nickName == null) ? userName : nickName;

    return MainGradient()
        .text(title: name, fontSize: 20.sp, fontWeight: FontWeight.w700);
  }

  _buildTagList() {
    final num age = ref.read(userInfoProvider).memberInfo?.age ?? 0;
    final bool isRealPerson =
        ref.read(userInfoProvider).memberInfo?.realPersonAuth == 1;
    final bool isRealName =
        ref.read(userInfoProvider).memberInfo?.realNameAuth == 1;
    final num charmLevel = ref.read(userInfoProvider).memberInfo?.charmLevel ?? 0;
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 4.w, // 水平间距
            children: [
              IconTag.genderAge(gender: gender, age: age),
              Visibility(visible: gender == 0, child: IconTag.charmLevel(charmLevel: charmLevel)),
              Visibility(visible: isRealName, child: IconTag.realNameAuth()),
              Visibility(visible: isRealPerson, child: IconTag.realPersonAuth()),
            ],
          )
        ],
      ),
    );
  }

  _buildScoreTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('贡献积分', style: _appTextTheme.labelPrimarySubtitleTextStyle),
      ),
    );
  }

  _buildScoreList() {
    return GestureDetector(
      onTap: () => BaseViewModel.pushPage(
        context,
        PersonalScoreDetail(
          todayRevenue: viewModel.todayRevenue,
          thisWeekRevenue: viewModel.thisWeekRevenue,
          lastWeekRevenue: viewModel.lastWeekRevenue,
          // contactList: viewModel.contactList,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
                title: '今日',
                data: viewModel.todayRevenue,
                imgPath: _appImageTheme.imageProfileContactTodayItem,
                titleTextStyle: _appTextTheme.profileContactTodayTitleTextStyle,
                contentTextStyle:
                    _appTextTheme.profileContactTodayContentTextStyle),
          ),
          SizedBox(width: WidgetValue.horizontalPadding),
          Expanded(
            child: _buildItem(
              title: '本周',
              data: viewModel.thisWeekRevenue,
              imgPath: _appImageTheme.imageProfileContactWeekItem,
              titleTextStyle: _appTextTheme.profileContactWeekTitleTextStyle,
              contentTextStyle:
                  _appTextTheme.profileContactWeekContentTextStyle,
            ),
          ),
          SizedBox(
            width: WidgetValue.horizontalPadding,
          ),
          Expanded(
            child: _buildItem(
                title: '上周',
                data: viewModel.lastWeekRevenue,
                imgPath: _appImageTheme.imageProfileContactLastWeekItem,
                titleTextStyle:
                    _appTextTheme.profileContactLastWeekTitleTextStyle,
                contentTextStyle:
                    _appTextTheme.profileContactLastWeekContentTextStyle),
          ),
        ],
      ),
    );
  }

  _buildItem(
      {required String title,
      required num data,
      required String imgPath,
      required TextStyle titleTextStyle,
      required TextStyle contentTextStyle,}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: WidgetValue.horizontalPadding,
          vertical: WidgetValue.verticalPadding),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset(imgPath).image, fit: BoxFit.fill),
      ),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleTextStyle),
            Text('$data', style: contentTextStyle),
          ],
        ),
      ),
    );
  }

  _buildContactTitle({required num count}){
    String title = '我的人脉 ($count)';
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _appTextTheme.labelPrimarySubtitleTextStyle),
          Visibility(visible:count==0,child: _buildInviteButton(),)
        ],
      ),
    );
  }
  _buildInviteButton(){
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.custom,
        isEnabledTapLimitTimer: false,
        height: 20.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        margin: EdgeInsets.zero,
        radius: 4.w,
        text: '邀请好友',
        colorBegin: _appLinearGradientTheme.buttonPrimaryColor.colors[0],
        colorEnd: _appLinearGradientTheme.buttonPrimaryColor.colors[1],
        textStyle: const TextStyle(
          color:Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        onTap: () => BaseViewModel.pushPage(context,
            const PersonalInviteFriend(type: InviteFriendType.contact)));
  }

  _buildContactList(List<ContactListInfo> list) {
    return (list.isEmpty)
        ? _buildEmptyFriend()
        : CustomList.separatedList(
            physics: const NeverScrollableScrollPhysics(),
            separator: SizedBox(height: WidgetValue.verticalPadding),
            childrenNum: list.length,
            children: (context, index) {
              final ContactListInfo contactListInfo =  list.last;
              final bool isLast =  list[index] == contactListInfo;
              if(isLoading){
                if(isLast){
                  return Column(
                    children: [
                      PersonalContactCell(model: list[index]),
                      _buildLoadMoreIndicator()
                    ],
                  );
                }else{
                  return PersonalContactCell(model: list[index]);
                }
              } else {
                if(isLast){
                  if(viewModel.isNoMoreData){
                    return Column(
                      children: [
                        PersonalContactCell(model: list[index]),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          margin: const EdgeInsets.only(bottom: 80),
                          child: Text("-没有更多数据-", style: _appTextTheme.labelSecondaryTextStyle,)
                        ),
                      ],
                    );
                  }else{
                    return PersonalContactCell(model: list[index]);
              }
                }else{
                  return PersonalContactCell(model: list[index]);
                }
              }}
            );
  }

  _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _inviteBtn() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: WidgetValue.btnBottomPadding),
        padding: EdgeInsets.symmetric(
            horizontal: WidgetValue.horizontalPadding * 2,
            vertical: WidgetValue.verticalPadding),
        decoration: BoxDecoration(
            gradient: _appLinearGradientTheme.buttonPrimaryColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/profile/profile_contact_invite_heart_icon.png',
                width: 24, height: 24),
            const SizedBox(width: 10),
            Text('邀请好友', style:TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.w700,)
            )
          ],
        ),
      ),
      onTap: () => BaseViewModel.pushPage(
          context, const PersonalInviteFriend(type: InviteFriendType.contact)),
    );
  }

  _buildEmptyFriend() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ImgUtil.buildFromImgPath(appImageTheme.imageContactEmpty, size: 150.w),
        Text('您目前没有人脉', style:_appTextTheme.labelPrimarySubtitleTextStyle),
        Text('快去邀请人脉吧', style: _appTextTheme.labelPrimaryContentTextStyle),
      ],
    );
  }
}
