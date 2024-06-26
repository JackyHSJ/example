import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/bottom_sheet/base_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class CommonBottomSheet extends ConsumerStatefulWidget {

  static void show(BuildContext context, {

    required List<Widget> actions,
    String title = '',
    String message = '',
    Widget? cancelButton,
    bool? isHideDivider,
  }) {
    BaseBottomSheet.showBottomSheet(
      context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      widget: CommonBottomSheet(
        isHideDivider: isHideDivider,
        title: title,
        message: message,
        actions: actions,
        cancelButton: cancelButton,
      ),
    );
  }


  final List<Widget> actions;
  final String title;
  final String message;
  final Widget? cancelButton;
  final bool? isHideDivider;

  const CommonBottomSheet({
    super.key,
    required this.actions,
    this.title = '',
    this.message = '',
    this.cancelButton,
    this.isHideDivider,
  });

  @override
  ConsumerState<CommonBottomSheet> createState() => _CommonBottomSheetState();
}

class _CommonBottomSheetState extends ConsumerState<CommonBottomSheet> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;

  @override
  Widget build(BuildContext context){
  _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
  _appColorTheme = _theme.getAppColorTheme;
  _appTextTheme = _theme.getAppTextTheme;
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _contentWidget(),
          _cancelButton(),
        ],
      ),
    );
  }

  Widget _contentWidget(){
    return Container(
      decoration:  BoxDecoration(
        color: _appColorTheme.commonButtonContentBackGroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(visible:widget.title.isNotEmpty,child: _titleLabel()),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _titleLabel(){
    return Column(
      children: [
        CommonBottomSheetAction(
            isEnabled: false,
            height: widget.message.isNotEmpty ? 61.h:40.h,
            title: widget.title,
            titleStyle: const TextStyle(fontSize: 12, color: Color.fromRGBO(120,120,120,1), fontWeight: FontWeight.w400),
            subtitle: widget.message,
            subtitleStyle: const TextStyle(fontSize: 10, color: Color.fromRGBO(160,160,160,1), fontWeight: FontWeight.w400),
            onTap: () {}),
        Visibility(visible: widget.isHideDivider != false, child: _divider()),
      ],
    );
  }

  Widget _actionButtons(){

    List<Widget> list = [];
    for(Widget item in widget.actions){
      list.add(item);
      if(item != widget.actions.last && widget.isHideDivider != true){
        list.add(_divider());
      }
    }
    return Column(children: list);
  }

  Widget _cancelButton(){
    if(widget.cancelButton !=null){
      return widget.cancelButton!;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: _appColorTheme.commonButtonCancelBackGroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: CommonBottomSheetAction(
        title: '取消',
        titleStyle: _appTextTheme.commonButtonCancelTextStyle,
        onTap: () {
          BaseViewModel.popPage(context);
        },
      ),
    );
  }

  Widget _divider(){
    return const Divider(height: 0.1,indent: 0.0,color: Color.fromRGBO(100,100,100,0.36));
  }
}


class CommonBottomSheetAction extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final Widget? leadingWidget;
  final VoidCallback onTap;
  final double? height;
  final bool? isEnabled;

  const CommonBottomSheetAction({
    super.key,
    required this.title,
    required this.onTap,
    this.titleStyle,
    this.subtitle ='',
    this.subtitleStyle,
    this.leadingWidget,
    this.height,
    this.isEnabled = true,
  });

  @override
  State<CommonBottomSheetAction> createState() => _CommonBottomSheetActionState();
}

class _CommonBottomSheetActionState extends State<CommonBottomSheetAction> {


  final TextStyle _defaultTitleTextStyle = const TextStyle(fontSize: 16, color: Color(0xFF007AFF), fontWeight: FontWeight.w400);
  final TextStyle _defaultSubtitleTextStyle = const TextStyle(fontSize: 10, color: Color(0xFF007AFF), fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {

    return  CommonButton(
        btnType: CommonButtonType.layout,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        isEnabled: widget.isEnabled,
        height: widget.height ?? 61.h,
        colorBegin: Colors.transparent,
        colorEnd: Colors.transparent,
        layoutTitle: Row(
          children: [
            widget.leadingWidget??Container(),
            Text(widget.title, style: widget.titleStyle ??_defaultTitleTextStyle,),
          ],
        ),
        layoutBottom: Visibility(
          visible: widget.subtitle.isNotEmpty,
          child: Text(widget.subtitle ?? '', style: widget.subtitleStyle ??_defaultSubtitleTextStyle),
        ),
        onTap: widget.onTap);
  }
}
