import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/screens/profile/agent/personal_agent_member_info_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_promotion_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalAgentMemberInfo extends ConsumerStatefulWidget {
  final num? parentId;
  final AgentMemberInfo agentMember;
  DateTime startTime;
  DateTime endTime;
  AgentMemberListMode? mode;

  PersonalAgentMemberInfo({
    super.key,
    this.parentId,
    required this.agentMember,
    required this.startTime,
    required this.endTime,
    this.mode
  });

  @override
  ConsumerState<PersonalAgentMemberInfo> createState() => _PersonalAgentMemberInfoState();
}

class _PersonalAgentMemberInfoState extends ConsumerState<PersonalAgentMemberInfo> {
  PersonalAgentMemberViewModel? viewModel;
  AgentMemberListMode? get mode => widget.mode;
  num? get parentId => widget.parentId;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalAgentMemberViewModel(ref: ref, context: context, setState: setState);
    viewModel?.init(totalAmount: widget.agentMember.totalAmount ?? 0, totalAmountWithReward: widget.agentMember.totalAmountWithReward ?? 0,
        onlineDuration: widget.agentMember.onlineDuration ?? 0, pickup: widget.agentMember.pickup ?? 0, messageAmount:  widget.agentMember.messageAmount ?? 0,
        voiceAmount: widget.agentMember.voiceAmount ?? 0, videoAmount: widget.agentMember.videoAmount ?? 0, giftAmount:  widget.agentMember.giftAmount ?? 0,
        pickUpAmount: widget.agentMember.pickupAmount ?? 0, feedDonateAmount: widget.agentMember.feedDonateAmount ?? 0, startTime: widget.startTime, endTime: widget.endTime, userName: widget.agentMember.userName ?? '',
        parentId: parentId ?? 0, mode: mode
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Scaffold(
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '成员资讯',
        actions: [_buildToolTip(), _buildCancelBtn()],
        leading: const SizedBox(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        color: _appColorTheme.baseBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimePicker(),
            SizedBox(height: 12.h),
            memberCard(),
            _buildTitle('语聊收益 / 元'),
            incomeList()
            // messageAndTalkAmount(),
            // giftTotalAndPickupAmount()
          ],
        ),
      )
    );
  }

  _buildToolTip() {
    return Tooltip(
      message: '推广数据为计算所有经由推广邀请码邀请的下一级推广人数"提示；人脉数据为计算所有因下一级推广人数而带进来之总人数',
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: WidgetValue.horizontalPadding),
        child: ImgUtil.buildFromImgPath(
          'assets/profile/profile_agent_help_icon.png',
          size: WidgetValue.primaryIcon,
          fit: BoxFit.scaleDown
        ),
      ),
    );
  }

  _buildCancelBtn() {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: ImgUtil.buildFromImgPath(_appImageTheme.iconClose, size: 24.w, fit: BoxFit.scaleDown)
      ),
      onTap: () => BaseViewModel.popPage(context),
    );
  }

  Widget memberCard() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(
          horizontal: WidgetValue.horizontalPadding,
          vertical: WidgetValue.verticalPadding),
        decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
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
    final num gender = widget.agentMember.gender ?? 0;
    final String avatar = widget.agentMember.avatar ?? '';
    return (widget.agentMember.avatar == null)
      ? AvatarUtil.defaultAvatar(gender ,size: 44.w)
      : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 44.w);
  }

  _buildUserInfo() {
    final String userName = widget.agentMember.userName ?? 'userName';
    final String nickName = widget.agentMember.nickName ?? userName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(nickName, style: _appTextTheme.labelPrimaryTitleTextStyle),
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

  _buildTime() {
    final num lastLoginTime = widget.agentMember?.lastLoginTime ?? 0;
    final num regTime = widget.agentMember?.regTime ?? 0;
    final String regTimeFormat = DateFormatUtil.getDateWith24HourFormat(
        DateTime.fromMillisecondsSinceEpoch(regTime.toInt()),
        needHHMMSS: false);
    final String lastLoginTimeFormat = DateFormatUtil.getDateWith24HourFormat(
        DateTime.fromMillisecondsSinceEpoch(lastLoginTime.toInt()),
        needHHMMSS: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('加入时间：$regTimeFormat', style:_appTextTheme.labelThirdContentTextStyle),
        Text('最近登录：$lastLoginTimeFormat', style: _appTextTheme.labelThirdContentTextStyle),
      ],
    );
  }

  _buildDetail() {
    final bool isAgentLevelTwo = ref.read(userInfoProvider).memberInfo?.agentLevel == 2;
    final num totalAmount = viewModel!.vm_totalAmount ?? 0;
    final num totalAmountWithReward = viewModel!.vm_totalAmountWithReward ?? 0;
    final num onlineDuration = viewModel!.vm_onlineDuration ?? 0;
    final num pickup = viewModel!.vm_pickup ?? 0;
    if(isAgentLevelTwo == false){
      if(totalAmount.toString().length>=9||totalAmountWithReward.toString().length>=9||onlineDuration.toString().length>=9||pickup.toString().length>=9){
        return isAgentLevelTwoLongAmountWidget(totalAmount, totalAmountWithReward, onlineDuration, pickup);
      }else{
        return isAgentLevelTwoWidget(totalAmount, totalAmountWithReward, onlineDuration, pickup);
      }
    }else{
      if(totalAmount.toString().length>=9||onlineDuration.toString().length>=9||pickup.toString().length>=9){
        return notAgentLevelTwoLongAmountWidget(totalAmount, onlineDuration, pickup);
      }else{
        return notAgentLevelTwoWidget(totalAmount, onlineDuration, pickup);
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
            //     type: PersonalAgentMemberUnitType.amount
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
        // SizedBox(height: WidgetValue.separateHeight,),
        // _item(
        //     imgPath: _appImageTheme.iconProfileAgentMedalStar,
        //     title: '贡献金额',
        //     date: totalAmountWithReward,
        //     type: PersonalAgentMemberUnitType.amount
        // ),
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

  _item({
      required String imgPath,
      required String title,
      required dynamic date,
      required PersonalAgentMemberUnitType type
  }) {

    String unit = '元';
    if (type == PersonalAgentMemberUnitType.amount) {
      date = ConvertUtil.toRMB(date);
    } else if (type == PersonalAgentMemberUnitType.frequency) {
      unit = '次';
    } else if (type == PersonalAgentMemberUnitType.time) {
      date = date / 60;
      date = date.toStringAsFixed(2);
      unit = '时';
    }

    return Row(
      children: [
        Image.asset(imgPath, height: WidgetValue.smallIcon),
        SizedBox(width: WidgetValue.separateHeight,),
        Text(title, style: _appTextTheme.labelPrimaryTextStyle),
        SizedBox(width: WidgetValue.separateHeight,),
        Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('$date$unit', style: _appTextTheme.personalAgentSubtitleTextStyle),
        ))
      ],
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(title, style: _appTextTheme.labelPrimaryTitleTextStyle,),
    );
  }

  Widget incomeList(){

    final num vm_messageAmount = viewModel?.vm_messageAmount ?? 0;
    final num vm_giftAmount = viewModel?.vm_giftAmount ?? 0;
    final num vm_voiceAmount = viewModel?.vm_voiceAmount ?? 0;
    final num vm_videoAmount = viewModel?.vm_videoAmount ?? 0;
    final num vm_pickUpAmount = viewModel?.vm_pickUpAmount ?? 0;
    final num vm_feedDonateAmount = viewModel?.vm_feedDonateAmount ?? 0;

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('文字', ConvertUtil.toRMB(vm_messageAmount), _appImageTheme.iconProfileAgentText),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('礼物', ConvertUtil.toRMB(vm_giftAmount), _appImageTheme.iconProfileAgentGift),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('语音', ConvertUtil.toRMB(vm_voiceAmount), _appImageTheme.iconProfileAgentCallVoice),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('视频', ConvertUtil.toRMB(vm_videoAmount), _appImageTheme.iconProfileAgentCallVideo),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('搭讪', ConvertUtil.toRMB(vm_pickUpAmount), _appImageTheme.iconProfileAgentStrikeUp),
          // MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          // nowCharmAndIncomeItem('动态打赏', ConvertUtil.toRMB(vm_feedDonateAmount, decimal: 5), _appImageTheme.iconProfileAgentActivityDonate),
        ],
      ),
    );
  }

  Widget nowCharmAndIncomeItem(String title, String content, String iconPath){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ImgUtil.buildFromImgPath(iconPath, size: 16.w),
            SizedBox(width: 6.w),
            Text(title, style:_appTextTheme.labelPrimarySubtitleTextStyle),
          ],
        ),
        Text(content, style:_appTextTheme.labelPrimaryTextStyle),
      ],
    );
  }

  Widget messageAndTalkAmount() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
                child: PersonalAgentPromotionCell(
                    title: '文字',
                    data: viewModel!.vm_messageAmount!,
                    mainColor: AppColors.mainYellow,
                    imgPath: 'assets/profile/profile_agent_yellow_icon.png')),
            SizedBox(width: 8.w),
            Expanded(
                child: PersonalAgentPromotionCell(
                    title: '语音',
                    data: viewModel!.vm_voiceAmount!,
                    mainColor: AppColors.mainOrange,
                    imgPath: 'assets/profile/profile_agent_orange_icon.png')),
            SizedBox(width: 8.w),
            Expanded(
                child: PersonalAgentPromotionCell(
                    title: '视频',
                    data: viewModel!.vm_videoAmount!,
                    mainColor: AppColors.mainBlue,
                    imgPath: 'assets/profile/profile_agent_blue_icon.png')),
          ],
        ));
  }

  Widget giftTotalAndPickupAmount() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
        child: Row(
          children: [
            Expanded(
                child: PersonalAgentPromotionCell(
                    title: '礼物收益',
                    data: viewModel!.vm_giftAmount!,
                    mainColor: AppColors.mainYellow,
                    imgPath: 'assets/profile/profile_agent_gift_icon.png')),
            SizedBox(width: 8.w),
            Expanded(
                child: PersonalAgentPromotionCell(
                    title: '搭讪',
                    data: viewModel!.vm_pickUpAmount!,
                    mainColor: AppColors.mainYellow,
                    imgPath: 'assets/profile/profile_agent_gift_icon.png')),
            SizedBox(width: 8.w),
            Expanded(child: SizedBox())
          ],
        ));
  }

  _buildTimePicker() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel!.vm_startTime); // YYYY-MM-DD
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel!.vm_endTime); // YYYY-MM-DD
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
          child:  Text('计算区间', style: _appTextTheme.labelPrimaryTitleTextStyle),
        ),
        Row(
          children: [
            _buildTimeItem(
              dateTime:  DateTime.parse(startTimeFormat),
              timeFormat: startTimeFormat,
              onSelect: (date) {
                if (date.isAfter(viewModel!.vm_endTime)) {
                  viewModel!.vm_startTime = date;
                  viewModel!.vm_endTime = date;
                } else {
                  viewModel!.vm_startTime = date;
                }
              },
            ),
            Text(' ~ ', style:_appTextTheme.labelPrimaryTextStyle),
            _buildTimeItem(
              dateTime: DateTime.parse(endTimeFormat),
              timeFormat: endTimeFormat,
              onSelect: (date) {
                if (date.isBefore(viewModel!.vm_startTime)) {
                  viewModel!.vm_startTime = date;
                  viewModel!.vm_endTime = date;
                } else {
                  viewModel!.vm_endTime = date;
                }
              },

            ),
          ],
        )
      ],
    );
  }

  _buildTimeItem({required String timeFormat, required Function(DateTime) onSelect, required DateTime dateTime}) {
    DateTime sixtyDaysAgoDateTime = DateTime.now().subtract(Duration(days: 60));
    DateTime minimumDate = DateTime(sixtyDaysAgoDateTime.year, sixtyDaysAgoDateTime.month, sixtyDaysAgoDateTime.day,);
    DateTime maximumDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,);
    return InkWell(
      onTap: () => Picker.showDatePicker(context,
          initialDateTime: dateTime,
          minimumDate: minimumDate,
          maximumDate:maximumDate ,
          appTheme: _theme,
          onSelect: (date) {
            onSelect(date);
            BaseViewModel.popPage(context);
            viewModel!.resetToInitState();
            // 一級推廣員看底下二級推廣要換 mode
            // agent -> secondaryAgent
            // http://redmine.zyg.com.tw/issues/1953
            if (mode == AgentMemberListMode.agent) {
              viewModel!.getAgentMemberList(mode: AgentMemberListMode.secondaryAgent);
            } else {
              viewModel!.getAgentMemberList(mode: mode);
            }
            setState(() {});
          },
          onCancel: () => BaseViewModel.popPage(context)
      ),
      child: Row(
        children: [
          Text(timeFormat, style:_appTextTheme.labelPrimaryTextStyle),
          SizedBox(width: WidgetValue.separateHeight),
          ImgUtil.buildFromImgPath(_appImageTheme.iconCalendar, size: WidgetValue.smallIcon),
        ],
      ),
    );
  }
}
