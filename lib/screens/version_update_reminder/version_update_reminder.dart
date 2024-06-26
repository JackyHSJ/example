import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/gradient_text.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/theme/app_theme.dart';

class VersionUpdateReminder extends ConsumerStatefulWidget {
  final bool isForceUpdate;
  final String appVersion;
  final String? downloadLink;
  final String? updateDescription;
  const VersionUpdateReminder({super.key,required this.isForceUpdate,required this.appVersion,this.downloadLink,this.updateDescription});

  @override
  ConsumerState<VersionUpdateReminder> createState() => _VersionUpdateReminderState();
}

class _VersionUpdateReminderState extends ConsumerState<VersionUpdateReminder> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  bool checkTodayDoNotAlert = false;


  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: _appColorTheme.versionUpdateBackgroundColor,

            image: DecorationImage(
              image: AssetImage(_appImageTheme.versionUpdateBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child:WillPopScope(child: _contentWidget(), onWillPop: ()async {
          return !ModalRoute.of(context)!.canPop;
          },),
        ),
    );
  }

  Widget _contentWidget(){
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 420.h),
        child: Column(
          children: [
            _titleLabel(),
            _versionLabel(),
            _messageLabel(),
            _updateButton(),
            Visibility(visible:widget.isForceUpdate == false,child: _laterButton()),
            ///今日不再提醒，下次需求
            // _todayDoNotAlert()
          ],
        ),
      ),
    );
  }
  Widget _titleLabel(){
    return Text(
      "发现新版本",
      style: _appTextTheme.versionUpdateTitleTextStyle,
    );
  }
  Widget _versionLabel(){
    return Text(
      widget.appVersion,
      style: _appTextTheme.versionUpdateSubTitleTextStyle,
    );
  }
  Widget _messageLabel(){
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
      child:  SingleChildScrollView(
        scrollDirection: Axis.vertical,//.horizontal
        child: Text(
          widget.updateDescription ?? '新增功能，需要去更新哦~',
          style: _appTextTheme.versionUpdateMessageTextStyle,
        ),
      )
    );
  }
  Widget _updateButton() {
    double? radius = _appBoxDecorationTheme.versionUpdateNowBoxDecoration.borderRadius?.resolve(null).topRight.x;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.w),
      child: CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.custom,
        isEnabledTapLimitTimer: false,
        radius: radius,
        height: 46.h,
        text: '立即更新',
        textStyle: _appTextTheme.buttonPrimaryTextStyle,
        colorBegin: _appBoxDecorationTheme.versionUpdateNowBoxDecoration.gradient?.colors.first,
        colorEnd: _appBoxDecorationTheme.versionUpdateNowBoxDecoration.gradient?.colors.last,
        onTap: () async {
          final uri = Uri.parse(widget.downloadLink ?? '');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $widget.downloadLink';
          }
        },
      ),
    );
  }
  Widget _laterButton() {
    double? radius = _appBoxDecorationTheme.versionUpdateLaterBoxDecoration.borderRadius?.resolve(null).topRight.x;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.w),
      child: CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.custom,
        isEnabledTapLimitTimer: false,
        radius: radius,
        height: 46.h,
        text: '稍后再说',
        textStyle: _appTextTheme.versionUpdateLaterButtonTextStyle,
        colorBegin: _appBoxDecorationTheme.versionUpdateLaterBoxDecoration.color,
        colorEnd: _appBoxDecorationTheme.versionUpdateLaterBoxDecoration.color,
        onTap: () => BaseViewModel.popPage(context)
      ),
    );
  }

  Widget _todayDoNotAlert(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Icon((checkTodayDoNotAlert)?Icons.check_box_outline_blank:Icons.check_box, size: 16.w, color: _appColorTheme.switchActiveColor),
          onTap: (){
            setState(() {
              checkTodayDoNotAlert = !checkTodayDoNotAlert;
            });
          },
        ),
        Padding(padding: EdgeInsets.only(left: 2.w),child: Text('今天不再提醒',style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(102, 102, 102, 1),
          decorationColor:  Color.fromRGBO(102, 102, 102, 1),
        )))
      ],
    );
  }
}
