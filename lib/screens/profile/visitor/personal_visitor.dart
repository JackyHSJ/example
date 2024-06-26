
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/profile/visitor/personal_visitor_view_model.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_love_button.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';


class PersonalVisitor extends ConsumerStatefulWidget {
  const PersonalVisitor({super.key});

  @override
  ConsumerState<PersonalVisitor> createState() => _PersonalVisitorState();
}

class _PersonalVisitorState extends ConsumerState<PersonalVisitor> {
  late PersonalVisitorViewModel viewModel;
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  num? gender;

  @override
  void initState() {
    super.initState();
    gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    viewModel = PersonalVisitorViewModel(setState: setState, ref: ref, context: context);
    viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;

    return MainScaffold(
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight()),
      appBar: _buildMainAppbar(),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
        child: (viewModel.visitorList.isEmpty)
          ? _buildEmptyWidget()
          : _buildListView()
    );
  }

  // Appbar
  Widget _buildMainAppbar() {
    return MainAppBar(
      theme: _theme,
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      title: '我的访客',
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }

  Widget _buildVisitorListView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.visitorList.length,
      itemBuilder: (context, index) {
        return visitorListViewItem(viewModel.visitorList[index],index);
      }
    );
  }

  // Loading 樣式
  Widget _buildLoading() {
    return Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: SizedBox(
              width: 12.w,
              height: 12.h,
              child: const FittedBox(
                child: CircularProgressIndicator(),
              )
          ),
        )
    );
  }

  Widget _buildListView() {
    return SingleChildScrollView(
      controller: viewModel.scrollController,
      child: Column(
        children: [
          _buildVisitorListView(),
          (viewModel.isLoading) ? _buildLoading() : SizedBox(height: viewModel.isNoMoreData ? 0 : 28.h),
          (viewModel.isNoMoreData) ? _buildNoMoreWidget() : const SizedBox()
        ],
      )
    );
  }

  Widget visitorListViewItem(VisitorInfo visitorInfo, int index){

    return InkWell(
      key: ValueKey(index),
      onTap: () async {
        WsMemberInfoRes memberInfoRes = await viewModel.getInfoAndGoUserInfoView(visitorInfo.userName ?? '');
        DisplayMode displayMode = DisplayMode.strikeUp;
        bool isAlreadyStrikeUp = viewModel.isStrikeUp(userName: visitorInfo.userName!);
        if (isAlreadyStrikeUp) displayMode = DisplayMode.chatMessage;
        if(context.mounted){
          BaseViewModel.pushPage(context, UserInfoView(memberInfo: memberInfoRes,
              searchListInfo: null, displayMode: displayMode)
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        height: 88.h,
        child: Row(
          children: [
            _buildAvatar(visitorInfo.avatar, visitorInfo.age),
            const SizedBox(width: 10),
            Expanded(child: visitorInfoWidget(visitorInfo,index),),
            const SizedBox(width: 10),
            _strikeUpButton(visitorInfo),
          ],
        ),
      ),
    );
  }

  // 搭訕/心動 按鈕
  Widget _strikeUpButton(VisitorInfo visitorInfo) {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final String postUserName = visitorInfo.userName ?? '';
    return Visibility(
      visible: myUserName != postUserName,
      child: Consumer(builder: (context, ref, _) {
        final bool isAlreadyStrikeUp = ref.watch(strikeUpProvider).isAlreadyStrikeUp(userName: visitorInfo.userName ?? '');
        return StrikeUpListLoveButton(
          isChat: isAlreadyStrikeUp,
          gender: gender,
          height: 28.h,
          width: 60.w,
          onStrikeUpPress: () async {
            viewModel.strikeUp(userName: visitorInfo.userName ?? '');
          },
          onChatPress: () async {
            viewModel.openChatRoom(userName: visitorInfo.userName ?? '');
          },
        );
      }),
    );
  }

  // 頭像
  Widget _buildAvatar(String? avatarPath,num? gender){
    return (avatarPath != null)
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath)
        : AvatarUtil.defaultAvatar(gender!);
  }

  // 訪客資訊
  Widget visitorInfoWidget(VisitorInfo visitorInfo,int index) {

    num gender = visitorInfo.gender ?? 0;
    num age = visitorInfo.age ?? 0;
    String userName = visitorInfo.userName ?? '';
    String nickName = visitorInfo.nickName ?? '';
    String displayName = ConvertUtil.displayName(userName, nickName, '');
    num realPersonAuth = visitorInfo.realPersonAuth ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(height: 2.h),
              Text(displayName, style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _appColorTheme.visitorPrimaryTextColor
              )),
              SizedBox(width: 4.w),
              IconTag.genderAge(gender: gender, age: age),
              SizedBox(width: 4.w),
              realPersonAuth == 1 ? IconTag.realPersonAuth() : const SizedBox()
            ],
          ),
        ),
        SizedBox(height: 4.h),
        introduce(index),
        SizedBox(height: 4.h),
        differenceTime(visitorInfo.updateTime!.toInt())
      ],
    );
  }

  // 幾分鐘前看過你
  Widget differenceTime(int timeStamp){
    return Text(
      '${viewModel.getTimeDifferenceString(timeStamp)}前看过你',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: _appColorTheme.visitorSeenTextColor,
        fontSize: 10
      )
    );
  }

  // 自我介紹
  Widget introduce(int index) {
    return Text(
      viewModel.visitorTextList[index],
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _appColorTheme.visitorSecondaryTextColor
      )
    );
  }

  // 没有更多数据
  Widget _buildNoMoreWidget() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        alignment: Alignment.center,
        child: Text("-没有更多数据-", style: _appTextTheme.labelSecondaryTextStyle,)
    );
  }

  // Empty
  Widget _buildEmptyWidget(){

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.friendEmptyBanner, size: 150.w),
        SizedBox(height:15.h),
        Text('您目前还没有访客', style: TextStyle(color: _appColorTheme.visitorEmptyPrimaryTextColor, fontSize: 14, fontWeight: FontWeight.w700)),
        SizedBox(height:2.h),
        Text('等待人造访吧', style: TextStyle(color: _appColorTheme.visitorEmptySecondaryTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
      ],
    );
  }
}