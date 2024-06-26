import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/circle_progress.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/yueyuan/app_colors_yueyuan_main.dart';

import '../../../../widgets/theme/original/app_colors.dart';
import '../../../../widgets/theme/uidefine.dart';

class PersonalEditAudio extends ConsumerStatefulWidget {
  const PersonalEditAudio({super.key});

  @override
  ConsumerState<PersonalEditAudio> createState() => _PersonalEditAudioState();
}

class _PersonalEditAudioState extends ConsumerState<PersonalEditAudio> with SingleTickerProviderStateMixin {

  late PersonalEditAudioViewModel viewModel;
  List<String>? linesList;
  String? lines;
  bool isLoading = true;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _linearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalEditAudioViewModel(setState: setState, tickerProvider: this);
    viewModel.init(context);
    loadLinesText();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> loadLinesText() async {
    // 将每行文字添加到List中
    String data = await rootBundle.loadString('assets/txt/lines.txt');
    linesList = const LineSplitter().convert(data);
    lines = linesList![Random().nextInt(linesList!.length)];
    setState(() {
      isLoading = false;
    });
  }

  void showPreventDialog() {
    CommDialog(context).build(
      theme: _theme,
      title: '提醒',
      contentDes: '您现在正在通话中，无法进行录音',
      rightBtnTitle: '确定',
      rightAction: () {
        BaseViewModel.popupDialog();
        BaseViewModel.popPage(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _linearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      backgroundColor: _appColorTheme.baseBackgroundColor,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: 16.w, right: 16.w),
      appBar: _buildAppBar(),
      child: (isLoading) ? _buildLoading() : _buildMainContent()
    );
  }

  // Appbar
  MainAppBar _buildAppBar(){
    return MainAppBar(
      theme: _theme,
      title: '',
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      titleWidget: Text('声音展示', style: _appTextTheme.appbarTextStyle),
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }

  // Loading
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Main
  Widget _buildMainContent() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        _buildTopDes(),
        _buildClassicLines(),
        _buildChangeLinesBtn(),
        _buildRecordDes(),
        Expanded(child: _buildRecord()),
        _buildBtn(),
        SizedBox(height: WidgetValue.btnBottomPadding,)
      ],
    );
  }

  _buildTopDes() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Text(
        '展示你的声线，更有吸引力~',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _appColorTheme.editAudiodTitleColor,
        ),
      ),
    );
  }

  _buildClassicLines() {
    return Container(
        height: WidgetValue.mainComponentHeight * 2,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: 12.w),
        decoration: _appBoxDecorationTheme.cellBoxDecoration,
        child: SingleChildScrollView(
          child: Text(
            lines ?? '',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:_appColorTheme.editAudiodTextFieldHintColor,
            ),
          ),
        ),
    );
  }

  _buildChangeLinesBtn() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding * 2),
        decoration: _appBoxDecorationTheme.editAudioChangeWordBoxDecoration,
        child: Text('换一句', style: _appTextTheme.editAudioChangeWordTextStyle),
      ),
      onTap: () {
        setState(() {
          lines = linesList![Random().nextInt(linesList!.length)];
        });
      },
    );
  }

  _buildRecordDes() {
    return const Text('按住下方按钮以开始录音，至少5s', style: TextStyle(color: AppColors.textGrey));
  }

  _buildRecord() {
    return GestureDetector(
      onLongPress: () {
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          showPreventDialog();
          return;
        }
        viewModel.startTimer();
      },
      onLongPressEnd: (_) {
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          showPreventDialog();
          return;
        }
        viewModel.stopTimer(context: context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        width: double.infinity,
        decoration: viewModel.recordStatus == SettingRecordStatus.done
          ? _appBoxDecorationTheme.editAudioDoneBoxDecoration
          : _appBoxDecorationTheme.editAudioInitBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             Column(
              children: [
                Text(
                  '长按开始录音',
                  style: TextStyle(
                    color: _appColorTheme.editAudioBeginRecordTitleColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '5s-15s',
                  style: TextStyle(
                    color: _appColorTheme.editAudioBeginRecordHintColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildTimeAndPlayer(),
                CircleProgressIndicatorWidget(
                  controller: viewModel.controller,
                  iconData: Icons.mic,
                  iconSize: WidgetValue.monsterIcon,
                  unRecordIconColor:_appColorTheme.editAudioBeginRecordUnRecordIconColor,
                  recordingIconColor:_appColorTheme.editAudioBeginRecordRecordIconColor,
                  borderColor:_appColorTheme.editAudioBeginRecordIconProgressBordColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildBtn() {
    final isDone = viewModel.recordStatus == SettingRecordStatus.done;
    return InkWell(
      onTap: () {
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          showPreventDialog();
          return;
        }

        if (!isDone) {
          return;
        }
        BaseViewModel.popPage(context, sendMessage: AudioUtils.filePath);
        BaseViewModel.showToast(context, '记得再次点击保存才会储存设定哦');
      },
      child: Container(
        width: UIDefine.getWidth(),
        height: WidgetValue.mainComponentHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
            gradient: isDone
                ? _linearGradientTheme.buttonSecondaryColor
                : _linearGradientTheme.buttonPrimaryColor),
        child: Text('确定',
            style:isDone
                ?_appTextTheme.buttonSecondaryTextStyle
                :_appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  _buildTimeAndPlayer() {
    final isPlayingRecord = viewModel.isPlayRecord;
    final playIcon = isPlayingRecord
        ? Icons.pause_circle_filled_outlined
        : Icons.play_circle_fill_outlined;
    final recordStatusIsDone =
        viewModel.recordStatus == SettingRecordStatus.done;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: recordStatusIsDone,
          child: InkWell(
            onTap: () {
              if (isPlayingRecord) {
                viewModel.stopPlayingRecord();
              } else {
                viewModel.startPlayingRecord();
              }
              setState(() {});
            },
            child: Icon(
              playIcon,
              color: AppColors.whiteBackGround,
              size: WidgetValue.primaryIcon,
            ),
          ),
        ),
        SizedBox(width: WidgetValue.horizontalPadding),
        Text('${viewModel.elapsedSeconds}',
            style: TextStyle(
                color:_appColorTheme.editAudioBeginRecordTimeColor,
                fontWeight: FontWeight.w600,
                fontSize: 25)),
        SizedBox(
          width: WidgetValue.horizontalPadding,
        ),
        Visibility(
          visible: recordStatusIsDone,
          child: InkWell(
            onTap: () => viewModel.clearRecord(),
            child: Icon(
              Icons.cancel,
              color: AppColors.whiteBackGround,
              size: WidgetValue.primaryIcon,
            ),
          ),
        )
      ],
    );
  }


}
