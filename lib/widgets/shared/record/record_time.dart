
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/circle_progress.dart';
import 'package:frechat/widgets/shared/record/record_time_view_model.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class RecordTime extends ConsumerStatefulWidget {
  const RecordTime({super.key, required this.audioPath, required this.onRecordStatus});
  final String? audioPath;
  final Function(SettingRecordStatus) onRecordStatus;
  @override
  ConsumerState<RecordTime> createState() => _RecordTimeState();
}

class _RecordTimeState extends ConsumerState<RecordTime> with TickerProviderStateMixin {
  late RecordTimeViewModel viewModel;
  String? get audioPath => widget.audioPath;
  Function(SettingRecordStatus) get onRecordStatus => widget.onRecordStatus;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  void initState() {
    AudioUtils.init();
    viewModel = RecordTimeViewModel(setState: setState, tickerProvider: this, onRecordStatus: onRecordStatus);
    viewModel.init(context, audioPath: audioPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return GestureDetector(
      onLongPress: () => viewModel.startTimer(),
      onLongPressEnd: (_) => viewModel.stopTimer(context: context),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        width: UIDefine.getWidth(),
        decoration: (viewModel.recordStatus == SettingRecordStatus.done)
            ?_appBoxDecorationTheme.personalGreetAddRecordFinishBoxDecoration
            :_appBoxDecorationTheme.personalGreetAddRecordBoxDecoration,
        // decoration: BoxDecoration(
        //     color: AppColors.mainGrey,
        //     gradient: (viewModel.recordStatus == SettingRecordStatus.done)
        //         ? AppColors.pinkGradientColors
        //         : null,
        //     borderRadius: BorderRadius.circular(WidgetValue.btnRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('长按开始录音',
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text('5s-15s',
                    style: TextStyle(color: AppColors.textWhite, fontSize: 12,fontWeight: FontWeight.w400)),
              ],
            ),
            Column(
              children: [
                _buildTimeAndPlayer(),
                CircleProgressIndicatorWidget(
                  controller: viewModel.controller,
                  iconData: Icons.mic,
                  iconSize: WidgetValue.monsterIcon,
                  recordingIconColor: _appColorTheme.personalGreetAddRecordColor,
                  borderColor: _appColorTheme.personalGreetAddRecordColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _playAudio() {
    if(viewModel.isUrlPath) {
      viewModel.startPlayingUrl(audioPath);
    } else {
      viewModel.startPlayingRecord();
    }
  }

  _buildTimeAndPlayer() {
    final isPlayingRecord = viewModel.isPlayRecord;
    final playIcon = isPlayingRecord
        ? Icons.pause_circle_filled_outlined
        : Icons.play_circle_fill_outlined;
    final recordStatusIsDone = viewModel.recordStatus == SettingRecordStatus.done;
    bool isRecording = viewModel.recordStatus == SettingRecordStatus.isRecoding;
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
                _playAudio();
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
                color:isRecording? _appColorTheme.personalGreetAddRecordTimeColor:Colors.white,
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