
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/app_config/app_config.dart';

import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_qrcode.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_view_model.dart';
import 'package:frechat/system/base_view_model.dart';

import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/profile/personal_share_row.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';

import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

BoxDecoration decorationGradient() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Color.fromRGBO(0, 0, 0, 0.25),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment(0.5, -1.0),
      end: Alignment(0.5, 2.0),
      stops: [0.111, 0.9222],
      colors: [
        AppColors.mainYellow,
        AppColors.mainOrange,
      ],
      transform: GradientRotation(261 * 3.14159265 / 180),
    ),
  );
}

TextStyle italicText() {
  return const TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      height: 1);
}

TextStyle greyText() {
  return const TextStyle(
      color: AppColors.textFormBlack,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1);
}

// 邀请好友
class PersonalInviteFriend extends ConsumerStatefulWidget {
  final InviteFriendType type;

  const PersonalInviteFriend({
    super.key,
    required this.type
  });

  @override
  ConsumerState<PersonalInviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends ConsumerState<PersonalInviteFriend> {

  late PersonalInviteFriendViewModel viewModel;
  InviteFriendType get type => widget.type;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    viewModel = PersonalInviteFriendViewModel(ref: ref, setState: setState, context: context);
    viewModel.init(type);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      appBar: _buildAppbar(),
      padding: EdgeInsets.zero,
      child: Container(
        color:_appColorTheme.baseBackgroundColor,
        padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
          left: WidgetValue.horizontalPadding,
          right: WidgetValue.horizontalPadding
        ),
        child: Stack(
          children: [
            (viewModel.isLoading)
                  ? LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor)
                  : _buildMainContent(),
              _buildInviteWidget()
          ],
        ),
      )
    );
  }

  Widget _buildAppbar(){
    return MainAppBar(
      theme: _theme,
      title: '邀请好友',
      leading: const SizedBox(),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () => BaseViewModel.popPage(context),
            child: ImgUtil.buildFromImgPath(_appImageTheme.bottomSheetCancelBtnIcon, size: 24),
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {

    List<Widget> tableList = [];

    // http://redmine.zyg.com.tw/issues/1585
    if (viewModel.agentName.isNotEmpty) {
      tableList.add(myInviteNumber());
    } else if (viewModel.income != 0 || viewModel.deposit != 0) {
      tableList.add(bannerWidget());
      tableList.add(SizedBox(height: 11.h));
      tableList.add(_buildTable());
      tableList.add(SizedBox(height: 15.h));
      tableList.add(myInviteNumber());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tableList
    );
  }

  Widget _buildTableContentCell(num value) {

    return Container(
      height: 36,
      color: const Color(0xFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [AppColors.mainOrange, AppColors.mainYellow],
                stops: [0.111, 0.9222],
              ).createShader(bounds);
            },
            child: Text('$value%', style: italicText()),
          ),
          const SizedBox(width: 4),
          Text('积分', style: greyText()),
        ],
      ),
    );
  }

  _buildTableContents() {

    List<Widget> rowList = [
      if (viewModel.deposit != 0) _buildTableContentCell(viewModel.deposit),
      if (viewModel.income != 0) _buildTableContentCell(viewModel.income)
    ];

    return TableRow(
      children: rowList
    );
  }

  _buildTable(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: const Color(0xFFEAEAEA)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
            verticalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
          ),
          children: [
            _buildTableTitles(),
            _buildTableContents(),
          ],
        ),
      ),
    );
  }

  _buildTableTitles() {
    List<Widget> titleList = [
      if (viewModel.deposit != 0) _buildTableTitleCell('好友每次充值', '返利'),
      if (viewModel.income != 0) _buildTableTitleCell('好友每笔收益', '返利'),
    ];
    return TableRow(
      children: titleList
    );
  }

  Widget _buildTableTitleCell(String title, String type) {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(left: 8, right: 8),
      color: const Color(0xFFD62F1B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(title, style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12.0, fontWeight: FontWeight.w700, height: 1.25)),
          const SizedBox(width: 4),
          Container(
            width: 33,
            height: 16,
            decoration: decorationGradient(),
            child: Center(
              child: Text(type, style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 10.0, fontWeight: FontWeight.w700, height: 1.25)),
            )
          )
        ]
      )
    );
  }

  // 活動規則內容
  Widget ruleContentWidget(String content) {
    return Text(content, style: _appTextTheme.dialogContentTextStyle,);
  }

  // 邀请好友返利橫幅
  Widget bannerWidget() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: AspectRatio(
        aspectRatio: 3.09,
        child: ImgUtil.buildFromImgPath(_appImageTheme.imgInviteFriendBanner, width: double.infinity, fit: BoxFit.cover),
      )
    );
  }
  //我的邀请碼
  Widget myInviteNumber() {
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 2),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child: Column(
        children: [
          Text("我的邀请码", style: _appTextTheme.labelPrimaryTextStyle,),
          _buildTitleAndCopy(),
          SizedBox(height: WidgetValue.verticalPadding),
          /// Tel: 13579246850
          /// Jacky00: 推廣邀请碼 5135222
          const PersonalShareRow(type: InviteFriendType.contact)
        ],
      ),
    );
  }

  _buildTitleAndCopy() {
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    return InkWell(
      onTap: () {
        BaseViewModel.copyText(context, copyText: userName);
        // BaseViewModel.showToast(context, '已复制分享链接');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(userName, style: _appTextTheme.inviteCodeTextStyle,),
          ImgUtil.buildFromImgPath(_appImageTheme.iconProfileAgentCopy, size: 24),
        ],
      ),
    );
  }

  // 沒有人脈組件
  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 176.w,
            height: 176.w,
            image: const AssetImage("assets/images/empty.png"),
          ),
          Container(
            margin: EdgeInsets.only(top: 14.h),
            child: Text(
              '您目前没有人脉',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textFormBlack,
              ),
            ),
          ),
          Text(
            '快去邀请人脉吧',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textFormBlack,
            ),
          ),
        ],
      ),
    );
  }

  // 活動規則紅包
  Widget _buildInviteWidget() {

    if (viewModel.agentName.isNotEmpty) return SizedBox();

    return Positioned(
        right: 0,
        top: MediaQuery.of(context).size.height - 300,
        child: GestureDetector(
          onTap: _showModalBottomSheet,
          child: Image(
            width: 80.w,
            height: 80.h,
            image: const AssetImage('assets/images/icon_invent_rule.png'),
          ),
        ));
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

  // QR code 彈窗
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InviteFriendQrcodeDialog(type: type);
      },
    );
  }
}

