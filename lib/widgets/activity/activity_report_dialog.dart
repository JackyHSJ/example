import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/activity/activity_report_dialog_view_model.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../shared/list/grid_list.dart';

class ActivityReportDialog extends ConsumerStatefulWidget {
  final Function onTap;
  final String title;

  const ActivityReportDialog({
    super.key,
    required this.onTap,
    required this.title
  });

  @override
  ConsumerState<ActivityReportDialog> createState() => _ActivityReportDialogState();

}

class _ActivityReportDialogState extends ConsumerState<ActivityReportDialog> {
  late ActivityReportDialogViewModel viewModel;

  // 詳細描述及其他
  final TextEditingController _reportTextController = TextEditingController();


  int? _reportTextCount = 0;

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppImageTheme _appImageTheme;

  void _onTapSubmitButton(){
    if (viewModel.currentReportItem == null) return;
    widget.onTap(viewModel.currentReportItem, _reportTextController.text);
  }

  void _onTapReportTypeButton(ReportListInfo reportListInfo) {
    viewModel.currentReportItem = reportListInfo;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    viewModel = ActivityReportDialogViewModel(ref: ref, context: context, setState: setState);
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appImageTheme = _theme.getAppImageTheme;


    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildContent(),
            _buildActionButtons(),
          ],
        ),
      ),
    );

  }

  Widget _buildTitle(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget.title}",
          textAlign: TextAlign.center,
          style:  _appTextTheme.labelPrimaryTitleTextStyle,
        ),
        SizedBox(height: 4.h),
        Text(
          '请至少选择一项举报原因',
          textAlign: TextAlign.center,
          style:_appTextTheme.labelPrimaryTextStyle,
        ),
      ],
    );
  }

  Widget _buildContent(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(flex: 3,child: _reportTypeGridList()),
          SizedBox(height: 12.h,),
          Flexible(flex: 7,child: _detailTextField()),
        ],
      ),
    );
  }

  Widget _reportTypeGridList(){

    return SingleChildScrollView(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        children: List.generate(viewModel.reportList.length, (index) {
          return _reportTypeButton(viewModel.reportList[index]!);
        }),
      ),
    );
  }

  Widget _reportTypeButton(ReportListInfo reportListInfo) {

    bool isSelect = viewModel.currentReportItem == reportListInfo;
    TextStyle textStyle = _appTextTheme.activityReportTagUnselectedButtonTextStyle;
    Color colorBegin = _appLinearGradientTheme.activityReportTagUnselectedButtonColor.colors[0];
    Color colorEnd = _appLinearGradientTheme.activityReportTagUnselectedButtonColor.colors[1];
    // bool isSelect = _currentReportTypeItemList.any((element) => element.id == reportListInfo.id);
    if (isSelect) {
      textStyle = _appTextTheme.activityReportTagSelectedButtonTextStyle;
      colorBegin =_appLinearGradientTheme.activityReportTagSelectedButtonColor.colors[0];
      colorEnd =_appLinearGradientTheme.activityReportTagSelectedButtonColor.colors[01];
    }

    return FittedBox(
      child: CommonButton(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        height: 28.h,
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        colorBegin: colorBegin,
        colorEnd: colorEnd,
        text: reportListInfo.reason,
        textStyle: textStyle,
        isEnabledTapLimitTimer: false,
        onTap: () => _onTapReportTypeButton(reportListInfo),
      ),
    );
  }

  Widget _detailTextField() {
    String reportCountText='$_reportTextCount/50';
    return Stack(
      children: [
        MainTextField(
          textFieldHeight: 100.h,
          controller: _reportTextController,
          hintText: '详细描述及其他...',
          fontSize: 12.sp,
          fontColor: _appColorTheme.textFieldFontColor,
          backgroundColor: _appColorTheme.textFieldBackgroundColor,
          borderColor:_appColorTheme.textFieldBorderColor ,
          radius: 10,
          enableMultiLines: true,
          maxLength: 50,
          onChanged: (text) {
            _reportTextCount = text.length;
            setState(() {});
          },
        ),
        Positioned(
          bottom: 10.h,
          right: 12.w,
          child: Text(
            reportCountText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromRGBO(189, 188, 189, 1),
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _cancelButton()),
        SizedBox(width: 12.w),
        Expanded(child: _submitButton()),
      ],
    );
  }

  Widget _cancelButton(){
    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      radius: 12.h,
      height: 48.h,
      colorBegin: _appLinearGradientTheme.dialogCancelButtonColor.colors[0],
      colorEnd: _appLinearGradientTheme.dialogCancelButtonColor.colors[1],
      text: '取消',
      textStyle:_appTextTheme.dialogCancelButtonTextStyle,
      isEnabledTapLimitTimer: false,
      onTap: () => BaseViewModel.popPage(context),
    );
  }

  Widget _submitButton(){
    TextStyle textStyle = _appTextTheme.dialogConfirmButtonTextStyle;
    Color colorBegin =   _appLinearGradientTheme.dialogConfirmButtonColor.colors[0];
    Color colorEnd =   _appLinearGradientTheme.dialogConfirmButtonColor.colors[1];

    if (viewModel.currentReportItem == null) {
      textStyle = _appTextTheme.dialogDisableButtonTextStyle;
      colorBegin = _appLinearGradientTheme.dialogDisabledButtonColor.colors[0];
      colorEnd = _appLinearGradientTheme.dialogDisabledButtonColor.colors[0];
    }

    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      radius: 12.h,
      height: 48.h,
      colorBegin: colorBegin,
      colorEnd: colorEnd,
      text: '送出举报',
      textStyle: textStyle,
      isEnabledTapLimitTimer: false,
      onTap: () => _onTapSubmitButton(),
    );
  }
}


class ReportTypeItem {
  final int? id;
  final String? title;

  ReportTypeItem({
    this.id,
    this.title,
  });
}
