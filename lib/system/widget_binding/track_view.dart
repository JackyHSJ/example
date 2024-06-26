
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/analytics/analytics_track_view.dart';
import 'package:frechat/screens/activity/activity_browser.dart';
import 'package:frechat/screens/call/calling_page.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/common_language.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/intimacy_dialog.dart';
import 'package:frechat/screens/message_tab/message_tab.dart';
import 'package:frechat/screens/personal_information/personal_information.dart';
import 'package:frechat/screens/phone_login/phone_login.dart';
import 'package:frechat/screens/profile/agent/personal_agent.dart';
import 'package:frechat/screens/profile/benefit/personal_benefit.dart';
import 'package:frechat/screens/profile/contact/personal_contact.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/screens/profile/edit/personal_edit.dart';
import 'package:frechat/screens/profile/friend/personal_friend.dart';
import 'package:frechat/screens/profile/greet/personal_greet.dart';
import 'package:frechat/screens/profile/personal_profile.dart';
import 'package:frechat/screens/profile/setting/personal_setting.dart';
import 'package:frechat/screens/strike_up_list/how2tv/strike_up_list_how2tv.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/screens/welcome.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class TrackNavigatorObserver extends NavigatorObserver {
  TrackNavigatorObserver({required this.ref});
  ProviderRef ref;

  /// A 登陸
  final String welcome = const Welcome().toString();
  final String phoneLogin = const PhoneLogin().toString();
  final String personalInformation = const PersonalInformation().toString();

  /// B 首頁
  final String strikeUpList = const StrikeUpList().toString();
  final String strikeUpListMate = const StrikeUpListMate(callType: ZegoCallType.voice).toString();
  final String strikeUpListHowToTv = const StrikeUpListHowToTv().toString();
  final String userInfoView = const UserInfoView(displayMode: DisplayMode.strikeUp).toString();

  /// C 動態
  final String activityBrowser = const ActivityBrowser().toString();

  /// D 消息
  final String messageTab = const MessageTab().toString();
  final String chatRoom = const ChatRoom().toString();
  final String intimacyDialog = const IntimacyDialog().toString();
  final String commonLanguage = const CommonLanguage().toString();
  final String callingPage = const CallingPage().toString();

  /// E 會員中心
  final String personalProfile = const PersonalProfile().toString();
  final String personalEdit = const PersonalEdit().toString();
  final String personalFriend = const PersonalFriend().toString();
  final String personalDeposit = const PersonalDeposit().toString();
  final String personalBenefit = PersonalBenefit(isFromBannerView: false).toString();
  final String personalContact = const PersonalContact().toString();
  final String personalGreet = const PersonalGreet().toString();
  final String personalSetting = const PersonalSetting().toString();
  final String personalAgent = const PersonalAgent().toString();

  /// Main Tab
  final String home = const Home(showAdvertise: false).toString();

  // late final List<String> _tabList = [strikeUpList, messageTab, 'video', personalProfile]

  int _timerCounter = 0;
  Timer? _timer;

  num previousMainTabIndex = 0;

  List<String> _getTabData() {
    final AppTheme nowTheme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    if(nowTheme!.themeType == AppThemeType.catVersion) {
      return [strikeUpList, messageTab, 'video', personalProfile];
    }
    return [strikeUpList, messageTab, personalProfile];
  }

  initAnalyticsNaviBarListenerForTab() {
    naviBarController?.addListener(() {
      final List<String> tabList = _getTabData();
      final String currentPageName = tabList[previousMainTabIndex.toInt()];


      /// 消息列表用
      if(currentPageName == messageTab) {
        final num index = messageTabController?.index ?? 0;
        _checkAndSendTrackForNotiTab(index: index);
        previousMainTabIndex = naviBarController?.page ?? 0;
        return ;
      }

      _sendTrackView(currentPageName: _convertToPageNameForMainTab(currentPageName));
      previousMainTabIndex = naviBarController?.page ?? 0;
    });
  }

  initAnalyticsMsgTabListenerForTab() {
    /// 防止重複進入用
    bool defenseDoubleCallback = true;
    messageTabController?.addListener(() {
      if(defenseDoubleCallback == false){
        defenseDoubleCallback = true;
        return ;
      }
      final num previousIndex = messageTabController?.previousIndex ?? 0;
      _sendTrackView(currentPageName: _convertToPageNameForNotiTabIndex(previousIndex));
      defenseDoubleCallback = false;
    });
  }

  String _convertToPageNameForMainTab(String pageName) {
    if(pageName == strikeUpList) {
      return '首页';
    }
    if(pageName == messageTab) {
      return '消息列表';
    }
    if(pageName == personalProfile) {
      return '会员中心';
    }
    return '';
  }

  String _convertToPageNameForNotiTabIndex(num currentPage) {
    if(currentPage == 0) {
      return '消息页Tab(消息)';
    }
    if(currentPage == 1) {
      return '消息页Tab(亲密)';
    }
    if(currentPage == 2) {
      return '消息页Tab(通话)';
    }
    return '';
  }

  _initTimer() {
    if(_timer != null) {
      return ;
    }
    _timer = TimerUtil.periodic(timerType: TimerType.seconds, timerNum: 1, timerCallback: (timer){
      _timerCounter++;
    });
  }

  // _disposeTimer() {
  //   if(_timer == null) {
  //     return ;
  //   }
  //   _timer?.cancel();
  //   _timer == null;
  // }

  void _sendTrackView({
    required String currentPageName
  }) {
    final Map<String, dynamic> properties = AnalyticsTrackView(timestamp: DateTime.now().millisecondsSinceEpoch).toMap();
    ref.read(analyticsProvider).trackView(currentPageName, _timerCounter, properties);
    _timerCounter = 0;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String routeName = route.settings.name ?? '';
    final String previousPageName = previousRoute?.settings.name ?? '';
    final Object arguments = previousRoute?.settings.arguments ?? Object();
    if(routeName == '' || previousPageName == '') {
      return ;
    }
    _initTimer();
    _checkAndSendTrack(currentPageName: previousPageName, arguments: arguments);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final String previousPageName = previousRoute?.settings.name ?? '';
    final String routeName = route.settings.name ?? '';
    final Object? arguments = route.settings.arguments;
    route.overlayEntries.length == 2;
    if(routeName == '' || previousPageName == '') {
      return ;
    }
    _checkAndSendTrack(currentPageName: routeName, arguments: arguments);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _timerCounter = 0;
    super.didRemove(route, previousRoute);
  }

  _checkAndSendTrackForMainTab({required String currentPageName}) {
    if(currentPageName == home) {
      final List<String> tabList = _getTabData();
      final String pageName = tabList[previousMainTabIndex.toInt()];

      /// 消息列表用
      if(pageName == messageTab) {
        final num previousIndex = messageTabController?.previousIndex ?? 0;
        _checkAndSendTrackForNotiTab(index: previousIndex);
        return ;
      }

      _sendTrackView(currentPageName: _convertToPageNameForMainTab(pageName));
    }
  }

  _checkAndSendTrackForNotiTab({required num index}) {
    _sendTrackView(currentPageName: _convertToPageNameForNotiTabIndex(index));
  }

  _checkAndSendTrack({
    required String currentPageName, Object? arguments
  }) {
    _checkAndSendTrackForMainTab(currentPageName: currentPageName);

    /// A 登陸
    if(currentPageName == welcome) {
      _sendTrackView(currentPageName: '注册/登陆');

    } else if(currentPageName == phoneLogin) {
      _sendTrackView(currentPageName: '手机验证码登陆');

    } else if(currentPageName == personalInformation) {
      _sendTrackView(currentPageName: '完善信息');

      /// B 首頁
    } else if(currentPageName == strikeUpListMate) {
      ZegoCallType callType = ZegoCallType.video;
      if(arguments is ZegoCallType) {
        callType = arguments;
      }
      final String callTypeName = callType == ZegoCallType.video ? '视讯' : '语音';
      _sendTrackView(currentPageName: callTypeName + '速配');

    } else if(currentPageName == strikeUpListHowToTv) {
      _sendTrackView(currentPageName: '上电视说明');

    } else if(currentPageName == userInfoView) {
      _sendTrackView(currentPageName: '用户个人信息');

      /// C 動態
    } else if(currentPageName == activityBrowser) {
      _sendTrackView(currentPageName: '动态墙');

      /// D 消息
    } else if(currentPageName == chatRoom) {
      _sendTrackView(currentPageName: '文字互动');

    } else if(currentPageName == intimacyDialog){
      _sendTrackView(currentPageName: '亲密度说明');

    } else if(currentPageName == commonLanguage){
      _sendTrackView(currentPageName: '常用语设置');

    } else if(currentPageName == callingPage){
      ZegoCallData? callData;
      if(arguments is ZegoCallData) {
        callData = arguments;
      }

      final String callTypeName = callData?.callType == ZegoCallType.video ? '视讯' : '语音';
      _sendTrackView(currentPageName: callTypeName + '通话');

      /// E 會員中心
    } else if(currentPageName == personalEdit) {
      _sendTrackView(currentPageName: '编辑资料');

    } else if(currentPageName == personalFriend) {
      _sendTrackView(currentPageName: '好友列表');

    } else if(currentPageName == personalDeposit) {
      _sendTrackView(currentPageName: '我的充值');

    } else if(currentPageName == personalBenefit) {
      _sendTrackView(currentPageName: '我的收益');

    } else if(currentPageName == personalContact) {
      _sendTrackView(currentPageName: '我的人脉');

    } else if(currentPageName == personalGreet) {
      _sendTrackView(currentPageName: '招呼设置');

    } else if(currentPageName == personalSetting) {
      _sendTrackView(currentPageName: '系统设置');

    } else if(currentPageName == personalAgent) {
      _sendTrackView(currentPageName: '推广中心');
    }
  }
}