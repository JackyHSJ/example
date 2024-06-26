
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/agent/link/personal_agent_link_view_model.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_qrcode.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_promotion_cell.dart';
import 'package:frechat/widgets/profile/personal_share_row.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';

//
// 渠道連接(Tab 3)
//

class PersonalAgentLink extends ConsumerStatefulWidget {
  const PersonalAgentLink({super.key});

  @override
  ConsumerState<PersonalAgentLink> createState() => _PersonalAgentLinkState();
}

class _PersonalAgentLinkState extends ConsumerState<PersonalAgentLink> {
  late PersonalAgentLinkViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;



  @override
  void initState() {
    viewModel = PersonalAgentLinkViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      color: _appColorTheme.baseBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTimeRange(),
          // SizedBox(height: WidgetValue.verticalPadding),
          // _buildTitle('链接统计'),
          // _twoItem(
          //     title1: '昨日注册用户', data1: 123, mainColor1: AppColors.mainYellow,
          //     imgPath1: 'assets/profile/profile_agent_icon_2.png',
          //     title2: '总注册用户', data2: 456, mainColor2: AppColors.mainOrange,
          //     imgPath2: 'assets/profile/profile_agent_icon_1.png'
          // ),
          // SizedBox(height: WidgetValue.separateHeight,),
          // _twoItem(
          //     title1: '昨日链接点击次数', data1: 123, mainColor1: AppColors.mainBlue,
          //     imgPath1: 'assets/profile/profile_agent_icon_7.png',
          //     title2: '链接总点击次数', data2: 456, mainColor2: AppColors.mainPurple,
          //     imgPath2: 'assets/profile/profile_agent_icon_8.png'
          // ),
          SizedBox(height: WidgetValue.verticalPadding),
          myInviteNumber(),
          _buildDes()
        ],
      ),
    );
  }

  // Widget agentLinkList(){
  //   return Container(
  //     // margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
  //     padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //       border: Border.all(width: 1, color: Color(0xFFEAEAEA)),
  //     ),
  //     child:Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         nowCharmAndIncomeItem('总收益/昨日注册用户', roundToTwoDecimals(viewModel.totalAmount).toString()),
  //         Divider(height: 12.w,color: Color(0xFFEAEAEA)),
  //         nowCharmAndIncomeItem('总注册用户', roundToTwoDecimals(viewModel.messageAmount).toString()),
  //         Divider(height: 12.w,color: Color(0xFFEAEAEA)),
  //         nowCharmAndIncomeItem('昨日链接点击次数', roundToTwoDecimals(viewModel.giftAmount).toString()),
  //         Divider(height: 12.w,color: Color(0xFFEAEAEA)),
  //         nowCharmAndIncomeItem('链接总点击次数', roundToTwoDecimals(viewModel.voiceAmount).toString()),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget nowCharmAndIncomeItem(String title, String content){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(title,
  //           style:TextStyle(
  //               fontWeight: FontWeight.w700,
  //               color: Color(0xff444648),
  //               fontSize: 14.sp
  //           )),
  //       Text(content,
  //           style:TextStyle(
  //               fontWeight: FontWeight.w700,
  //               color: Color(0xff444648),
  //               fontSize: 14.sp
  //           )),
  //     ],
  //   );
  // }

  _buildDes(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
      alignment: Alignment.center,
      child: const Text('可生成链接，用于不同渠道推广并监控流量数据', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
    );
  }

  _twoItem({
    required String title1, required dynamic data1, required Color mainColor1, required String imgPath1,
    required String title2, required dynamic data2, required Color mainColor2, required String imgPath2,
  }) {
    return Row(
      children: [
        Expanded(child: PersonalAgentPromotionCell(title: title1, data: data1, mainColor: mainColor1, imgPath: imgPath1,)),
        SizedBox(width: WidgetValue.separateHeight),
        Expanded(child: PersonalAgentPromotionCell(title: title2, data: data2, mainColor: mainColor2, imgPath: imgPath2)),
      ],
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
}