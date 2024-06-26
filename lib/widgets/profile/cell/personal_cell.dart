import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/profile/personal_cell_model.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/extension/duration.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/profile/cell/personal_edit_album_cell.dart';
import 'package:frechat/widgets/profile/cell/personal_edit_img_cell.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/grid_list.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../constant_value.dart';
import '../../theme/original/app_colors.dart';
class PersonalCell extends ConsumerStatefulWidget {

  final PersonalEditViewModel? viewModel;
  final PersonalCellModel model;
  final List<Widget>? desList;
  final PersonalCellType type;
  final Function(dynamic)? onReturnMsg;

  const PersonalCell({
    super.key,
    this.viewModel,
    required this.model,
    this.desList,
    this.type = PersonalCellType.normal,
    this.onReturnMsg
  });

  @override
  ConsumerState<PersonalCell> createState() => _PersonalCellState();
}

class _PersonalCellState extends ConsumerState<PersonalCell> {

  PersonalCellModel get model => widget.model;
  List<Widget>? get desList => widget.desList;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _linearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppImageTheme _appImageTheme;



  String selectAge = '';
  List<String> ageData = [];
  String selectHomeTown = '';
  Map<String, List<String>> homeTownData = {'':['']};
  String selectHeight = '';
  List<String> heightData = [];
  String selectWeight = '';
  List<String> weightData = [];
  String selectJob = '';
  Map<String, List<String>> jobData = {'':['']};
  String selectAnnualIncome = '';
  List<String> annualIncomeData = [];
  String selectEducationalBackground = '';
  List<String> educationalBackgroundData = [];
  String selectMaritalStatus = '';
  List<String> maritalStatusData = [];
  String intro = '';
  List<String> myTagList = [];
  Duration? audioTime;
  Duration? initialAudioTime; // 保存最初的音频时长
  Timer? countdownTimer;
  bool isLoadingAudio = true;


  PickerStyle _getPickerStyle(){
    return PickerStyle(
      backgroundColor: _appColorTheme.pickerDialogBackgroundColor,
      title: Container(color: _appColorTheme.pickerDialogBackgroundColor),
      textColor: _appColorTheme.pickerDialogIconColor,
      commitButton: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12, right: 22),
          color:  _appColorTheme.pickerDialogBackgroundColor,
          child: Text('确定',style:_appTextTheme.pickerDialogConfirmButtonTextStyle,)),
      cancelButton: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 12, right: 22),
        color: _appColorTheme.pickerDialogBackgroundColor,
        child: Text('取消',style: _appTextTheme.pickerDialogCancelButtonTextStyle,),
      ),
    );

  }

  @override
  void initState() {
    //年齡
    for (int i = 18; i <= 60; i++) {
      ageData.add("$i 岁");
    }
    // 家鄉
    loadText('country');

    // 職業
    loadText('job');

    //身高
    for (int i = 60; i <= 200; i++) {
      heightData.add("$i cm");
    }
    //體重
    for (int i = 40; i <= 100; i++) {
      weightData.add("$i kg");
    }

    //年收入
    annualIncomeData.add('5万以下');
    annualIncomeData.add('5-10万');
    annualIncomeData.add('10-20万');
    annualIncomeData.add('20-30万');
    annualIncomeData.add('30-50万');
    annualIncomeData.add('50万以上');
    annualIncomeData.add('保密');

    // 學歷
    educationalBackgroundData.add('初中及以下');
    educationalBackgroundData.add('中专');
    educationalBackgroundData.add('高中');
    educationalBackgroundData.add('大专');
    educationalBackgroundData.add('本科');
    educationalBackgroundData.add('硕士');
    educationalBackgroundData.add('博士');

    // 婚姻狀態
    maritalStatusData.add('单身');
    maritalStatusData.add('已婚');
    maritalStatusData.add('寻爱中');
    maritalStatusData.add('有伴侣');
    maritalStatusData.add('离异');
    // 顏色

    // 只有這個 type 的格子需要載入音效。
    if (model.type == PersonalCellType.audio) {
      _loadAudioTime();
    }

    super.initState();
  }

  _loadAudioTime() async {
    String audioUrl = ref.read(userInfoProvider).memberInfo?.audioPath ?? '';
    final auth = ref.read(userInfoProvider).memberInfo?.audioAuth ?? 0;
    final type = CertificationModel.getType(authNum: auth);

    // 審核中
    if (type == CertificationType.processing){
      final directory = await getApplicationDocumentsDirectory();
      String targetPath = path.join(directory.path, 'audio');
      final targetDir = Directory(targetPath);
      String filePath = '${targetDir.path}/audio_${ref.read(userInfoProvider).userName!}.aac';
      audioTime = await AudioUtils.getAudioTime( audioUrl: filePath, addBaseImagePath: false);
      initialAudioTime = audioTime; // 保存最初的音频时长
      setState(() {});
    } else {
      if (audioUrl.isNotEmpty) {
        await AudioUtils.init();
        audioTime = await AudioUtils.getAudioTime(audioUrl: audioUrl, addBaseImagePath: true);
        initialAudioTime = audioTime; // 保存最初的音频时长
        setState(() {});
      }
    }
    isLoadingAudio = false;

  }


  Future<void> loadText(String name) async {
    String data = await rootBundle.loadString('assets/txt/$name.txt');
    final Map<String, dynamic> jsonData = json.decode(data);
    Map<String, List<String>> mapData = {};
    jsonData.forEach((key, value) => mapData[key] = List<String>.from(value));

    switch(name) {
      case 'job':
        jobData = mapData;
        break;
      case 'country':
        homeTownData = mapData;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _linearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appImageTheme = _theme.getAppImageTheme;

    switch (model.type) {
      case PersonalCellType.normal:
        return _normal();
      case PersonalCellType.img:
        // return _img();
        return gridViewBuilder();
      case PersonalCellType.intro:
        return _intro();
      case PersonalCellType.custom:
        return _normal_custom();
      case PersonalCellType.tag:
        return _tag();
      case PersonalCellType.audio:
        return isLoadingAudio
            ? SizedBox(
          width: 46,
          height: 46,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoadingAnimation.discreteCircle(
              color: _appColorTheme.primaryColor,
                size: WidgetValue.bigIcon),
          ),
        )
            : _audio();
    }
  }

  _audio() {
    final auth = ref.read(userInfoProvider).memberInfo?.audioAuth ?? 0;
    final type = CertificationModel.getType(authNum: auth);
    final typeTitle = CertificationModel.toAudioTitle(authNum: auth);
    final audioPath = ref.read(userInfoProvider).memberInfo?.audioPath ?? '';
    final audioUrl = HttpSetting.baseImagePath + audioPath;
    final audioIcon = AudioUtils.isPlaying
        ? Icons.pause_circle_filled_outlined
        : Icons.play_circle_fill_outlined;

    if (type == CertificationType.processing || type == CertificationType.resend) {
      model.des = '审核中';
    }

    if (type == CertificationType.fail || type == CertificationType.reject) {
      if (widget.viewModel?.selectAudio == null) {
        model.des = '';
      }
    }

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
        child: (type == CertificationType.done)?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildIcon(),
                SizedBox(width: WidgetValue.horizontalPadding),
                Text(model.title,
                    style:_appTextTheme.labelPrimaryTextStyle ),
                (typeTitle.isNotEmpty)?Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: WidgetValue.separateHeight),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(WidgetValue.btnRadius),
                      color: AppColors.mainPink),
                  child: Text(typeTitle,
                      style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600)),
                ):Container(),
              ],
            ),
            (type != CertificationType.done)?(type == CertificationType.processing)?
            processingAudioWidget():Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDesList(),
                    ),
                    SizedBox(width: WidgetValue.horizontalPadding),
                    ImgUtil.buildFromImgPath(_appImageTheme.iconRightArrow, size: 24.w),
                  ],
                )):Container(),
            Visibility(
              visible: type == CertificationType.done,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
                  color: _appColorTheme.personalAudioColor
                ),
                child: InkWell(
                  onTap: () {
                    if (AudioUtils.isPlaying) {
                      AudioUtils.stopPlaying();
                      audioTime = initialAudioTime;
                      countdownTimer!.cancel();
                      setState(() {});
                    } else {
                      AudioUtils.startPlayingFromUrl(audioUrl: audioUrl);
                      countdownTimer = Timer.periodic(const Duration(seconds: 1), countdown);
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Icon(
                        audioIcon,
                        color: AppColors.whiteBackGround,
                        size: WidgetValue.primaryIcon,
                      ),
                      const SizedBox(width: 4),
                      (audioTime != null)
                          ? Text(audioTime!.toFormat(),
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 16,
                          ),
                      )
                          : const SizedBox(),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ):Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                SizedBox(width: WidgetValue.horizontalPadding),
                Text(model.title, style: _appTextTheme.labelPrimaryTextStyle),
                (typeTitle.isNotEmpty) ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: WidgetValue.separateHeight),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(WidgetValue.btnRadius),
                      gradient: _linearGradientTheme.verifyTagBackgroundColor),
                  child: Text(typeTitle,
                      style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600)),
                ):Container(),
              ],
            ),
            (type != CertificationType.done)?(type == CertificationType.processing)?
            processingAudioWidget():Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildDesList()),
                    SizedBox(width: WidgetValue.horizontalPadding),
                    ImgUtil.buildFromImgPath(_appImageTheme.iconRightArrow, size: 24.w),
                  ],
                )):Container(),
          ],
        ),
      ),
      onTap: () async {
        if (model.editable) {
          final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
          if(isPipMode){
            BaseViewModel.showToast(context, '您正在通话中，不可录音');
          }else{
            final String? popMessage =
            await BaseViewModel.pushPage(context, model.pushPage!);
            loadPopMessage(message: popMessage);
          }
        } else {
          BaseViewModel.showToast(context, '您的声音展示尚在审核中，请再等等');
        }
      },
    );
  }

  Widget processingAudioWidget(){
    final audioIcon = AudioUtils.isPlaying
        ? Icons.pause_circle_filled_outlined
        : Icons.play_circle_fill_outlined;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
          color: AppColors.mainPink),
      child: InkWell(
        onTap: () async {
          if(AudioUtils.isPlaying) {
            AudioUtils.stopPlaying();
            audioTime = initialAudioTime;
            countdownTimer!.cancel();
            setState(() {});
          } else {
            final directory = await getApplicationDocumentsDirectory();
            String targetPath = path.join(directory.path, 'audio');
            final targetDir = Directory(targetPath);
            AudioUtils.filePath = '${targetDir.path}/audio_${ref.read(userInfoProvider).userName!}.aac';
            AudioUtils.startPlaying();
            countdownTimer = Timer.periodic(const Duration(seconds: 1), countdown);
          }
          setState(() {});
        },
        child: Row(
          children: [
            Icon(
              audioIcon,
              color: AppColors.whiteBackGround,
              size: WidgetValue.primaryIcon,
            ),
            const SizedBox(width: 4),
            (audioTime != null)
                ? Text(audioTime!.toFormat(),
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 16,
              ),
            )
                : const SizedBox(),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Future<void> countdown(Timer timer) async {
    if (audioTime!.inSeconds > 0) {
      audioTime = audioTime! - const Duration(seconds: 1);
      print('剩余时间: ${audioTime!.inSeconds} 秒');
    } else {
      // 时间倒数到0后，重置为最初的音频时长
      await Future.delayed(const Duration(milliseconds: 500));
      audioTime = initialAudioTime;
      countdownTimer!.cancel();
      print('时间重置为: ${audioTime!.inSeconds} 秒');
    }
    setState(() {

    });
  }

  _normal() {

    Widget statusTag = const SizedBox();
    if (model.statusTag.isNotEmpty) {
      statusTag = Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(
            vertical: 2, horizontal: WidgetValue.separateHeight),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
            color: AppColors.mainPink),
        child: Text(model.statusTag,
            style: const TextStyle(
                color: AppColors.textWhite, fontWeight: FontWeight.w600)),
      );
    }

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: WidgetValue.horizontalPadding),
            Text(model.title, style:_appTextTheme.labelPrimaryTextStyle),
            statusTag,
            Expanded(child: _buildDesList()),
            SizedBox(width: WidgetValue.horizontalPadding),
            ImgUtil.buildFromImgPath(_appImageTheme.iconRightArrow, size: 24.w),
          ],
        ),
      ),
      onTap: () async {
        if (model.editable) {
          switch (model.title) {
            case '年龄':
              picker(ageData, selectAge);
              break;
            case '家乡':
              multiPicker(homeTownData);
              break;
            case '身高':
              picker(heightData, selectHeight);
              break;
            case '体重':
              picker(weightData, selectWeight);
              break;
            case '职业':
              multiPicker(jobData);
              break;
            case '年收入':
              picker(annualIncomeData, selectAnnualIncome);
              break;
            case '学历':
              picker(educationalBackgroundData, selectEducationalBackground);
              break;
            case '婚姻状态':
              picker(maritalStatusData, selectMaritalStatus);
              break;
            case '昵称':
              final String? popMessage =
              await BaseViewModel.pushPage(context, model.pushPage!);
              loadPopMessage(message: popMessage);
              break;
            case '声音展示':
              final String? popMessage =
              await BaseViewModel.pushPage(context, model.pushPage!);
              loadPopMessage(message: popMessage);
              break;
            default:
              BaseViewModel.pushPage(context, model.pushPage!);
              break;
          }
        } else {
          BaseViewModel.showToast(context, '尚在审核中，请再等等');
        }
      },
    );
  }

  _normal_custom() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: WidgetValue.horizontalPadding),
            Text(model.title,
                style:  _appTextTheme.labelPrimaryTextStyle),
            Expanded(
              child: _buildDesList(),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
      onTap: () async {
        log(model.title);
        if (model.editable) {
          switch (model.title) {
            case '年龄':
              picker(ageData, selectAge);
              break;
            case '家乡':
              multiPicker(homeTownData);
              break;
            case '身高':
              picker(heightData, selectHeight);
              break;
            case '体重':
              picker(weightData, selectWeight);
              break;
            case '职业':
              multiPicker(jobData);
              break;
            case '年收入':
              picker(annualIncomeData, selectAnnualIncome);
              break;
            case '学历':
              picker(educationalBackgroundData, selectEducationalBackground);
              break;
            case '婚姻状态':
              picker(maritalStatusData, selectMaritalStatus);
              break;
            case '昵称':
              final String? popMessage =
              await BaseViewModel.pushPage(context, model.pushPage!);
              loadPopMessage(message: popMessage);
              break;
            case '声音展示':
              final String? popMessage =
              await BaseViewModel.pushPage(context, model.pushPage!);
              loadPopMessage(message: popMessage);
              break;
            case '所在地':
              break;
            default:
              BaseViewModel.pushPage(context, model.pushPage!);
              break;
          }
        }
      },
    );
  }

  _buildDesList({MainAxisAlignment desAlignment = MainAxisAlignment.end}) {
    final bool isEmpty = (model.des == null || model.des == '');
    return (desList != null) //
        ? SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: desAlignment, children: desList!),
    )
        : (model.title == '所在地')
        ? Text(isEmpty ? '定位服务未开启' : model.des!,
      style: TextStyle(
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp),
      textAlign: TextAlign.end,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    )
        : Text(
      model.des ?? '去完善',
      style: TextStyle(
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp),
      textAlign: TextAlign.end,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  _buildHint(String? title) {
    return Offstage(
      offstage: title == null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        decoration: _appBoxDecorationTheme.hintPillsBoxDecoration,
        child: Text(
          title ?? '',
          style: TextStyle(
            color: _appColorTheme.hintPillsTextColor,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }

  _intro() {
    return InkWell(
      child: _buildLongDes(),
      onTap: () async {
        if (model.editable) {
          final String? popMessage =
          await BaseViewModel.pushPage(context, model.pushPage!);
          loadPopMessage(message: popMessage);
        }
      },
    );
  }

  _tag() {
    model.remark;
    return InkWell(
        child: _buildLongDes(),
        onTap: () async {
          if (model.editable) {
            final dynamic popMessage =
            await BaseViewModel.pushPage(context, model.pushPage!);
            loadPopMessage(message: popMessage);
          }
        });
  }

  _buildLongDes() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: WidgetValue.horizontalPadding),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(model.title,
                          style: _appTextTheme.labelPrimaryTextStyle),
                      SizedBox(width: WidgetValue.horizontalPadding),
                      _buildHint(model.hint),
                    ],
                  ),
                  _buildWrapRemarkOrTag()
                ],
              )),
          SizedBox(width: WidgetValue.horizontalPadding),
          Text(
            model.des ?? '去完善',
            style: TextStyle(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp),
            textAlign: TextAlign.end,
          ),
          SizedBox(width: WidgetValue.horizontalPadding),
          ImgUtil.buildFromImgPath(_appImageTheme.iconRightArrow, size: 24.w),
        ],
      ),
    );
  }

  _buildWrapRemarkOrTag() {
    if (model.type == PersonalCellType.tag && model.remark!.isNotEmpty) {
      return tagWrap();
    } else {
      return Row(
        children: model.remark?.map((text) {
          return Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ));
        }).toList() ??
            [],
      );
    }
  }

  Widget tagWrap() {
    int index = -1;
    return MainWrap().wrap(
        children: model.remark!.map((info) {
          index = index + 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
              color: _appColorTheme.tagColorList[index]
            ),
            child: Text(info, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),),
          );
        }).toList());
  }

  Widget tagWidget(String content, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(48)),
      ),
      child: Text(
        content,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textFormBlack),
      ),
    );
  }

  _buildIcon() {
    return SizedBox(
      width: 24.w,
      child: Image.asset(
        model.icon,
        width: WidgetValue.primaryIcon,
      ),
    );
  }

  //選擇器
  void picker(List<String> data, String selectData) {

    Pickers.showSinglePicker(context, data: data, selectData: selectData,pickerStyle: _getPickerStyle(),
        onConfirm: (p, position) {
          switch (model.title) {
            case '年龄':
              selectAge = p;
              model.des = selectAge;
              String output = selectAge.replaceAll(RegExp(r'[^0-9]'), '');
              widget.viewModel!.selectAge = int.parse(output);
              break;
          // case '家乡':
          //   break;
            case '身高':
              selectHeight = p;
              model.des = selectHeight;
              String output = selectHeight.replaceAll(RegExp(r'[^0-9]'), '');
              widget.viewModel!.selectHeight = num.parse(output);
              break;
            case '体重':
              selectWeight = p;
              model.des = selectWeight;
              String output = selectWeight.replaceAll(RegExp(r'[^0-9]'), '');
              widget.viewModel!.selectWeight = num.parse(output);
              break;
          // case '职业':
          //   break;
            case '年收入':
              selectAnnualIncome = p;
              model.des = selectAnnualIncome;
              print(model.des);
              // String output = selectAnnualIncome.replaceAll(RegExp(r'[^0-9]'), '');
              widget.viewModel!.selectAnnualIncome = model.des;
              break;
            case '学历':
              selectEducationalBackground = p;
              model.des = selectEducationalBackground;
              widget.viewModel!.selectEducation = selectEducationalBackground;
              break;
            case '婚姻状态':
              selectMaritalStatus = p;
              model.des = selectMaritalStatus;
              final index = maritalStatusData
                  .indexWhere((status) => status == selectMaritalStatus);
              widget.viewModel!.selectMaritalStatus = index;
              break;
          }
          setState(() {});
        });
  }

  void multiPicker(Map<String, List<String>>? data){
    Pickers.showMultiLinkPicker(context,
        pickerStyle: _getPickerStyle(),
        data: data,
        columeNum: 2,
        onConfirm: (p, position) {
          final String selectData = p.join(' ');
          switch (model.title) {
            case '家乡':
              model.des = selectData;
              widget.viewModel!.selectHomeTown = selectData;
              break;
            case '职业':
              model.des = selectData;
              widget.viewModel!.selectOccupation = selectData;
              break;
          }
          setState(() {});
        }
    );
  }

  loadPopMessage({required dynamic message}) {
    if (message == null || message == '') {
      return;
    }
    widget.onReturnMsg?.call(message);
    setState(() {});
  }

  // album view
  Widget gridViewBuilder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIcon(),
              SizedBox(width: WidgetValue.horizontalPadding),
              Text(
                model.title,
                style: _appTextTheme.labelPrimaryTextStyle,
              ),
              SizedBox(width: WidgetValue.horizontalPadding),
              _buildHint(model.hint),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            child: DraggableGridViewBuilder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              children: albumList(),
              isOnlyLongPress: true,
              dragCompletion: (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
                print('onDragAccept: $beforeIndex -> $afterIndex');

                if (afterIndex == beforeIndex) {
                  print('not change');
                } else {
                  widget.viewModel!.moveAlbumImage(
                    context,
                    afterIndex,
                    beforeIndex,
                  );
                }
              },
              dragFeedback: (List<DraggableGridItem> list, int index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  child: list[index].child,
                );
              },
              dragPlaceHolder: (List<DraggableGridItem> list, int index) {
                return PlaceHolderWidget(
                  child: Container(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 17),
          Column(
            children: model.remark!.map((text) {
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  // drag list
  List<DraggableGridItem> albumList() {

    final List<DraggableGridItem> newList = [];

    widget.viewModel!.selectImgList.asMap().forEach((index, item) {
      newList.add(albumItem(item, index));
    });

    return newList;
  }

  // drag item
  DraggableGridItem albumItem(item, index){

    final albumsPathInfo = item.albumsPathInfo;
    final albumsPathInfoStatus = item.albumsPathInfo?.status;
    final selectImgListType = item.type;

    // 審核過才顯示删除按鈕
    bool showDeleteButton =
        (albumsPathInfo != null && albumsPathInfoStatus == 1) ||
            selectImgListType == ImgType.filePath;

    return DraggableGridItem(
      child: PersonalEditAlbumCell(
        model: item,
        showDeleteButton: showDeleteButton,
        onPress: () {
          // 檢查這格是不是空的，如果是的話就選擇照片，不是空的就打開圖片預覽
          if (item.hasPath()) {
            // 有路徑 -> 這有圖片
            ImageLinksViewer.show(
              context,
              ImageLinksViewerArgs(
                imageLinks: widget.viewModel!.selectImgList.where((element) => element.hasPath()).toList(),
                initialPage: index,
              ),
            );
          } else {
            if (model.editable) widget.viewModel!.selectMultiImg(); // 空格子 -> 選擇圖片
          }
        },
        onDeletePress: () async {
          // 嘗試删除照片
          if (item.type == ImgType.filePath) {
            // 新增圖片有删除的選項
            // 直接移除，因為這是未上傳圖片
            widget.viewModel!.resetFileImage(index);
          } else if (item.type == ImgType.urlPath) {
            // 認證過的圖片
            // 使用 api 删除圖片
            await widget.viewModel!.removeAlbumImage(context, index, onErrorDialog: (errMsg) => _buildErrorDialog(errMsg));
          }
        },
      ),
      isDraggable: albumsPathInfoStatus == 1 ? true : false,
    );
  }

  Future<void> _buildErrorDialog(String errorMsg) async {
    await CheckDialog.show(context, titleText: '错误', messageText: errorMsg, appTheme: _theme);
  }
}


