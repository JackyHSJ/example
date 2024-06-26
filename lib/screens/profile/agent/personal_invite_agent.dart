
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_reward_ratio_list_res.dart';
import 'package:frechat/screens/profile/agent/personal_invite_agent_view_model.dart';

import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_qrcode.dart';
// import 'package:frechat/screens/profile/invite_friend/personal_invite_agent_view_model.dart';
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
import 'package:wechat_kit/wechat_kit_platform_interface.dart';


/// 需整理到Object 裏面
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


List<Color> gradientColor1 = [AppColors.mainOrange, AppColors.mainYellow];
List<Color> gradientColor2 = [Color(0xff9637F3), Color(0xffF5C06E)];

Color titleColor1 = Color(0xff444648);
Color titleColor2 = Color(0xff9637F3);

Color bgColor1 = Color(0xFFD62F1B);
Color bgColor2 = Color(0xff9637F3);


// 邀请成員
class PersonalInviteAgent extends ConsumerStatefulWidget {
  final InviteFriendType type;

  const PersonalInviteAgent({
    super.key,
    required this.type
  });

  @override
  ConsumerState<PersonalInviteAgent> createState() => _InviteFriendState();
}

class _InviteFriendState extends ConsumerState<PersonalInviteAgent> {

  late PersonalInviteAgentViewModel viewModel;
  InviteFriendType get type => widget.type;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;


  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalInviteAgentViewModel(ref: ref, setState: setState, context: context);
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
      title: '邀请成员',
      backgroundColor: Colors.transparent,
      leading: const SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
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

    tableList.add(bannerWidget());
    tableList.add(SizedBox(height: 11.h));

    // http://redmine.zyg.com.tw/issues/2043 暫時不顯示
    // if (viewModel.currentAgentRewardRatioLevel != null && viewModel.nextAgentRewardRatioLevel != null) {
    //   tableList.add(_buildTitle('目前级别', titleColor1));
    //   tableList.add(_buildTable(viewModel.currentAgentRewardRatioLevel, gradientColor1, bgColor1));
    // }
    // if (viewModel.nextAgentRewardRatioLevel != null) {
    //   tableList.add(_buildTitle('下一级别', titleColor1));
    //   tableList.add(_buildTable(viewModel.nextAgentRewardRatioLevel, gradientColor1, bgColor1));
    // }
    //
    // // 最高級顯示，因為找不到下一級，所以會 null
    // if (viewModel.currentAgentRewardRatioLevel != null && viewModel.nextAgentRewardRatioLevel == null) {
    //   tableList.add(_buildTitle('已达最高级', titleColor2));
    //   tableList.add(_buildTable(viewModel.currentAgentRewardRatioLevel, gradientColor2, bgColor2));
    // }
    // tableList.add(SizedBox(height: 15.h));
    tableList.add(myInviteNumber());

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tableList
    );
  }
  
  Widget _buildTitle(String value, Color titleColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Center(
        child: Text('$value', style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: titleColor,
        ),
        ),
      ),
    );
  }

  Widget _buildTableContentCell(String value, String text, String type, List<Color> gradientColor) {

    String modifiedValue = '';

    if (type == 'rewardName') {
      modifiedValue = value;
    } else if (type == 'rewardCondition') {
      modifiedValue = '>$value';
    } else if (type == 'rewardRatio') {
      modifiedValue = '$value%';
    }

    return Container(
      height: 36,
      color: const Color(0xFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: gradientColor,
                stops: [0.111, 0.9222],
              ).createShader(bounds);
            },
            child: Text('$modifiedValue', style: italicText()),
          ),
          (text.isNotEmpty) ? const SizedBox(width: 4) : const SizedBox(),
          (text.isNotEmpty) ? Text(text, style: _appTextTheme.bottomRuleTableTextStyle) : const SizedBox()
        ],
      ),
    );
  }

  _buildTableContents(AgentRewardRatioInfo? agentRewardRatioInfo, List<Color> gradientColor) {

    final String rewardName = agentRewardRatioInfo?.rewardName.toString() ?? '';
    final String rewardCondition = agentRewardRatioInfo?.rewardCondition.toString() ?? '';
    final String rewardRatio = agentRewardRatioInfo?.rewardRatio.toString() ?? '';

    List<Widget> rowList = [
      _buildTableContentCell(rewardName, '', 'rewardName', gradientColor),
      _buildTableContentCell(rewardCondition, '积分', 'rewardCondition', gradientColor),
      _buildTableContentCell(rewardRatio, '积分', 'rewardRatio', gradientColor),
    ];

    return TableRow(
        children: rowList
    );
  }

  _buildTable(AgentRewardRatioInfo? agentRewardRatioInfo, List<Color> gradientColor, Color bgColor){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: const Color(0xFFEAEAEA)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Table(
          children: [
            _buildTableTitles(bgColor),
            _buildTableContents(agentRewardRatioInfo, gradientColor),
          ],
        ),
      ),
    );
  }

  _buildTableTitles(Color bgColor) {
    List<Widget> titleList = [
      _buildTableTitleCell('级别', '', bgColor),
      _buildTableTitleCell('团队总收益', '', bgColor),
      _buildTableTitleCell('奖励占成', '', bgColor),
    ];
    return TableRow(
        children: titleList
    );
  }

  Widget _buildTableTitleCell(String title, String type, Color bgColor) {
    return Container(
        height: 36,
        padding: const EdgeInsets.only(left: 8, right: 8),
        color: bgColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12.0, fontWeight: FontWeight.w700, height: 1.25)),
            ]
        )
    );
  }

  // 活動規則內容
  Widget ruleContentWidget(String content) {
    return Text(content, style: _appTextTheme.dialogContentTextStyle,);
  }

  // 邀請好友返利橫幅
  Widget bannerWidget() {
    return Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: AspectRatio(
          aspectRatio: 1029 / 333,
          child: ImgUtil.buildFromImgPath('assets/images/invite_agent_banner.png', width: double.infinity, fit: BoxFit.contain),
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
          const PersonalShareRow(type: InviteFriendType.agent)
        ],
      ),
    );
  }

  _buildTitleAndCopy() {
    final String agentName = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
    return InkWell(
      onTap: () {
        BaseViewModel.copyText(context, copyText: agentName);
        // BaseViewModel.showToast(context, '已复制分享链接');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(agentName, style: _appTextTheme.inviteCodeTextStyle,),
          ImgUtil.buildFromImgPath(_appImageTheme.iconProfileAgentCopy, size: 24),
        ],
      ),
    );
  }


  // 漸層色按鈕
  Widget gradientButton(Color beginColor, Color endColor, String text) {
    return Container(
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 8.w, right: 12.w),
      alignment: const Alignment(0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: LinearGradient(
          colors: [beginColor, endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 16,
            height: 16,
            image: (text == '二维分享')
                ? const AssetImage('assets/images/icon_qrcode.png')
                : const AssetImage('assets/images/icon_link.png'),
          ),
          Container(
            margin: EdgeInsets.only(left: 2.w),
            child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),),
          ),
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
          ImgUtil.buildFromImgPath("assets/images/empty.png", size: 176.w),
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
      context: context,
      backgroundColor: _appColorTheme.appBarBackgroundColor,
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
              ),
              _buildRuleTable(),
            ],
          ),
        );
      },
    );
  }

  ///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
  ///
  ///
  ///
  /// 規則彈窗 Table
  _buildRuleTable(){

    List<TableRow> tableRows = [];
    for (var item in viewModel.agentRewardRatioList) {
      tableRows.add(_buildRuleTableContents(item));
    }

    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: const Color(0xFFEAEAEA)),

      ),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(10.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
            verticalInside: BorderSide(width: 1.0, color: Color(0xFFEAEAEA)),
          ),
          children: [
            _buildRuleTableTitles(),
            ...tableRows
          ],
        ),
      ),
    );
  }


  _buildRuleTableTitles() {
    List<Widget> titleList = [
      _buildRuleTableTitleCell('级别', ''),
      _buildRuleTableTitleCell('团队总收益', ''),
      _buildRuleTableTitleCell('奖励占成', ''),
    ];
    return TableRow(
        children: titleList
    );
  }

  Widget _buildRuleTableTitleCell(String title, String type) {
    return Container(
        height: 36,
        padding: const EdgeInsets.only(left: 8, right: 8),
        // color: const Color(0xFFD62F1B),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: _appTextTheme.bottomRuleTableTextStyle),
            ]
        )
    );
  }

  Widget _buildRuleTableContentCell(String value, String text, String type) {

    String modifiedValue = '';

    if (type == 'rewardName') {
      modifiedValue = value;
    } else if (type == 'rewardCondition') {
      modifiedValue = '>$value';
    } else if (type == 'rewardRatio') {
      modifiedValue = '$value%';
    }

    return Container(
      height: 36,
      // color: const Color(0xFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$modifiedValue', style: _appTextTheme.bottomRuleTableTextStyle),
          (text.isNotEmpty) ? const SizedBox(width: 4) : const SizedBox(),
          (text.isNotEmpty) ? Text(text, style: _appTextTheme.bottomRuleTableTextStyle) : const SizedBox()
        ],
      ),
    );
  }

  _buildRuleTableContents(AgentRewardRatioInfo? agentRewardRatioInfo) {

    final String rewardName = agentRewardRatioInfo?.rewardName.toString() ?? '';
    final String rewardCondition = agentRewardRatioInfo?.rewardCondition.toString() ?? '';
    final String rewardRatio = agentRewardRatioInfo?.rewardRatio.toString() ?? '';

    List<Widget> rowList = [
      _buildRuleTableContentCell(rewardName, '', 'rewardName'),
      _buildRuleTableContentCell(rewardCondition, '积分', 'rewardCondition'),
      _buildRuleTableContentCell(rewardRatio, '', 'rewardRatio'),
    ];

    return TableRow(
        children: rowList
    );
  }

}

