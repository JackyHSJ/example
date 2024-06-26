
import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';

class RecordTimeViewModel {
  RecordTimeViewModel({
    required this.setState,
    required this.tickerProvider,
    required this.onRecordStatus,
  });
  ViewChange setState;
  TickerProvider tickerProvider;
  Function(SettingRecordStatus) onRecordStatus;

  Timer? timer;
  double elapsedSeconds = 0;
  late AnimationController controller;
  final int maxTime = 15;
  SettingRecordStatus recordStatus = SettingRecordStatus.unRecord;
  bool isPlayRecord = false;
  bool isUrlPath = false;

  init(BuildContext context, {String? audioPath}) async {
    controller = AnimationController(
      duration: Duration(seconds: maxTime),
      vsync: tickerProvider,
    )..addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.stop(); // stop the animation when it completes
      }
      if (context.mounted) {
        setState(() {});
      }
    });

    _loadAudioData(audioPath);
  }

  _loadAudioData(String? audioPath) async {
    if(audioPath != null) {
      recordStatus = SettingRecordStatus.done;
      onRecordStatus(SettingRecordStatus.done);

      final duration = await AudioUtils.getAudioTime(audioUrl: audioPath, addBaseImagePath: true);
      elapsedSeconds = duration?.inSeconds.toDouble() ?? 0;
      isUrlPath = true;
    }
    setState((){});
  }

  startTimer() {
    elapsedSeconds = 0;
    recordStatus = SettingRecordStatus.isRecoding;
    onRecordStatus(SettingRecordStatus.isRecoding);

    timer ??= Timer.periodic(Duration(seconds: 1), (t) {
      if (elapsedSeconds > maxTime) {
        stopTimer();
      }
      if (elapsedSeconds < maxTime) {
        elapsedSeconds++;
      }
    });
    startAnimate();
    _startRecord();
  }

  stopTimer({BuildContext? context}) {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    pauseAnimate();
    _stopRecord();
    if (context == null) {
      return;
    }
    _checkAudio(context);
    setState(() {});
  }

  void startAnimate() {
    controller.forward();
  }

  void pauseAnimate() {
    controller.stop();
    controller.value = 0;
  }

  _startRecord() async {
    isUrlPath = false;
    await AudioUtils.startRecording(15);
  }

  _stopRecord() {
    AudioUtils.stopRecording();
  }

  clearRecord() {
    AudioUtils.filePath = '';
    elapsedSeconds = 0;
    recordStatus = SettingRecordStatus.unRecord;
    onRecordStatus(SettingRecordStatus.unRecord);
    setState(() {});
  }

  startPlayingRecord() async {
    isPlayRecord = true;
    await AudioUtils.startPlaying();
    isPlayRecord = false;
    setState(() {});
  }

  startPlayingUrl(String? audioPath) async {
    isPlayRecord = true;
    AudioUtils.startPlayingFromUrl(audioUrl: HttpSetting.baseImagePath + audioPath!)
        .whenComplete(() => isPlayRecord = false);
    setState(() {});
  }

  stopPlayingRecord() {
    AudioUtils.stopPlaying();
    isPlayRecord = false;
    setState(() {});
  }

  _checkAudio(BuildContext context) {
    if (elapsedSeconds < 5) {
      BaseViewModel.showToast(context, '至少录制五秒');
      return;
    }
    recordStatus = SettingRecordStatus.done;
    onRecordStatus(SettingRecordStatus.done);
  }
}