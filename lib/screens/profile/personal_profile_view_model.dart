
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/free_calling/free_calling.dart';
import 'package:frechat/screens/profile/agent/personal_agent.dart';
import 'package:frechat/screens/profile/call_limit/personal_call_limit.dart';
import 'package:frechat/screens/profile/certification/personal_certification.dart';
import 'package:frechat/screens/profile/contact/personal_contact.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_frined.dart';
import 'package:frechat/screens/profile/mission/personal_mission.dart';
import 'package:frechat/screens/profile/online_service/personal_online_service.dart';
import 'package:frechat/screens/profile/setting/charm/personal_setting_charm.dart';
import 'package:frechat/screens/profile/setting/personal_setting.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../models/profile/personal_cell_model.dart';
import '../../models/profile/personal_property_model.dart';
import '../../models/ws_req/member/ws_member_info_req.dart';
import '../../models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import '../../system/providers.dart';
import '../../widgets/theme/original/app_colors.dart';

class PersonalProfileViewModel {

  WidgetRef ref;

  PersonalProfileViewModel({
    required this.ref
  });

  List<PersonalPropertyModel> list = [
    PersonalPropertyModel(
        title: '我的充值',
        num: 0,
        image: 'assets/profile/profile_deposit_wallet_btn_icon.png',
        backgroundImg:
            'assets/profile/profile_deposit_wallet_btn_background.png',
        backgroundColor: AppColors.btnOrangeBackGround,
        backgroundImgOpacity: 0.3),
    PersonalPropertyModel(
        title: '我的收益',
        num: 0,
        image: 'assets/profile/profile_benefit_wallet_btn_icon.png',
        backgroundImg:
            'assets/profile/profile_benefit_wallet_btn_background.png',
        backgroundColor: AppColors.btnPurpleBackGround)
  ];

  // List<String> swiperList = [
  //   'assets/profile/profile_swiper_1.png',
  //   'assets/profile/profile_swiper_1.png',
  //   'assets/profile/profile_swiper_1.png'
  // ];
  // late SwiperController swiperController;

  ///todo 第一階段先不做淨網行動，先拔掉

  List<PersonalCellModel> cellList = [
    // PersonalCellModel(
    //     title: '我的额度',
    //     icon: 'assets/profile/profile_cell_call_icon.png',
    //     des: '免费通话福利送给您',
    //     pushPage: FreeCalling()),
    // // /只有男生显示
    // PersonalCellModel(
    //     title: '我的额度',
    //     icon: 'assets/profile/profile_call_limit.png',
    //     des: '免费通话福利送给您',
    //     hintImg: '',
    //     pushPage: PersonalCallLimit()),
    PersonalCellModel(
        title: '任务中心',
        icon: 'assets/profile/profile_cell_mission_icon.png',
        des: '',
        hintImg: '',
        pushPage: const PersonalMission()),
    PersonalCellModel(
        title: '我的人脉',
        icon: 'assets/profile/profile_cell_contact_icon.png',
        des: '',
        hintImg: 'assets/profile/profile_coin_icon.png',
        pushPage: const PersonalContact()),
    PersonalCellModel(
        title: '推广中心',
        icon: 'assets/profile/profile_cell_agent_icon.png',
        pushPage: const PersonalAgent()),
    // PersonalCellModel(
    //     title: '邀请好友',
    //     icon: 'assets/profile/profile_cell_friend_icon.png',
    //     pushPage: PersonalInviteFriend()),
    // PersonalCellModel(
    //     title: '魅力等级',
    //     icon: 'assets/profile/profile_cell_charm_icon.png',
    //     des: '升级LV1 还需0 积分',
    //     pushPage: PersonalSettingCharm()),

    // PersonalCellModel(title: '淨網行動', icon: 'assets/profile/profile_cell_block_icon.png',
    //   pushPage: PersonalReport()),
    PersonalCellModel(
        title: '我的认证',
        icon: 'assets/profile/profile_cell_certification_icon.png',
        pushPage: const PersonalCertification()),
    PersonalCellModel(
        title: '在线客服',
        icon: 'assets/profile/profile_cell_custom_service_icon.png',
        pushPage: const PersonalOnlineService()),
    PersonalCellModel(
        title: '系统设置',
        icon: 'assets/profile/profile_cell_setting_icon.png',
        pushPage: const PersonalSetting()),
  ];

  init() {
    modifiedCellList();
    getCharmInfo();
    // swiperController = SwiperController();
  }

  dispose() {
    // swiperController.dispose();
  }

  modifiedCellList(){
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    // 邀請好友
    final points = ref.read(userInfoProvider).missionInfo?.list?[5].points ?? 0;
    final coins = ref.read(userInfoProvider).missionInfo?.list?[5].coins ?? 0;
    final status = ref.read(userInfoProvider).missionInfo?.list?[5].status ?? '-1';
    num count = 0;

    if (gender == 0 && status == '-1') {
      count = points;
    } else {
      count = coins;
    }

    if (gender == 1) {
      count = coins;
    }

    // 任務中心
    final missionInfo = cellList.firstWhere((item) => item.title == '任务中心');
    missionInfo.des = '做任务免费赚金币';
    missionInfo.hintImg = appImageTheme.iconCoin;

    // 我的人脈
    final contactInfo = cellList.firstWhere((item) => item.title == '我的人脉');
    contactInfo.des = '邀请好友最多奖励 $count 金币';
    contactInfo.hintImg = appImageTheme.iconCoin;

  }

  // 取得會員資訊
  loadMemberInfo({required Function(String) onConnectFail}) async {
    String? resultCodeCheck;
    final reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
    }
  }

  // 取得金幣與積分
  loadPropertyInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }

  // 取得魅力等級
  getCharmInfo() async {
    String? resultCodeCheck;
    final WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq.create();
    final res = await ref.read(settingWsProvider).wsSettingCharmAchievement(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {});

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }
}
