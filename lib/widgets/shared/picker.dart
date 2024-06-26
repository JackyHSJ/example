
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class Picker {
  static void showDatePicker(BuildContext context, {
    AppTheme? appTheme ,
    String selectTitle = '确定',
    String cancelTitle = '取消',
    required Function(DateTime) onSelect,
    required Function() onCancel,
    DateTime? initialDateTime,
    int? minimumYear,
    int? maximumYear,
    DateTime? minimumDate,
    DateTime? maximumDate,
    TextStyle? cancelTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? dateTimePickerTextStyle,
    Color? pickerDialogBackgroundColor,
  }) {
    DateTime selectDate = initialDateTime!;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: UIDefine.getHeight() / 3,
            color: (appTheme !=null)?appTheme.getAppColorTheme.pickerDialogBackgroundColor:pickerDialogBackgroundColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(cancelTitle, style: (appTheme!=null)?appTheme.getAppTextTheme.pickerDialogCancelButtonTextStyle:cancelTextStyle),
                      onPressed: () => Navigator.of(context).pop(),

                    ),
                    CupertinoButton(
                    child: Text(selectTitle, style: (appTheme!=null)?appTheme.getAppTextTheme.pickerDialogConfirmButtonTextStyle:confirmTextStyle),
                      onPressed: () {
                        onSelect(selectDate);
                      },
                    ),
                  ],
                ),
                Expanded(
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: (appTheme !=null)?appTheme.getAppTextTheme.pickerDialogContentTextStyle:dateTimePickerTextStyle,
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime dateTime) {
                          selectDate = dateTime;
                        },
                        initialDateTime: initialDateTime ?? DateTime.now(),
                        minimumYear: minimumYear ?? 1900,
                        maximumYear: maximumYear ?? DateTime.now().year,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        backgroundColor: (appTheme != null)?appTheme.getAppColorTheme.pickerDialogBackgroundColor:pickerDialogBackgroundColor,
                      ),
                    ),
                ),
              ],
            ),
          );
        });
  }

  static Future<void> iconDataPicker(BuildContext context, {
    AppTheme? appTheme ,
    required int length,
    // required int index,
    required int defaultIndex,
    required FixedExtentScrollController fixedExtentScrollController,
    String selectTitle = '确定',
    String cancelTitle = '取消',
    required Function(int) onSelect,
    required Function() onCancel,

    required Widget? Function(BuildContext, int) itemBuilder
  }) async {
    int selectIndex = defaultIndex;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        const double _kItemExtent = 32.0;
        return Container(
          height: UIDefine.getHeight() / 3,
          color: (appTheme != null)?appTheme.getAppColorTheme.pickerDialogBackgroundColor:Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(cancelTitle, style: (appTheme!=null)?appTheme.getAppTextTheme.pickerDialogCancelButtonTextStyle:const TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text(selectTitle, style: (appTheme!=null)?appTheme.getAppTextTheme.pickerDialogConfirmButtonTextStyle:const TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
                    onPressed: () {
                      onSelect(selectIndex);
                    },
                  ),
                ],
              ),
              // 2. 原来的CupertinoPicker
              Expanded(
                child: CupertinoPicker.builder(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: _kItemExtent,
                  childCount: length,
                  itemBuilder: itemBuilder,
                  scrollController: fixedExtentScrollController,
                  onSelectedItemChanged: (index) => selectIndex = index,
                  backgroundColor: (appTheme != null)?appTheme.getAppColorTheme.pickerDialogBackgroundColor:Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
