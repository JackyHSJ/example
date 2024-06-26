
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/profile/setting/charm/personal_setting_charm_view_model.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_charm_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../../system/util/date_format_util.dart';
import '../../../../widgets/profile/cell/personal_setting_charm_cell.dart';
import '../../../../widgets/shared/progress.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class PersonalSettingCharm extends ConsumerStatefulWidget {
  const PersonalSettingCharm({super.key});

  @override
  ConsumerState<PersonalSettingCharm> createState() => _PersonalSettingCharmState();
}

class _PersonalSettingCharmState extends ConsumerState<PersonalSettingCharm> {
  late PersonalSettingCharmViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalSettingCharmViewModel(ref: ref, setState: setState);
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
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    return Scaffold(
      backgroundColor: _appColorTheme.baseBackgroundColor,
      appBar: MainAppBar(theme:_theme,title: '魅力等级', leading: SizedBox(), actions: [_buildCancelBtn()],),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Consumer(builder: (context, ref, _){
                final WsSettingCharmAchievementRes? charmAchievement = ref.watch(userInfoProvider).charmAchievement;
                viewModel.setPercent(charmAchievement);
                return Column(
                  children: [
                    _buildUserImg(),
                    SizedBox(height: WidgetValue.verticalPadding),
                    _buildUserName(),
                    SizedBox(height: WidgetValue.verticalPadding),
                    _buildCharmNum(charmAchievement),
                    SizedBox(height: WidgetValue.verticalPadding),
                    _buildLevelUpNum(charmAchievement),
                    _buildLevelUpProgress(charmAchievement),
                    _buildBenefitAndCharm(charmAchievement),
                    SizedBox(height: WidgetValue.verticalPadding),
                    _buildCharmIntro(),
                    _buildCharmTable(charmAchievement),
                  ],
                );
              }),
            )
        ),
      ),
    );
  }



  _buildCancelBtn() {
    return InkWell(
      onTap: () => BaseViewModel.popPage(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        child: Image(
          width: 24.w,
          height: 24.w,
          image: AssetImage(_appImageTheme.iconClose),
        ),
      ),
    );
  }

  _buildUserImg() {
    final String? avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath;
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return (avatarPath == null)
        ? AvatarUtil.defaultAvatar(gender, size: 72.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 72.w);
  }

  _buildUserName(){
    final nickName = ref.read(userInfoProvider).nickName;
    final userName = ref.read(userInfoProvider).userName;
    final name = (nickName != null && nickName.isNotEmpty) ? nickName : userName;
    return Text('$name', style: _appTextTheme.charmLevelTitleTextStyle);
  }

  _buildCharmNum(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final currentLevel = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final isMaxLevel = viewModel.isMaxLevel(charmAchievementInfo);
    final targetLevel = isMaxLevel ? currentLevel : currentLevel + 1;
    final currentPoint = charmAchievementInfo?.personalCharm?.charmPoints ?? 0;
    final nextLevelInfo = charmAchievementInfo?.list?.firstWhere((item) => item.charmLevel == '$targetLevel');
    final nextLevelCondition = nextLevelInfo?.levelCondition?.split('|');
    final nextLevelTargetPoint = nextLevelCondition?[1];
    final displayScore = isMaxLevel ? '$nextLevelTargetPoint / $nextLevelTargetPoint' : '$currentPoint / $nextLevelTargetPoint';


    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          color: _appColorTheme.charmLevelTagBackgroundColor,
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(displayScore, style:  _appTextTheme.charmLevelTagTextStyle)],
      ),
    );
  }

  _buildLevelUpNum(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final currentLevel = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final isMaxLevel = viewModel.isMaxLevel(charmAchievementInfo);
    final targetLevel = isMaxLevel ? currentLevel : currentLevel + 1;
    final currentPoints = charmAchievementInfo?.personalCharm?.charmPoints ?? 0;
    final nextLevelInfo = charmAchievementInfo?.list?.firstWhere((item) => item.charmLevel == '$targetLevel');
    final nextLevelCondition = nextLevelInfo?.levelCondition?.split('|');
    final int nextLevelTargetPoint = int.parse(nextLevelCondition![1]);
    final pointLeft = nextLevelTargetPoint - currentPoints;
    final displayText = isMaxLevel
        ? '目前已达最高等级'
        : pointLeft < 0
          ? '再完成一次互动即可升级'
          : '升级 Lv.$targetLevel 还需 ${pointLeft.toStringAsFixed(2)} 积分';




    return Text(displayText, style: _appTextTheme.labelPrimaryTitleTextStyle);
  }

  _buildLevelUpProgress(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final isMaxLevel = viewModel.isMaxLevel(charmAchievementInfo);
    final level = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final currentLevel = isMaxLevel ? level - 1 : level;
    final targetLevel = isMaxLevel ? level : level + 1;
    final percent = viewModel.percent;


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Lv.$currentLevel', style: _appTextTheme.charmLevelTitleTextStyle),
        SizedBox(width: WidgetValue.horizontalPadding,),
        ProgressIndicatorWidget(beginPercent: percent),
        SizedBox(width: WidgetValue.horizontalPadding,),
        Text('Lv.$targetLevel', style: _appTextTheme.charmLevelTitleTextStyle)
      ],
    );
  }

  _buildBenefitAndCharm(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final point = charmAchievementInfo?.personalCharm?.charmPoints ?? 0;
    final charmLevel = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final isMaxLevel = viewModel.isMaxLevel(charmAchievementInfo);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
          // child: Row(
          //   children: [
          //     Expanded(child: PersonalSettingCharmCell(
          //       title: '当前魅力',
          //       numData: 'Lv.$charmLevel',
          //       mainColor: AppColors.mainPink,
          //       imgPath: 'assets/profile/profile_charm_icon_1.png',
          //       imageOpacity: 0.3,
          //     )),
          //     SizedBox(width: WidgetValue.horizontalPadding,),
          //     Expanded(child: PersonalSettingCharmCell(
          //       title: '当前收益（积分）',
          //       numData: '$point',
          //       mainColor: AppColors.mainOrange,
          //       imgPath: 'assets/profile/profile_charm_icon_2.png',
          //       imageOpacity: 0.3,
          //     )),
          //   ],
          // ),
          child: nowCharmAndIncome(charmLevel,point)
        ),
        // Visibility(
        //     visible: !isMaxLevel,
        //     child: SizedBox(
        //       width: UIDefine.getWidth(),
        //       child: PersonalSettingCharmCell(
        //         title: '倒数',
        //         numData: viewModel.displayTime,
        //         stackAlignment: Alignment.center,
        //         des: '统计收益流水，达标后升级',
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //       ),
        //     ),
        // )
      ],
    );
  }

  Widget nowCharmAndIncome(num charmLevel,num point){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.all(Radius.circular(12.0)),
      //   border: Border.all(width: 1, color: Color(0xFFEAEAEA)),
      // ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('当前魅力','Lv$charmLevel'),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('当前收益（积分）',point.toString())
        ],
      ),
    );
  }

  Widget nowCharmAndIncomeItem(String title, String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style:_appTextTheme.labelPrimarySubtitleTextStyle),
        Text(content, style:_appTextTheme.labelPrimarySubtitleTextStyle),
      ],
    );
  }

  _buildCharmIntro(){
    return  Center(
      child: Text('魅力值积分(Lv.)与最高价格(金币)设置',style: _appTextTheme.charmLevelSubtitleTextStyle,));
  }

  _buildCharmTable(WsSettingCharmAchievementRes? charmAchievementInfo){
    TextStyle titleTextStyle =  _appTextTheme.charmLevelTableTitleTextStyle;
    TextStyle contentTextStyle = _appTextTheme.charmLevelTableContentTextStyle;

    final list = charmAchievementInfo?.list ?? [];

    TableRow _tableTitleRow =   TableRow(
        decoration: BoxDecoration(color: _appColorTheme.charmLevelTableTitleBackgroundColor),
        children: [
          _TableTitle(content: "魅力值", styledText: titleTextStyle),
          _TableTitle(content: "升级条件", styledText: titleTextStyle),
          _TableTitle(content: "最高消息\n价格设置", styledText: titleTextStyle),
          _TableTitle(content: "最高语音\n价格设置", styledText: titleTextStyle),
          _TableTitle(content: "最高视频\n价格设置", styledText: titleTextStyle),
        ]
    );

    List<TableRow> _tableRows = List.generate(list.length, (index) {
      // final levelConditionDay = list[index].levelCondition?.split('|')[0];
      final levelConditionPoint = list[index].levelCondition?.split('|')[1];
      final level = index + 1;
      return TableRow(
        children: [
          _TableRow(appTheme:_theme,content: "Lv.$level", styledText: titleTextStyle, firstColumn: true, lastRow: false),
          _TableRow(appTheme:_theme,content: "≥$levelConditionPoint积分", styledText: contentTextStyle, lastRow: false),
          _TableRow(appTheme:_theme,content: list[index].messageCharge.toString(), styledText: contentTextStyle, lastRow: false),
          _TableRow(appTheme:_theme,content: list[index].voiceCharge.toString(), styledText: contentTextStyle, lastRow: false),
          _TableRow(appTheme:_theme,content: list[index].streamCharge.toString(), styledText: contentTextStyle, lastRow: false),
        ],
      );
    });

    return Container(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(width: 1.0, color: _appColorTheme.charmLevelTableLineColor),
                verticalInside: BorderSide(width: 1.0, color: _appColorTheme.charmLevelTableLineColor),
              ),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
                4: IntrinsicColumnWidth(),
              },
              children: <TableRow>[_tableTitleRow, ..._tableRows],
            ),
          ),
        )
    );
  }
}

class _TableTitle extends StatelessWidget {
  const _TableTitle({required this.content, required this.styledText});

  final String content;
  final TextStyle styledText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(content,style: styledText, textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.appTheme, required this.content, required this.styledText, this.firstColumn, this.lastRow});
  final AppTheme appTheme;
  final String content;
  final TextStyle styledText;
  final bool? firstColumn;
  final bool? lastRow;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (lastRow == true)
          ? const Color(0xFFFF9A7A)
          : (firstColumn == true)
            ? appTheme.getAppColorTheme.charmLevelTableTitleBackgroundColor
            : appTheme.getAppColorTheme.charmLevelTableBackgroundColor,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(content, style: styledText, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
