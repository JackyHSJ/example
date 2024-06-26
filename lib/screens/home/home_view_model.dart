
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/req/check_app_version_req.dart';
import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/models/res/check_app_version_res.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_apple_reply_receipt_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_money_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_number_option_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_wechat_pay_sign_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_intimacy_level_up_res.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_money_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_wechat_pay_sign_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen_view_model.dart';
import 'package:frechat/screens/version_update_reminder/version_update_reminder.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/notification/notification_manager.dart';
import 'package:frechat/system/payment/alipay/alipay_manager.dart';
import 'package:frechat/system/payment/apple_payment/apple_payment_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:frechat/system/websocket/websocket_manager.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/banner_view/banner_view_dialog.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/home/new_member_award_dialog.dart';
import 'package:frechat/widgets/home/register_award_dailog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/strike_up_list/dialogs/strike_up_list_teen_dialog.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:frechat/system/global.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel {
  HomeViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  WebSocketUtil? webSocketUtil;

  CheckAppVersionRes? res;

  bool isNeedUpdate = false;
  bool isForceUpdate = false;

  init(BuildContext context) {

    WakelockPlus.enable();

    /// 本地推播用
    // NotificationManager.init();

    /// 初始化wechat share
    // ShareUtil.registerPlatform();
  }

  initNaviBarPageController() {
    if(naviBarController != null) {
      return ;
    }
    naviBarController = PageController();
  }

  disposeNaviBarPageController() {
    if(naviBarController == null) {
      return ;
    }
    naviBarController?.dispose();
    naviBarController = null;
  }

  initNaviBarPageListener() {
    /// 開啟底部導航的 Listener
    // ref.read(trackNavigatorProvider).initAnalyticsNaviBarListenerForTab();
  }

  afterFirstLayout(BuildContext context) async {
    /// Zego Login Listener
    final zegoLogin = ref.read(zegoLoginProvider);
    zegoLogin.addReceiveCallListener();
    zegoLogin.addInviteCallListener();
    /// 通話監聽
    zegoLogin.addCallingListUpdateListener();
    /// 消息監聽
    ChatRoomViewModel(ref: ref, setState: setState, context: context).listenerZimCallBack();
    /// 全局監聽
    _addPublicListener();

    /// 初始化新用戶列表排序
    ref.read(newUserBehaviorManagerProvider).init();

    /// 檢查權限
    _checkPermission();
  }

  dispose() {
    _disposePublicListener();
    /// 本地推播用
    NotificationManager.dispose();
  }

  _checkPermission() async {
    final bool isCheckedNotificationPermission = await FcPrefs.getIsCheckedNotificationPermission();
    if(isCheckedNotificationPermission){
      return;
    }
    PermissionUtil.checkAndRequestNotificationPermission();
  }

  _addPublicListener() {
    if(webSocketUtil != null) {
      return ;
    }
    webSocketUtil = WebSocketUtil();
    webSocketUtil?.onWebSocketListen(
        functionObj: WsParamsReq.accountIntimacyLevelUp,
        onReceiveData: (res) {
          if(res.resultCode != ResponseCode.CODE_SUCCESS) {
            return ;
          }

          final BaseRes baseRes = BaseRes.fromJson(res.resultMap);
          if(baseRes.resultCode != ResponseCode.CODE_INTIMACY_POINTS_UP) {
            return ;
          }

          final WsAccountIntimacyLevelUpRes accountIntimacyLevelUpRes = WsAccountIntimacyLevelUpRes.fromJson(baseRes.resultMsg);
          if(accountIntimacyLevelUpRes.isCohesionLevelUp == false) {
            return;
          }

          final BuildContext currentContext = BaseViewModel.getGlobalContext();
          _cohesionLevelUp(currentContext, res: accountIntimacyLevelUpRes);
        });
  }

  _disposePublicListener() {
    if(webSocketUtil == null) {
      return ;
    }
    webSocketUtil?.onWebSocketListenDispose();
    webSocketUtil = null;
  }

  Future<bool> checkTeenMode(BuildContext context) async {
    await PersonalSettingTeenViewModel.getTeenStatus(context: context, ref: ref, setState: setState);
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    await FcPrefs.setTeenMode(isTeenMode);
    if (!isTeenMode) {
      return false;
    }else{
      return true;
    }
  }

  checkAppVersion(BuildContext context) async {
    final String token = ref.read(userInfoProvider).commToken ?? '';
    final CheckAppVersionReq reqBody = CheckAppVersionReq.create(tId: token);
    String? resultCodeCheck;
    res = await ref.read(commApiProvider).checkAppVersion(reqBody,
        onConnectSuccess: (code) => resultCodeCheck = code, onConnectFail: (errMsg) { BaseViewModel.showToast(context, ResponseCode.map[errMsg]!); });
  }

  String _getCohesionName(num intimacyLevel) {
    String cohesionName = '';
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    List<IntimacyLevelInfo?> levelInfo = intimacyLevelInfo.list!.where((item) => item.cohesionLevel == intimacyLevel).toList();
    if (levelInfo.isNotEmpty) {
      cohesionName = levelInfo.first?.cohesionName ?? '';
    }
    return cohesionName;
  }

  void pushVersionUpdateReminderPage(){
    String updateVersion = res?.appVersion ?? '';
    String currentVersion = AppConfig.appVersion;
    List<String> updateVersionList = updateVersion.split('.');
    List<String> currentVersionList = currentVersion.split('.');
    try {
      for(int i = 0;i < updateVersionList.length; i++){
        if(int.parse(currentVersionList[i]) > int.parse(updateVersionList[i])){
          isNeedUpdate = false;
          return;
        }else if(int.parse(currentVersionList[i]) == int.parse(updateVersionList[i])){
          isNeedUpdate = false;
          continue;
        }else{
          isNeedUpdate = true;
          //前兩碼為強制更新
          if(i<2){
            isForceUpdate = true;
          }else{
            isForceUpdate = false;
          }
          break;
        }
      }
    } catch (e) {
      print('版號有誤');
    }
  }

  void _cohesionLevelUp(BuildContext context, {required WsAccountIntimacyLevelUpRes res}) {
    // http://redmine.zyg.com.tw/issues/1397
    ref.read(userUtilProvider.notifier).setDataToPrefs(currentPage: 6);
    final List? idList = res.userList; // List: [userId, userId]
    if (idList == null) return;

    // 取得自己的 userId，並尋找第一個不是自己的 userId。
    final num myUserId = ref.read(userInfoProvider).userId ?? 0;
    final num? oppositeUserId = idList?.firstWhere((userId) => userId != myUserId);
    if (oppositeUserId == null) return;

    // 取得 ChatUserModel，並尋找第一個符合 oppositeUserId 的資料
    final List<ChatUserModel> allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    final ChatUserModel? result = allChatUserModelList?.firstWhere((info) => info.userId == oppositeUserId);
    if (result == null) return;

    String displayName = result.userName ?? '';
    String roomName = result.roomName ?? '';
    String remark = result.remark ?? '';

    if (roomName.isNotEmpty) displayName = roomName;
    if (remark.isNotEmpty) displayName = remark;
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppTextTheme appTextTheme = theme.getAppTextTheme;

    CommDialog(context).build(
      theme: theme,
      title: '恭喜',
      contentDes: '双方亲密度需要达到2级才可以开启视频和语音通话功能。给对方聊天和送礼可以快速提升亲密度～',
      rightBtnTitle: '確認',
      horizontalPadding: WidgetValue.horizontalPadding,
      isDialogCancel: false,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('恭喜您与$displayName的亲密度已达到', style: appTextTheme.cohesionLevelUpDialogContentTextStyle,),
          SizedBox(height: 5),
          _buildIntimacyLevelWidget(res.cohesionPoints ?? 0, res.cohesionLevel ?? 0),
        ],
      ),
      rightAction: () => BaseViewModel.popPage(context));
  }

  Widget _buildIntimacyLevelWidget(num cohesionPoints, num cohesionLevel) {
    String cohesionName = _getCohesionName(cohesionLevel);
    List data = getNowIntimacy(cohesionPoints);
    String cohesionImagePath = data[0];
    List<Color> intimacyLevelBgColor = data[1];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 6, left: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: intimacyLevelBgColor,
                  stops: const [0.3265, 0.7491],
                  transform: const GradientRotation(269.71),
                ),
              ),
              // width: nameWidth,
              height: 16,
              child: Text('$cohesionName',
                style: const TextStyle(color: Color(0xffFFFFFF), fontSize: 10, fontWeight: FontWeight.w500, height: 0.1),
              ),
            ),
          ],
        ),
        Positioned(
          top: -6,
          left: 0,
          child: ImgUtil.buildFromImgPath(cohesionImagePath, size: 28),
        )
      ],
    );
  }

  List getNowIntimacy(num cohesionPoints) {
    Map pointsRuleMap = {};
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    final List<IntimacyLevelInfo>? intimacyLevelInfoList = intimacyLevelInfo.list;
    if (intimacyLevelInfoList != null) {
      for (final intimacyLevelInfo in intimacyLevelInfoList) {
        pointsRuleMap[intimacyLevelInfo.cohesionLevel] = intimacyLevelInfo.points;
      }
    }

    String cohesionImagePath = '';
    List<Color> intimacyLevelBgColor = [];

    if (cohesionPoints < pointsRuleMap[1]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
      intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
    } else if (pointsRuleMap[1] <= cohesionPoints && cohesionPoints < pointsRuleMap[2]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
      intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
    } else if (pointsRuleMap[2] <= cohesionPoints && cohesionPoints < pointsRuleMap[3]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_2.png';
      intimacyLevelBgColor = [Color(0xFF81B3E9), Color.fromRGBO(225, 237, 250, 0),];
    } else if (pointsRuleMap[3] <= cohesionPoints && cohesionPoints < pointsRuleMap[4]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_3.png';
      intimacyLevelBgColor = [Color(0xFF61BC81), Color.fromRGBO(227, 244, 233, 0),];
    } else if (pointsRuleMap[4] <= cohesionPoints && cohesionPoints < pointsRuleMap[5]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_4.png';
      intimacyLevelBgColor = [Color(0xFFF1B0B8), Color.fromRGBO(236, 153, 162, 0),];
    } else if (pointsRuleMap[5] <= cohesionPoints && cohesionPoints < pointsRuleMap[6]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_5.png';
      intimacyLevelBgColor = [Color(0xFFF2B0B8), Color.fromRGBO(174, 120, 237, 0),];
    } else if (pointsRuleMap[6] <= cohesionPoints && cohesionPoints < pointsRuleMap[7]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_6.png';
      intimacyLevelBgColor = [Color(0xFFDE858E), Color.fromRGBO(219, 120, 130, 0),];
    } else if (pointsRuleMap[7] <= cohesionPoints && cohesionPoints < pointsRuleMap[8]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_7.png';
      intimacyLevelBgColor = [Color(0xFFCC1F18), Color.fromRGBO(176, 46, 37, 0),];
    }else{
      cohesionImagePath = 'assets/icons/icon_intimacy_level_8.png';
      intimacyLevelBgColor = [Color(0xFFEAA850), Color.fromRGBO(242, 201, 141, 0),];
    }

    return [cohesionImagePath, intimacyLevelBgColor];
  }

  advertisesDialogQueue({int index = 0}){
    MemberRegisterRes? memberRegisterRes = ref.read(memberRegisterResProvider);
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    switch(index){
      case 0:
        _showRegisterAwardDialog(memberRegisterRes,memberInfo);
        break;
      case 1:
        _showNewMemberAwardDialog(memberRegisterRes,memberInfo);
        break;
      case 2:
        _showBannerViewDialog();
        break;
      case 3:
        _showStrikeUpListTeenDialog(memberRegisterRes,memberInfo);
      default:
        break;
    }
  }

  _showRegisterAwardDialog(MemberRegisterRes? memberRegisterRes,WsMemberInfoRes? memberInfo){
    if (memberRegisterRes != null && memberRegisterRes.benefit != null && memberInfo != null) {
      showDialog(
        context: BaseViewModel.getGlobalContext(),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RegisterAwardDialog(registerBenefit: memberRegisterRes?.benefit, gender: memberInfo?.gender ?? 0,onClose: ()=>advertisesDialogQueue(index: 1),);
        },
      );
    }else{
      advertisesDialogQueue(index: 1);
    }
  }
  _showNewMemberAwardDialog(MemberRegisterRes? memberRegisterRes,WsMemberInfoRes? memberInfo){
    if (memberRegisterRes != null && memberRegisterRes.benefit != null && memberInfo != null && memberInfo.gender == 1) {
      // await HomeRegisterBenefitDialog.show(context, registerBenefit: memberRegisterRes.benefit!);
      showDialog(
        context: BaseViewModel.getGlobalContext(),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NewMemberAwardDialog(registerBenefit: memberRegisterRes?.benefit,onClose: ()=>advertisesDialogQueue(index: 2),);
        },
      );
    }else{
      advertisesDialogQueue(index: 2);
    }

  }
  _showBannerViewDialog() async{
    //Banner 瀏覽 Dialog
    bool showActivityType = ref.read(userInfoProvider).buttonConfigList?.activityType == 1 ? true : false;
    List<BannerInfo> homeBannerInfo = _filteredBannerInfoList(locatedPage: 1);
    if (showActivityType && homeBannerInfo.isNotEmpty) {
      await BannerViewDialog.show(BaseViewModel.getGlobalContext(),onClose:()=>advertisesDialogQueue(index: 3));
    }else{
      advertisesDialogQueue(index: 3);
    }
    //重置顯示右下 banner icon.
    ref.read(strikeUpBannerIconVisibleProvider.notifier).state = true;

  }
  _showStrikeUpListTeenDialog(MemberRegisterRes? memberRegisterRes,WsMemberInfoRes? memberInfo){
    if (memberRegisterRes != null && memberRegisterRes.benefit != null && memberInfo != null) {
      showDialog(
        context: BaseViewModel.getGlobalContext(),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StrikeUpListTeenDialog(onClose:(){},);
        },
      );
    }
    //因為只需要顯示一次，為避免下次登出再登入後又顯示，因此這邊清除掉這個 memberRegisterRes state
    if (memberRegisterRes != null) {
      ref.read(memberRegisterResProvider.notifier).clearState();
    }
  }

  List<BannerInfo> _filteredBannerInfoList({num? locatedPage}) {
    List<BannerInfo> returnList = [];
    WsBannerInfoRes? bannerInfoRes = ref.read(userUtilProvider).bannerInfo;

    if (bannerInfoRes != null && bannerInfoRes.list != null) {
      returnList.addAll(bannerInfoRes.list!.where((bannerInfo) {
        //檢查這個 bannerInfo 是否合法
        if (bannerInfo.status != 0) {
          return false;
        } else if (bannerInfo.startTime != null && bannerInfo.endTime != null) {
          //檢查時間
          DateTime startDateTime =
          DateTime.fromMillisecondsSinceEpoch(bannerInfo.startTime as int);
          DateTime endDateTime =
          DateTime.fromMillisecondsSinceEpoch(bannerInfo.endTime as int);
          //不在時限內，未開始或者已過期．
          if (DateTime.now().isAfter(endDateTime) ||
              DateTime.now().isBefore(startDateTime)) {
            return false;
          }
        }

        //所屬頁面過濾 (1 首頁)
        if (bannerInfo.locatedPage != 0 &&
            bannerInfo.locatedPage != locatedPage) {
          return false;
        }
        //防呆
        if (bannerInfo.activityBanner == null ||
            bannerInfo.activityBanner!.isEmpty) {
          return false;
        }

        return true;
      }));
    }

    return returnList;
  }
}