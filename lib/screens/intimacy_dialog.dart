import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

//亲密規則彈窗
class IntimacyDialog extends ConsumerStatefulWidget {
  final String? opponentAvatar;
  final num? cohesionPoints;
  final String? cohesionImagePath;
  final Map? pointsRuleMap;
  final num? nextLevelSubtract;
  final String? nextRelationShip;
  final int? nowIntimacy;
  final num? osType;

  const IntimacyDialog({
    super.key,
    this.opponentAvatar,
    this.cohesionPoints,
    this.cohesionImagePath,
    this.pointsRuleMap,
    this.nextLevelSubtract,
    this.nextRelationShip,
    this.nowIntimacy,
    this.osType,
  });

  @override
  _IntimacyDialogState createState() => _IntimacyDialogState();
}

class _IntimacyDialogState extends ConsumerState<IntimacyDialog> {
  int nowIntimacy = 1;
  Map pointsRuleMap = {};
  bool isLoading = true;
  late AppTheme _theme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppImageTheme appImageTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    appColorTheme = _theme.getAppColorTheme;
    appTextTheme = _theme.getAppTextTheme;
    appImageTheme = _theme.getAppImageTheme;
    if (memberInfo != null) {
      num opponentGender = 0;
      if (memberInfo.gender == 0) {
        opponentGender = 1;
      }
      return Stack(
        children: [
          Column(
            children: [
              Expanded(child: intimacyRuleContentWidget()),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 36.h),
                child: Center(
                    child: GestureDetector(
                  child: ImgUtil.buildFromImgPath(
                      appImageTheme.intimacyButtonCancel,
                      size: 36.w),
                  onTap: () {
                    BaseViewModel.popPage(context);
                  },
                )),
              ),
            ],
          ),
          Positioned(
              left: (MediaQuery.of(context).size.width / 2) - 48,
              top: 90,
              child: myAvatarWidget(memberInfo)),
          Positioned(
              left: (MediaQuery.of(context).size.width / 2),
              top: 90,
              child: oppositeAvatarWidget(widget.opponentAvatar, opponentGender,
                  widget.cohesionPoints ?? 0, widget.osType ?? 1)),
          Positioned(
              left: (MediaQuery.of(context).size.width / 2) - 14,
              top: 125,
              child: ImgUtil.buildFromImgPath(widget.cohesionImagePath!, size: 28),
          )
          // Image(image: image)
        ],
      );
    } else {
      return Container();
    }
  }

  //自己頭像
  Widget myAvatarWidget(WsMemberInfoRes memberInfo) {
    final num gender = memberInfo.gender ?? 0;
    final String avatar = memberInfo.avatarPath ?? '';

    return (avatar == '')
        ? AvatarUtil.defaultAvatar(gender, size: 48.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 48.w);
  }

  //對方頭像
  Widget oppositeAvatarWidget(String? opponentAvatar, num opponentGender,
      num cohesionPoints, num osType) {
    return Stack(
      children: [
        (opponentAvatar == '' || opponentAvatar == null)
            ? AvatarUtil.defaultAvatar(opponentGender, size: 48.w)
            : AvatarUtil.userAvatar(HttpSetting.baseImagePath + opponentAvatar,
                size: 48.w),
        Visibility(
            visible: cohesionPoints != 0 && opponentGender == 1 && osType == 0,
            child: _buildIosTag()),
      ],
    );
  }

  Widget _buildIosTag() {
    // http://redmine.zyg.com.tw/issues/1452
    // 女性用戶看到男性用戶時，如男性用戶當下使用裝置為iOS系統，
    // 則于亲密度等级的页面中會出現ios的文字角標供辨識
    return Positioned(
      top: 0,
      left: 0,
      child: ImgUtil.buildFromImgPath('assets/avatar/ios_tag.png',
          width: 22.w, height: 12.h),
    );
  }

  //亲密規則外框
  Widget intimacyRuleContentWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 550.h,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 116.h),
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(
            color: appColorTheme.intimacyRuleContentBorderColor,
            width: 1.0,
          ),
          gradient: appLinearGradientTheme.intimacyRuleContentBackGroundColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            currentlyIntimacyWidget(),
            Flexible(child: intimacyInformation())
          ],
        ),
      ),
    );
  }

  //當前亲密度狀況
  Widget currentlyIntimacyWidget() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 52.h),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: appColorTheme.intimacyWidgetBackGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        child: (widget.nowIntimacy == 8)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorTextWidget('您已达到', AppColors.textFormBlack),
                  colorTextWidget('最高亲密度', AppColors.mainPink),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    colorTextWidget('当前 ', appColorTheme.intimacyRuleContentTitleTextColor),
                    colorTextWidget(
                        double.parse(widget.cohesionPoints!.toStringAsFixed(1)).toString(),
                        appColorTheme.intimacyDialogCurrentIntimacyTextColor),
                    colorTextWidget(' 还差 ', appColorTheme.intimacyRuleContentTitleTextColor),
                    colorTextWidget(
                        double.parse(widget.nextLevelSubtract!.toStringAsFixed(1)).toString(),
                        appColorTheme.intimacyDialogDifferenceInIntimacyTextColor),
                    colorTextWidget(' 升级至', appColorTheme.intimacyRuleContentTitleTextColor),
                    colorTextWidget(
                        widget.nextRelationShip!, appColorTheme.intimacyDialogNextStageOfRelationshipTextColor),
                  ],
                ),
              ));
  }

  //顏色文字
  Widget colorTextWidget(String text, Color color) {
    return Material(
      type: MaterialType.transparency,
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 14.sp, fontWeight: FontWeight.w500)),
    );
  }

  //亲密值等級資訊
  Widget intimacyInformation() {
    return Container(
        height: MediaQuery.of(context).size.height - 350.h,
        margin: EdgeInsets.only(top: 12.h),
        decoration: BoxDecoration(
          color: appColorTheme.intimacyWidgetBackGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              titleWidget("亲密度等级资讯"),
              informationWidget(),
              titleWidget("亲密值升级攻略"),
              intimacyRaiders()
            ],
          ),
        ));
  }

  //大標題
  Widget titleWidget(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: 12.h,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 4.h),
            child: ImgUtil.buildFromImgPath('assets/images/icon_intimacy_heart.png', size: 28),
          ),
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              gradient: appLinearGradientTheme.intimacyDialogDividerColor,
            ),
          ),
          const SizedBox(height: 4),
          Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.only(top: 4.h),
              child: Text(title,
                  style: appTextTheme.intimacyDialogTitleTextStyle),
            ),
          )
        ],
      ),
    );
  }

  //資訊
  Widget informationWidget() {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          rowLabelWidget(
              false,
              true,
              "1",
              'assets/icons/icon_intimacy_level_1.png',
              "亲密度达到 ${widget.pointsRuleMap![1]} °C",
              '已获得【相识】标签',
              [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "2",
              'assets/icons/icon_intimacy_level_2.png',
              "亲密度达到 ${widget.pointsRuleMap![2]} °C",
              '解锁发图片、视频、语音通话权限',
              [Color(0xFF81B3E9), Color.fromRGBO(225, 237, 250, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "3",
              'assets/icons/icon_intimacy_level_3.png',
              "亲密度达到 ${widget.pointsRuleMap![3]} °C",
              '解锁与对方1分钟免费语音通话',
              [Color(0xFF61BC81), Color.fromRGBO(227, 244, 233, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "4",
              'assets/icons/icon_intimacy_level_4.png',
              "亲密度达到 ${widget.pointsRuleMap![4]} °C",
              '解锁与对方1分钟免费视频通话',
              [Color(0xFFF1B0B8), Color.fromRGBO(236, 153, 162, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "5",
              'assets/icons/icon_intimacy_level_5.png',
              "亲密度达到 ${widget.pointsRuleMap![5]} °C",
              '解锁对方一周每天1分钟免费语音通话时间',
              [Color(0xFFF2B0B8), Color.fromRGBO(174, 120, 237, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "6",
              'assets/icons/icon_intimacy_level_6.png',
              "亲密度达到 ${widget.pointsRuleMap![6]} °C",
              '解锁对方一周每天1分钟免费视频通话时间',
              [Color(0xFFDE858E), Color.fromRGBO(219, 120, 130, 0)]
          ),
          rowLabelWidget(
              true,
              true,
              "7",
              'assets/icons/icon_intimacy_level_7.png',
              "亲密度达到 ${widget.pointsRuleMap![7]} °C",
              '解锁对方一个月每天1分钟免费语音通话时间',
              [Color(0xFFCC1F18), Color.fromRGBO(176, 46, 37, 0)]
          ),
          rowLabelWidget(
              true,
              false,
              "8",
              'assets/icons/icon_intimacy_level_8.png',
              "亲密度达到 ${widget.pointsRuleMap![8]} °C",
              '解锁对方一个月每天1分钟免费视频通话时间',
              [Color(0xFFEAA850), Color.fromRGBO(242, 201, 141, 0)]
          ),
        ],
      ),
    );
  }

  //單行組件
  Widget rowLabelWidget(
    bool needShowTopLine, bool needShowBottomLine,
    String num, String imagePath, String content, String subContent,
    List<Color> intimacyLevelBgColor
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      height: 67,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          intimacySteps(needShowTopLine, needShowBottomLine, num),
          const SizedBox(width: 16),
          intimacyInfo(imagePath, content, subContent, num, intimacyLevelBgColor),
          const SizedBox(width: 4),
          intimacyCheck(num)
        ],
      ),
    );
  }

  Widget intimacySteps(bool needShowTopLine, bool needShowBottomLine, String num) {
    Color color = const Color.fromRGBO(217, 217, 217, 1);
    LinearGradient gradient = appLinearGradientTheme.intimacyStepsUnGetLinearGradient;
    if(int.parse(num) <= widget.nowIntimacy!){
      color = appColorTheme.intimacyStepsLineColor;
      gradient = appLinearGradientTheme.intimacyStepsColor;
    }
    return SizedBox(
      width: 27,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 1,
              height: 20.0,
              color: needShowTopLine
                  ? color
                  : Colors.transparent),
          Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: AppColors.mainPink,
                borderRadius: BorderRadius.circular(20.0),
                gradient: gradient,
              ),
              child: Center(
                child: Text(
                    textAlign: TextAlign.center,
                    num,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Color(0xFFFFFFFF),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    )),
              )),
          Container(
              width: 1,
              height: 20.0,
              color: needShowBottomLine
                  ? (int.parse(num) < widget.nowIntimacy!)?color:Color.fromRGBO(217, 217, 217, 1)
                  : Colors.transparent),
        ],
      ),
    );
  }

  Widget intimacyInfo(String imagePath, String content, String subContent, String intimacyLevel, List<Color> intimacyLevelBgColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _buildIntimacyLevelWidget(imagePath, intimacyLevel, intimacyLevelBgColor),
              Container(
                margin: EdgeInsets.only(left: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: appColorTheme.intimacyStepsTagBackGroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(48.0)),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    content,
                    style: appTextTheme.intimacyStepsTagTextStyle,
                  ),
                ),
              ),
            ],
          ),
          Material(
            type: MaterialType.transparency,
            child: Text(
              subContent,
              overflow: TextOverflow.ellipsis,
              style: appTextTheme.intimacyDialogItemSubTitleTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget intimacyCheck(String num) {
    Color color = appColorTheme.iconIntimacyLockColor;
    if(int.parse(num) <= widget.nowIntimacy!){
      color =  appColorTheme.iconIntimacyCheckColor;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: const Alignment(0, 0),
          child: Image(
            width: 24,
            height: 24,
            color: color,
            image: (int.parse(num) <= widget.nowIntimacy!)
                ? const AssetImage("assets/images/icon_intimacy_check.png")
                : const AssetImage("assets/images/icon_intimacy_lock.png"),
          ),
        )
      ],
    );
  }

  //亲密值攻略
  Widget intimacyRaiders() {
    return Column(
      children: [
        intimacyRaidersContent(
            "1", '在你们私信聊天中，每产生消耗金币的行为即可增加亲密度（消息、私聊送礼、音视频通话都包括在内', false),
        intimacyRaidersContent("2", '1亲密度 = 1金币，不同等级可解锁不同的特权奖励', false),
        intimacyRaidersContent("3", '奖励最终解释权归${AppConfig.appName}所有', true),
      ],
    );
  }

  //亲密直攻略單行組件
  Widget intimacyRaidersContent(String num, String content, bool isEnd) {
    return Container(
      margin: EdgeInsets.only(
          left: 16.w, top: (isEnd) ? 12.h : 24.h, bottom: (isEnd) ? 12.h : 0),
      child: Row(
        children: [
          Container(
            alignment: const Alignment(0, 0),
            width: 27,
            height: 27,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: appColorTheme.intimacyStepsLineColor, width: 1)),
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                num,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: appColorTheme.intimacyStepsLineColor),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            width: 224.w,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                content,
                style: appTextTheme.intimacyStrategyTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIntimacyLevelWidget(String iconPath, String intimacyLevel, List<Color> intimacyLevelBgColor) {
    String cohesionName = '';
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    List<IntimacyLevelInfo?> levelInfo = intimacyLevelInfo.list!.where((item) => item.cohesionLevel == int.parse(intimacyLevel)).toList();

    if (levelInfo.isNotEmpty) {
      cohesionName = levelInfo.first?.cohesionName ?? '';
    } else {
      cohesionName = '';
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 6, left: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: intimacyLevelBgColor,
              stops: const [0.3265, 0.7491],
              transform: const GradientRotation(269.71),
            ),
          ),
          // width: nameWidth,
          height: 16,
          child: Material(
            type: MaterialType.transparency,
            child: Text('$cohesionName',
              style: const TextStyle(color: Color(0xffFFFFFF), fontSize: 10, fontWeight: FontWeight.w500, height: 0.1),
            ),
          ),
        ),
        Positioned(
          top: -6,
          left: 0,
          child: ImgUtil.buildFromImgPath(iconPath, size: 28),
        )
      ],
    );
  }
}
