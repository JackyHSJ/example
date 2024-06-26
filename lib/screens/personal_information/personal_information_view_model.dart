

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/banner/ws_banner_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';

class PersonalInformationViewModel {
  PersonalInformationViewModel({
    required this.ref
  });
  WidgetRef ref;

  Future<void> loadMemberInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
    }
  }

  Future<void> loadBannerInf(BuildContext context) async {
    String? resultCodeCheck;
    WsBannerInfoReq reqBody = WsBannerInfoReq.create();
    final WsBannerInfoRes res = await ref.read(bannerWsProvider).wsBannerInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadBannerInfo(res);
    }
  }

  Future<void> loadMissionInfo(BuildContext context) async {
    String? resultCodeCheck;
    final WsMissionSearchStatusReq reqBody = WsMissionSearchStatusReq.create();
    final WsMissionSearchStatusRes res = await ref.read(missionWsProvider).wsMissionSearchStatus(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMissionInfo(res);
    }
  }

  Future<void> loadCharmAchievement(BuildContext context) async {
    String? resultCodeCheck;
    final WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq.create();
    final WsSettingCharmAchievementRes res = await ref.read(settingWsProvider).wsSettingCharmAchievement(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }
}