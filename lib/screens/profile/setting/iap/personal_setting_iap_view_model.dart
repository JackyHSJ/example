import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charge_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

import '../../../../models/profile/personal_setting_iap_model.dart';

class SettingIAPModel {
  SettingIAPModel({
    required this.title,
    required this.selectNum,
    required this.needLock,
  });
  String title;
  String selectNum;
  bool needLock;
}

class PersonalSettingIAPViewModel {
  PersonalSettingIAPViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  List<PersonalSettingIAPModel> cellList = [];

  List<PersonalSettingIAPIntroModel> introList = [
    PersonalSettingIAPIntroModel(
      title: '对方主动给你发文消息与你进行视频/语音通话，你的收费依据本页设置',
    ),
    PersonalSettingIAPIntroModel(
      title: '魅力值越高，可设置的价格越高',
    ),
    PersonalSettingIAPIntroModel(title: '查看如何提高魅力值？', enableAction: true)
  ];

  List<SettingIAPModel> messageList = [];
  List<SettingIAPModel> voiceList = [];
  List<SettingIAPModel> videoList = [];

  int charmLevel = 0;

  List<PersonalSettingIAPModel> selectList = [];

  chargeSetting(BuildContext context) async {
    String? resultCodeCheck;
    final WsSettingCharmAchievementRes charmAchievement = ref.watch(userInfoProvider).charmAchievement ?? WsSettingCharmAchievementRes();
    List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement.list;
    final CharmAchievementInfo? charmAchievementInfoText = charmAchievementInfoList?.firstWhere((info) => info.messageCharge == selectList[0].phraseNum.toString(), orElse: () => CharmAchievementInfo(charmLevel: "0"));
    final CharmAchievementInfo? charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.voiceCharge == selectList[1].phraseNum.toString(), orElse: () => CharmAchievementInfo(charmLevel: "0"));
    final CharmAchievementInfo? charmAchievementInfoVideo = charmAchievementInfoList?.firstWhere((info) => info.streamCharge == selectList[2].phraseNum.toString(), orElse: () => CharmAchievementInfo(charmLevel: "0"));


    final WsSettingChargeReq reqBody = WsSettingChargeReq.create(
      messageCharge: int.parse(charmAchievementInfoText!.charmLevel!),
      voiceCharge: int.parse(charmAchievementInfoVoice!.charmLevel!),
      streamCharge: int.parse(charmAchievementInfoVideo!.charmLevel!),
    );
    await ref.read(settingWsProvider).wsSettingCharge(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final WsSettingCharmAchievementRes charmAchievement = ref.read(userInfoProvider).charmAchievement ?? WsSettingCharmAchievementRes();
      final WsSettingCharmAchievementRes res = _getCharmAchievementRes(charmAchievement: charmAchievement, reqBody: reqBody);
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
      BaseViewModel.showToast(context, '设定成功');
    }
  }

  WsSettingCharmAchievementRes _getCharmAchievementRes({
    required WsSettingCharmAchievementRes charmAchievement,
    required WsSettingChargeReq reqBody
  }) {
    final PersonalCharmInfo info = PersonalCharmInfo(
      charmLevelExpire: charmAchievement.personalCharm?.charmLevelExpire,
      charmLevel: charmAchievement.personalCharm?.charmLevel,
      charmPoints: charmAchievement.personalCharm?.charmPoints,
      charmCharge: '${reqBody.messageCharge}|${reqBody.voiceCharge}|${reqBody.streamCharge}',
    );
    final WsSettingCharmAchievementRes res = WsSettingCharmAchievementRes(
      list: charmAchievement.list,
      personalCharm: info
    );
    return res;
  }

  getCharmInfo(BuildContext context) async {
    String? resultCodeCheck;
    WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq.create();
    final WsSettingCharmAchievementRes res = await ref.read(settingWsProvider).wsSettingCharmAchievement(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }

  initAchievement() {
    messageList = [];
    voiceList = [];
    videoList = [];
    selectList = [];
  }

  getCharmAchievement(WsSettingCharmAchievementRes charmAchievement) {
    initAchievement();

    /// 讀取初始設定
    final String? charmCharge = charmAchievement.personalCharm?.charmCharge;
    if(charmCharge == null) {
      return;
    }
    charmLevel = charmAchievement.personalCharm?.charmLevel?.toInt() ?? 0;

    List<String> part = charmCharge.split('|');
    List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement.list;
    final CharmAchievementInfo? charmAchievementInfoText = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == part[0], orElse: () => CharmAchievementInfo(messageCharge: "0"));
    final CharmAchievementInfo? charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == part[1], orElse: () => CharmAchievementInfo(voiceCharge: "0"));
    final CharmAchievementInfo? charmAchievementInfoVideo = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == part[2], orElse: () => CharmAchievementInfo(streamCharge: "0"));

    selectList.add(PersonalSettingIAPModel(
        title: '消息价格', phraseNum: int.parse(charmAchievementInfoText!.messageCharge!), unit: '則'));
    selectList.add(PersonalSettingIAPModel(
        title: '语音价格', phraseNum: int.parse(charmAchievementInfoVoice!.voiceCharge!), unit: '分钟'));
    selectList.add(PersonalSettingIAPModel(
        title: '视频价格', phraseNum: int.parse(charmAchievementInfoVideo!.streamCharge!), unit: '分钟'));


    /// 讀取下拉列表
    final List<CharmAchievementInfo>? list = charmAchievement.list;
    if(list == null && list == []) {
      return;
    }
    messageList = charmAchievement.getSettingIAPModel(SettingIapType.message);
    voiceList = charmAchievement.getSettingIAPModel(SettingIapType.voice);
    videoList = charmAchievement.getSettingIAPModel(SettingIapType.video);
  }
}
