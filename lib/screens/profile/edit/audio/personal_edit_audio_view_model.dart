import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/util/audio_util.dart';

enum SettingRecordStatus { isRecoding, done, unRecord }

class PersonalEditAudioViewModel {
  PersonalEditAudioViewModel(
      {required this.setState, required this.tickerProvider});
  ViewChange setState;
  TickerProvider tickerProvider;

  Timer? timer;
  double elapsedSeconds = 0;
  late AnimationController controller;
  final int maxTime = 15;
  SettingRecordStatus recordStatus = SettingRecordStatus.unRecord;
  bool isPlayRecord = false;

  startTimer() {
    elapsedSeconds = 0;
    recordStatus = SettingRecordStatus.isRecoding;
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

  init(BuildContext context) {
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
  }

  dispose() {
    stopTimer();
    controller.dispose();
  }

  void startAnimate() {
    controller.forward();
  }

  void pauseAnimate() {
    controller.stop();
    controller.value = 0;
  }

  _startRecord() async {
    await AudioUtils.startRecording(15);
  }

  _stopRecord() {
    AudioUtils.stopRecording();
  }

  startPlayingRecord() {
    AudioUtils.startPlaying().whenComplete(() {
      isPlayRecord = false;
      setState((){});
    });
    isPlayRecord = true;
    setState(() {});
  }

  stopPlayingRecord() {
    AudioUtils.stopPlaying();
    isPlayRecord = false;
    setState(() {});
  }

  clearRecord() {
    AudioUtils.filePath = '';
    recordStatus = SettingRecordStatus.unRecord;
    elapsedSeconds=0;
    setState(() {});
  }

  _checkAudio(BuildContext context) {
    if (elapsedSeconds < 5) {
      BaseViewModel.showToast(context, '至少录制五秒');
      return;
    }
    recordStatus = SettingRecordStatus.done;
  }
}
