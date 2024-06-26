
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/profile/personal_greet_tag_model.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/screens/profile/greet/add/personal_greet_add.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/extension/duration.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalGreetCell extends ConsumerStatefulWidget {
  PersonalGreetCell({super.key, required this.moduleNameList, required this.model, required this.randomColor});
  List<GreetModuleInfo> moduleNameList;
  GreetModuleInfo model;
  Color randomColor;
  @override
  ConsumerState<PersonalGreetCell> createState() => _PersonalGreetCellState();
}

class _PersonalGreetCellState extends ConsumerState<PersonalGreetCell> {
  GreetModuleInfo get model => widget.model;
  Duration? recordTime;
  List<PersonalGreetTagModel> wrapList = [];
  List<GreetModuleInfo> get moduleNameList => widget.moduleNameList;
  Color get randomColor => widget.randomColor;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  @override
  void initState() {
    _getRecordTime();
    AudioUtils.init();
    super.initState();
  }

  _getRecordTime() async {
    if(model.greetingAudio?.length != null){
      num second = model.greetingAudio?.length ?? 0;
      recordTime = Duration(milliseconds:second.toInt());
    }else{
      recordTime = await AudioUtils.getAudioTime(audioUrl: model.greetingAudio?.filePath ?? '', addBaseImagePath: true);
    }
    if(mounted) {
      setState(() {});
    }
  }

  _getTagWrapList() {
    wrapList.add(PersonalGreetTagModel(imgPath: _appImageTheme.iconPersonalGreetPin, title: model.modelName ?? '',
        boxDecoration: _appBoxDecorationTheme.personalGreetModelNameTagBoxDecoration, textStyle: _appTextTheme.personalGreetModelNameTagTextStyle));

    /// status
    final CertificationType type = CertificationModel.getGreetType(authNum: model.status ?? 0);
    final String title = CertificationModel.toGreetTitle(authNum: model.status ?? 0);
    switch (type) {
      case CertificationType.unUse:
        break;
      case CertificationType.using:
        wrapList.add(PersonalGreetTagModel(imgPath: _appImageTheme.iconPersonalGreetUse, title: title,
            boxDecoration: _appBoxDecorationTheme.personalGreetModelUseTagBoxDecoration, textStyle: _appTextTheme.personalGreetModelUseTagTextStyle));
        break;
      case CertificationType.processing:
        wrapList.add(PersonalGreetTagModel(imgPath: _appImageTheme.iconPersonalGreetReview, title: title,
            boxDecoration: _appBoxDecorationTheme.personalGreetModelReviewTagBoxDecoration, textStyle: _appTextTheme.personalGreetModelReviewTagTextStyle));
        break;
      case CertificationType.fail:
        wrapList.add(PersonalGreetTagModel(imgPath: _appImageTheme.iconPersonalGreetReviewFail, title: title,
            boxDecoration: _appBoxDecorationTheme.personalGreetModelReviewTagBoxDecoration,textStyle: _appTextTheme.personalGreetModelReviewFailTagTextStyle));
        break;
      default:
        break;
    }

    /// edit
    /// 審核中剔除無法編輯
    if(type == CertificationType.processing || type == CertificationType.using) {
      return ;
    }

    wrapList.add(PersonalGreetTagModel(imgPath:_appImageTheme.iconPersonalGreetEdit, title: '編輯',
        boxDecoration: _appBoxDecorationTheme.personalGreetModelEditTagBoxDecoration, textStyle: _appTextTheme.personalGreetModelEditTagTextStyle, needBoard: true
    ));
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImg(),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTagBtn(),
              _buildDes(),
              _buildSoundPlayer()
            ],
          ))
        ],
      ),
    );
  }

  _buildImg() {
    final greetImgUrl = model.greetingPic;
    return (greetImgUrl == null) ? _buildEmptyGreetImg() : _buildNetworkGreetImg(greetImgUrl);
  }

  _buildEmptyGreetImg() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      height: WidgetValue.userBigImg,
      width: WidgetValue.userBigImg,
      decoration: BoxDecoration(
        color: AppColors.mainGrey,
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
      ),
    );
  }

  _buildNetworkGreetImg(String greetImgUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      height: WidgetValue.userBigImg,
      width: WidgetValue.userBigImg,
      decoration: BoxDecoration(
        color: AppColors.mainGrey,
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
      ),
      child: CachedNetworkImageUtil.load(HttpSetting.baseImagePath + greetImgUrl, radius: WidgetValue.btnRadius / 2),
    );
  }
  // BaseViewModel.pushPage(context, PersonalGreetAdd(moduleNameList: moduleNameList, model: model, type: GreetType.update))
  _buildTagBtn() {
    _getTagWrapList();

    return MainWrap().wrap(
      children: wrapList.map((tag) {
        return InkWell(
          onTap: () {
            final CertificationType type = CertificationModel.getGreetType(authNum: model.status ?? 0);

            if (type == CertificationType.processing) {
              return;
            }

            /// 暫時移除
            if(type == CertificationType.using) {
              final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

              CommDialog(context).build(
                theme: theme,
                title: '编辑使用中模板',
                contentDes: '因该模板尚在使用中，为避免审核过程影响，是否协助您复制该模板内容并新建进行编辑？',
                leftBtnTitle: '取消',
                rightBtnTitle: '复制',
                leftAction: () {
                  BaseViewModel.popPage(context);
                },
                rightAction: () {
                  BaseViewModel.popPage(context);
                  BaseViewModel.pushPage(context, PersonalGreetAdd(
                      moduleNameList: moduleNameList, model: model,
                      type: GreetType.update
                  ));
                }
              );
              return;
            }
            BaseViewModel.pushPage(context, PersonalGreetAdd(moduleNameList: moduleNameList, model: model, type: GreetType.update));
          },
          child: _buildHint(
              imgPath: tag.imgPath, title: tag.title,
              boxDecoration: tag.boxDecoration, textStyle: tag.textStyle,
              needOpacity: tag.needOpacity ?? false, needBoard: tag.needBoard ?? false
          ),
        );
      }).toList()
    );
  }

  _buildDes() {
    return Offstage(
      offstage: model.greetingText == null,
      child: Text(model.greetingText ?? '',style: _appTextTheme.labelPrimaryContentTextStyle,),
    );
  }

  Widget _buildHint({
    required String imgPath,
    required String title,
    required BoxDecoration boxDecoration,
    required bool needOpacity,
    required bool needBoard,
    required TextStyle? textStyle
  }) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 6, top: 1, bottom: 1),
      decoration: boxDecoration,
      // decoration: BoxDecoration(
      //   color: needOpacity ? color.withOpacity(0.2) : color,
      //   borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
      //   border: needBoard ? Border.all(width: 1, color: AppColors.textBlack) : null
      // ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImgUtil.buildFromImgPath(imgPath, size: 14),
          SizedBox(width: 2),
          Text(title, style: textStyle)
        ],
      ),
    );
  }

  _buildSoundPlayer() {
    final String timeFormat = recordTime?.toFormat() ?? '0:00';
    return Visibility(
      visible: recordTime != null,
      child: Row(
        children: [
          Icon(Icons.play_circle_fill_outlined, color: _appColorTheme.personalGreetModelPlayButtonColor),
          SizedBox(width: WidgetValue.separateHeight,),
          Expanded(child: Image.asset(_appImageTheme.imagePersonalGreetVoice)),
          SizedBox(width: WidgetValue.separateHeight,),
          Text(timeFormat,style: _appTextTheme.labelPrimaryContentTextStyle,),
          SizedBox(width: WidgetValue.horizontalPadding * 5,),
        ],
      ),
    );
  }
}