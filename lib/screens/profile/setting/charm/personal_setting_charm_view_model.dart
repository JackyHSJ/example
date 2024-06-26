import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charge_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charge_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class PersonalSettingCharmViewModel {
  PersonalSettingCharmViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;
  late Timer timer;
  int currentTimeStamp = 0;
  double percent = 0;
  String displayTime = '';

  init(BuildContext context) async {
    await _getCharmInfo(context);
    // _setPercent();
    _setTimer();
  }

  dispose() {
    timer.cancel();
  }

  _timeStampFormat(timeStamp){
    int seconds = (timeStamp / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    int days = (hours / 24).floor();

    hours %= 24;
    minutes %= 60;
    seconds %= 60;

    String formattedDays = (days >= 10) ? days.toString() : '0$days';
    String formattedHours = (hours >= 10) ? hours.toString() : '0$hours';
    String formattedMinutes = (minutes >= 10) ? minutes.toString() : '0$minutes';
    String formattedSeconds = (seconds >= 10) ? seconds.toString() : '0$seconds';

    String timeLeftFormatted =
        '$formattedDays 天 $formattedHours:$formattedMinutes:$formattedSeconds';

    return timeLeftFormatted;
  }

  setPercent(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final currentLevel = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final currentPoint = charmAchievementInfo?.personalCharm?.charmPoints ?? 0;

    if(currentLevel == 8){
      percent = 100;
    } else {
      final nextLevelInfo = charmAchievementInfo?.list?.firstWhere((item) => item.charmLevel == '${currentLevel + 1}');
      final nextLevelCondition = nextLevelInfo?.levelCondition?.split('|');
      final nextLevelTargetPoint = nextLevelCondition?[1];
      percent = currentPoint/double.parse(nextLevelTargetPoint!);
    }
  }

  _setTimer(){
    timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      if (currentTimeStamp > 0 && currentTimeStamp - 1000 > 1000) {
        currentTimeStamp = currentTimeStamp - 1000;
        displayTime = _timeStampFormat(currentTimeStamp);
      } else {
        currentTimeStamp = currentTimeStamp - 1000;
        displayTime = _timeStampFormat(currentTimeStamp);
        timer.cancel();
      }
    });
  }

  _getCharmInfo(BuildContext context) async {
    String? resultCodeCheck;
    final WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq.create();
    final res = await ref.read(settingWsProvider).wsSettingCharmAchievement(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {

      // 倒數時間
      final expireTimeStamp = res.personalCharm!.charmLevelExpire!.toInt();
      final nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      currentTimeStamp = expireTimeStamp - nowTimeStamp;
      displayTime = _timeStampFormat(currentTimeStamp);

      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }

  bool isMaxLevel(WsSettingCharmAchievementRes? charmAchievementInfo) {
    final num maxLevel = charmAchievementInfo?.list?.length ?? 0;
    final currentLevel = charmAchievementInfo?.personalCharm?.charmLevel ?? 0;
    final isMaxLevel = maxLevel <= currentLevel;
    return isMaxLevel;
  }
}
