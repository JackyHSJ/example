
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/agent_tag_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_reward_ratio_list_res.dart';
import 'package:frechat/screens/profile/agent/personal_agent_member_info.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/personal_second_agent_list.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../system/repository/http_setting.dart';

class PersonalAgentMemberCell extends ConsumerStatefulWidget {
  const PersonalAgentMemberCell({
    super.key,
    this.parentId,
    required this.agentMember,
    required this.startTime,
    required this.endTime,
    this.isEnableNextPageArrow = true,
    this.mode
  });
  final num? parentId;
  final AgentMemberInfo? agentMember;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isEnableNextPageArrow;
  final AgentMemberListMode? mode;

  @override
  ConsumerState<PersonalAgentMemberCell> createState() => _PersonalAgentMemberCellState();
}

class _PersonalAgentMemberCellState extends ConsumerState<PersonalAgentMemberCell> {
  AgentMemberInfo? get agentMember => widget.agentMember;
  bool get isEnableNextPageArrow => widget.isEnableNextPageArrow;
  AgentMemberListMode? get mode => widget.mode;
  num? get parentId => widget.parentId;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _mainWidget()),
          _buildArrowToNextPage()
        ],
      ),
    );
  }

  _mainWidget() {
    return InkWell(
      onTap: () => BaseViewModel.pushPage(context, PersonalAgentMemberInfo(
          parentId: parentId,
          agentMember: widget.agentMember ?? AgentMemberInfo(),
          startTime: widget.startTime ?? DateTime.now(),
          endTime: widget.endTime ?? DateTime.now(),
          mode: mode
        )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              SizedBox(width: WidgetValue.horizontalPadding),
              _buildUserInfo(),
            ],
          ),
          _buildTime(),
          _buildDetail()
        ],
      ),
    );
  }

  _buildAvatar() {
    final String avatar = widget.agentMember?.avatar ?? '';
    final num gender = widget.agentMember?.gender ?? 0;
    return (widget.agentMember?.avatar == null)
        ? AvatarUtil.defaultAvatar(gender ,size: 44.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 44.w);
  }
  
  _buildUserInfo(){
    final String userName = agentMember?.userName ?? 'userName';
    final String nickName = agentMember?.nickName ?? userName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserNameAndTag(nickName),
        InkWell(
          onTap: () => BaseViewModel.copyText(context, copyText: userName),
          child: Row(
            children: [
              Text(userName, style: _appTextTheme.labelPrimarySubtitleTextStyle),
              SizedBox(width: WidgetValue.separateHeight,),
              ImgUtil.buildFromImgPath(_appImageTheme.iconProfileAgentCopy, size: 16)
            ],
          ),
        )
      ],
    );
  }

  _buildUserNameAndTag(String nickName) {
    return Row(
      children: [
        Text(nickName, style: _appTextTheme.labelPrimaryTitleTextStyle),
        // SizedBox(width: WidgetValue.separateHeight,),
        // _buildAgentTag(),
      ],
    );
  }
  
  _buildTime(){
    final num lastLoginTime = agentMember?.lastLoginTime ?? 0;
    final num regTime = agentMember?.regTime ?? 0;
    final String regTimeFormat = DateFormatUtil.getDateWith24HourFormat(
        DateTime.fromMillisecondsSinceEpoch(regTime.toInt()),
        needHHMMSS: false
    );
    final String lastLoginTimeFormat = DateFormatUtil.getDateWith24HourFormat(
        DateTime.fromMillisecondsSinceEpoch(lastLoginTime.toInt()),
        needHHMMSS: false
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('加入时间：$regTimeFormat', style:_appTextTheme.labelThirdContentTextStyle),
        Text('最近登录：$lastLoginTimeFormat', style: _appTextTheme.labelThirdContentTextStyle),
      ],
    );
  }

  num _getRewardRatioNum() {
    num totalBonus = 0;
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final num? agentLevel = userInfoModel.memberInfo?.agentLevel;
    final WsAgentRewardRatioListRes? agentRewardRatioList = userInfoModel.agentRewardRatioList;
    final num todayIncome = userInfoModel.agentPromoterInfo?.todayIncome ?? 0;
    final num todayPrimaryIncome = userInfoModel.agentPromoterInfo?.todayPrimaryIncome ?? 0;

    if (agentLevel == 1) {
      totalBonus = todayIncome; // 一級帶 todayIncome
    } else if (agentLevel == 2) {
      totalBonus = todayPrimaryIncome; // 二級帶 todayPrimaryIncome
    }

    final List<AgentRewardRatioInfo> currentRatio = agentRewardRatioList?.list?.where((info) {
      final num condition = info.rewardCondition ?? 0;
      final bool isConform = totalBonus >= condition;
      return isConform;
    }).toList() ?? [];
    final AgentRewardRatioInfo result = currentRatio.isEmpty || currentRatio == [] ? AgentRewardRatioInfo() : currentRatio.last;
    return result.rewardRatio ?? 0;
  }

  _buildDetail() {
    final num totalAmount = agentMember?.totalAmount ?? 0;
    final num totalAmountDouble = double.parse(totalAmount.toStringAsFixed(2));
    // final num totalAmountWithReward = agentMember?.totalAmountWithReward ?? 0;

    final num ratio = _getRewardRatioNum() / 100;
    final num totalAmountWithRewardRatio = ratio * totalAmount;
    final num totalAmountWithRewardDouble = double.parse(totalAmountWithRewardRatio.toStringAsFixed(2));
    final num onlineDuration = agentMember?.onlineDuration ?? 0;
    final num onlineDurationDouble = double.parse(onlineDuration.toStringAsFixed(2));
    final num pickup = agentMember?.pickup ?? 0;
    final num pickupDouble = double.parse(pickup.toStringAsFixed(2));

    final bool isAgentLevelTwo = ref.read(userInfoProvider).memberInfo?.agentLevel == 2;
    if(isAgentLevelTwo == false){
      if(totalAmountDouble.toString().length>=9||totalAmountWithRewardDouble.toString().length>=9||onlineDurationDouble.toString().length>=9||pickupDouble.toString().length>=9){
        return isAgentLevelTwoLongAmountWidget(totalAmountDouble, totalAmountWithRewardDouble, onlineDurationDouble, pickupDouble);
      }else{
        return isAgentLevelTwoWidget(totalAmountDouble, totalAmountWithRewardDouble, onlineDurationDouble, pickupDouble);
      }

    }else{
      if(totalAmountDouble.toString().length>=9||onlineDurationDouble.toString().length>=9||pickupDouble.toString().length>=9){
        return notAgentLevelTwoLongAmountWidget(totalAmountDouble, onlineDurationDouble, pickupDouble);
      }else{
        return notAgentLevelTwoWidget(totalAmountDouble, onlineDurationDouble, pickupDouble);
      }
    }
  }

  Widget isAgentLevelTwoWidget(num totalAmount, num totalAmountWithReward, num onlineDuration, num pickup){
    return Column(
      children: [
        SizedBox(height: WidgetValue.separateHeight),
        Row(
          children: [
            Expanded(child: _item(
                imgPath:  _appImageTheme.iconProfileAgentWallet,
                title: '总收益',
                date: totalAmount,
                type: PersonalAgentMemberUnitType.amount
            )),
            // Expanded(child: _item(
            //     imgPath: _appImageTheme.iconProfileAgentMedalStar,
            //     title: '贡献金额',
            //     date: totalAmountWithReward,
            //     type: PersonalAgentMemberUnitType.amount,
            //     isZeroTitle: '未达标'
            // )),
          ],
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        Row(
          children: [
            Expanded(child: _item(
                imgPath: _appImageTheme.iconProfileAgentTime,
                title: '在线时长',
                date: onlineDuration,
                type: PersonalAgentMemberUnitType.time
            )),
            Expanded(child: _item(
                imgPath: _appImageTheme.iconProfileAgentHeart,
                title: '搭讪数量',
                date: pickup,
                type: PersonalAgentMemberUnitType.frequency
            )),
          ],
        ),
        SizedBox(height: WidgetValue.separateHeight,),
      ],
    );
  }

  Widget notAgentLevelTwoWidget(num totalAmount, num onlineDuration, num pickup){
    return Column(
      children: [
        SizedBox(height: WidgetValue.separateHeight,),
        Row(
          children: [
            Expanded(child: _item(
                imgPath:  _appImageTheme.iconProfileAgentWallet,
                title: '总收益',
                date: totalAmount,
                type: PersonalAgentMemberUnitType.amount
            )),
            Expanded(child: _item(
                imgPath: _appImageTheme.iconProfileAgentTime,
                title: '在线时长',
                date: onlineDuration,
                type: PersonalAgentMemberUnitType.time
            )),
          ],
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        Row(
          children: [
            Expanded(child: _item(
                imgPath: _appImageTheme.iconProfileAgentHeart,
                title: '搭讪数量',
                date: pickup,
                type: PersonalAgentMemberUnitType.frequency
            )),
          ],
        ),
        SizedBox(height: WidgetValue.separateHeight,),
      ],
    );
  }

  Widget isAgentLevelTwoLongAmountWidget(num totalAmount, num totalAmountWithReward, num onlineDuration, num pickup){
    return Column(
      children: [
        SizedBox(height: WidgetValue.separateHeight,),
        _item(
            imgPath:  _appImageTheme.iconProfileAgentWallet,
            title: '总收益',
            date: totalAmount,
            type: PersonalAgentMemberUnitType.amount
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        _item(
            imgPath: _appImageTheme.iconProfileAgentMedalStar,
            title: '贡献金额',
            date: totalAmountWithReward,
            type: PersonalAgentMemberUnitType.amount,
            isZeroTitle: '未达标'
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        _item(
            imgPath: _appImageTheme.iconProfileAgentTime,
            title: '在线时长',
            date: onlineDuration,
            type: PersonalAgentMemberUnitType.time
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        _item(
            imgPath: _appImageTheme.iconProfileAgentHeart,
            title: '搭讪数量',
            date: pickup,
            type: PersonalAgentMemberUnitType.frequency
        ),
      ],
    );
  }

  Widget notAgentLevelTwoLongAmountWidget(num totalAmount, num onlineDuration, num pickup){
    return Column(
      children: [
        SizedBox(height: WidgetValue.separateHeight,),
         _item(
            imgPath:  _appImageTheme.iconProfileAgentWallet,
            title: '总收益',
            date: totalAmount,
            type: PersonalAgentMemberUnitType.amount
        ),
        _item(
            imgPath: _appImageTheme.iconProfileAgentTime,
            title: '在线时长',
            date: onlineDuration,
            type: PersonalAgentMemberUnitType.time
        ),
        SizedBox(height: WidgetValue.separateHeight,),
        _item(
            imgPath: _appImageTheme.iconProfileAgentHeart,
            title: '搭讪数量',
            date: pickup,
            type: PersonalAgentMemberUnitType.frequency
        ),
        SizedBox(height: WidgetValue.separateHeight,),
      ],
    );
  }

  Widget _item({
    required String imgPath,
    required String title,
    required dynamic date,
    required PersonalAgentMemberUnitType type,
    String? isZeroTitle
  }) {

    String unit = '元';
    if (type == PersonalAgentMemberUnitType.amount) {
      date = ConvertUtil.toRMB(date);
    } else if (type == PersonalAgentMemberUnitType.frequency){
      unit = '次';
    } else if (type == PersonalAgentMemberUnitType.time){
      date = date/60;
      date = date.toStringAsFixed(2);
      unit = '时';
    }
    final String dataStr = (date == '0.00' && isZeroTitle != null) ? isZeroTitle : '$date$unit';
    return Row(
      children: [
        Image.asset(imgPath, height: WidgetValue.smallIcon),
        SizedBox(width: WidgetValue.separateHeight,),
        Text(title, style: _appTextTheme.labelPrimaryTextStyle),
        SizedBox(width: WidgetValue.separateHeight,),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(dataStr, style: _appTextTheme.personalAgentSubtitleTextStyle),
          )
        )
      ],
    );
  }

  _buildArrowToNextPage() {
    return Visibility(
      visible: isEnableNextPageArrow,
      child: InkWell(
        onTap: () => BaseViewModel.pushPage(context, PersonalSecondAgentList(agentMember: agentMember)),
        child: Column(
          children: [
            ImgUtil.buildFromImgPath(
              'assets/profile/profile_agent_next_page_btn.png',
              size: WidgetValue.primaryIcon,
            ),
            SizedBox(width: WidgetValue.primaryIcon, height: 100)
          ],
        ),
      ),
    );
  }
}