
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/analytics/trackingio/trackingio_analytics_manager.dart';
import 'package:frechat/system/authentication_manager.dart';
import 'package:frechat/system/call_authentication_manager/call_authentication_manager.dart';
import 'package:frechat/system/call_sync/call_sync_manager.dart';
import 'package:frechat/system/comm/comm.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_call_model.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/database/model/new_user_behavior_tracker_model.dart';
import 'package:frechat/system/database/model/visitor_time_model.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/deeplink/deeplink_manager.dart';
import 'package:frechat/system/message/chat_message_manager.dart';
import 'package:frechat/system/network_status/network_status_callback.dart';
import 'package:frechat/system/network_status/network_status_manager.dart';
import 'package:frechat/system/new_user_behavior_tracker/new_user_behavior_tracker_manager.dart';
import 'package:frechat/system/online_status/online_status_manager.dart';
import 'package:frechat/system/payment/app_payment_manager.dart';
import 'package:frechat/system/provider/member_register_res_provider.dart';
import 'package:frechat/system/strikeup_manager.dart';
import 'package:frechat/system/unread_message/unread_message_manager.dart';
import 'package:frechat/system/websocket/websocket_manager.dart';
import 'package:frechat/system/widget_binding/track_view.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/ws_comm/ws_activity.dart';
import 'package:frechat/system/ws_comm/ws_agent.dart';
import 'package:frechat/system/ws_comm/ws_banner.dart';
import 'package:frechat/system/ws_comm/ws_benefit.dart';
import 'package:frechat/system/ws_comm/ws_check_in.dart';
import 'package:frechat/system/ws_comm/ws_contact.dart';
import 'package:frechat/system/ws_comm/ws_customerservicehours.dart';
import 'package:frechat/system/ws_comm/ws_deposit.dart';
import 'package:frechat/system/ws_comm/ws_detail.dart';
import 'package:frechat/system/ws_comm/ws_greet.dart';
import 'package:frechat/system/ws_comm/ws_member.dart';
import 'package:frechat/system/ws_comm/ws_mission.dart';
import 'package:frechat/system/ws_comm/ws_notification.dart';
import 'package:frechat/system/ws_comm/ws_post_like.dart';
import 'package:frechat/system/ws_comm/ws_report.dart';
import 'package:frechat/system/ws_comm/ws_setting.dart';
import 'package:frechat/system/ws_comm/ws_visitor.dart';
import 'package:frechat/system/ws_comm/ws_withdraw.dart';

import '../models/user_info_model.dart';
import 'provider/user_info_provider.dart';

/// 專案內常用型的 provider 請集中放在此處，
/// 除非你有一個大量提供 provider 的狀況才在其他 feature 資料夾開自己的 provider 檔。

/// 使用 UserInfoModel 讀取使用這個Provider
final userInfoProvider = Provider<UserInfoModel>((ref) {
  final UserInfoModel userInfo = ref.watch(userUtilProvider);
  return userInfo;
});

/// WebSocket
final webSocketUtilProvider = Provider<WebSocketUtil>((ref) {
  return WebSocketUtil(ref: ref);
});

/// OpenInstall
final deepLinkProvider = Provider<DeepLinkManager>((ref) {
  return DeepLinkManager(ref: ref);
});

/// Analytics TrackingIOManager
final analyticsProvider = Provider<TrackingIOManager>((ref) {
    return TrackingIOManager(ref: ref);
});

/// authentication
final authenticationProvider = Provider<AuthenticationManager>((ref) {
  return AuthenticationManager(ref: ref);
});

/// trackNavigatorObserver
final trackNavigatorProvider = Provider<TrackNavigatorObserver>((ref) {
    return TrackNavigatorObserver(ref: ref);
});

final strikeUpProvider = Provider<StrikeUpManager>((ref) {
    return StrikeUpManager(ref: ref);
});

/// Dependency Inversion Design Pattern
/// 全部的方法用依賴反轉封裝

/// ws provider
Provider<AccountWs> accountWsProvider =
    Provider<AccountWs>((ref) => AccountWs(ref: ref));
Provider<NotificationWs> notificationWsProvider =
    Provider<NotificationWs>((ref) => NotificationWs(ref: ref));
Provider<MemberWs> memberWsProvider =
    Provider<MemberWs>((ref) => MemberWs(ref: ref));
Provider<ReportWs> reportWsProvider =
    Provider<ReportWs>((ref) => ReportWs(ref: ref));
Provider<ContactWs> contactWsProvider =
    Provider<ContactWs>((ref) => ContactWs(ref: ref));
Provider<DetailWs> detailWsProvider =
    Provider<DetailWs>((ref) => DetailWs(ref: ref));
Provider<DepositWs> depositWsProvider =
    Provider<DepositWs>((ref) => DepositWs(ref: ref));
Provider<WithdrawWs> withdrawWsProvider =
    Provider<WithdrawWs>((ref) => WithdrawWs(ref: ref));
Provider<SettingWs> settingWsProvider =
    Provider<SettingWs>((ref) => SettingWs(ref: ref));
Provider<CheckInWs> checkInWsProvider =
    Provider<CheckInWs>((ref) => CheckInWs(ref: ref));
Provider<MissionWs> missionWsProvider =
    Provider<MissionWs>((ref) => MissionWs(ref: ref));
Provider<GreetWs> greetWsProvider =
    Provider<GreetWs>((ref) => GreetWs(ref: ref));
Provider<AgentWs> agentWsProvider =
    Provider<AgentWs>((ref) => AgentWs(ref: ref));
Provider<BenefitWs> benefitWsProvider =
    Provider<BenefitWs>((ref) => BenefitWs(ref: ref));
Provider<BannerWs> bannerWsProvider = Provider<BannerWs>((ref) => BannerWs(ref: ref));
Provider<CustomerServiceHoursWs> customerServiceHoutWsProvider = Provider<CustomerServiceHoursWs>((ref) => CustomerServiceHoursWs(ref: ref));
Provider<ActivityWs> activityWsProvider = Provider<ActivityWs>((ref) => ActivityWs(ref: ref));
Provider<PostLikeWs> postLikeWsProvider = Provider<PostLikeWs>((ref) => PostLikeWs(ref: ref));
Provider<VisitorWs> visitorWsProvider = Provider<VisitorWs>((ref) => VisitorWs(ref: ref));

/// 支付用
Provider<AppPaymentManager> appPaymentManagerProvider = Provider<AppPaymentManager>((ref) => AppPaymentManager(ref: ref));

/// API provider
Provider<CommAPI> commApiProvider = Provider<CommAPI>((ref) => CommAPI(ref: ref));

/// sqflite provider
final chatCallModelProvider =
    Provider<ChatCallModel>((ref) => ChatCallModel(ref: ref));
final chatUserModelProvider =
    Provider<ChatUserModel>((ref) => ChatUserModel(ref: ref));
final chatMessageModelProvider =
    Provider<ChatMessageModel>((ref) => ChatMessageModel(ref: ref));
final chatImageModelProvider =
    Provider<ChatImageModel>((ref) => ChatImageModel(ref: ref));
final chatAudioModelProvider =
    Provider<ChatAudioModel>((ref) => ChatAudioModel(ref: ref));
final chatGiftModelProvider =
    Provider<ChatGiftModel>((ref) => ChatGiftModel(ref: ref));
final chatBlockModelProvider =
    Provider<ChatBlockModel>((ref) => ChatBlockModel(ref: ref));
final zegoBeautyModelProvider =
    Provider<ZegoBeautyModel>((ref) => ZegoBeautyModel(ref: ref));
final visitorTimeModelProvider =
    Provider<VisitorTimeModel>((ref) => VisitorTimeModel(ref: ref));
final newUserBehaviorModelProvider =
    Provider<NewUserBehaviorTrackerModel>((ref) => NewUserBehaviorTrackerModel(ref: ref));
final activityMessageModelProvider =
    Provider<ActivityMessageModel>((ref) => ActivityMessageModel(ref: ref));

/// 網路連線狀態
final networkManagerProvider = Provider<NetworkManager>((ref) => NetworkManager(ref: ref));
final networkCallbackProvider = Provider<NetworkStatusCallback>((ref) => NetworkStatusCallback(ref: ref));

/// 同步通話狀態
final callSyncManagerProvider = Provider<CallSyncManager>((ref) => CallSyncManager(ref: ref));

/// 用戶上線狀態
final onlineManagerProvider = Provider<OnlineStatusManager>((ref) => OnlineStatusManager(ref: ref));

/// 訊息未讀數
final unreadMessageManager = Provider<UnreadMessageManager>((ref) => UnreadMessageManager(ref: ref));

final newUserBehaviorManagerProvider = Provider<NewUserBehaviorTrackerManager>((ref) => NewUserBehaviorTrackerManager(ref: ref));

/// 傳送訊息
final chatMessageManager = Provider<ChatMessageManager>((ref) => ChatMessageManager(ref: ref));

/// call auth manager
final callAuthenticationManagerProvider = Provider<CallAuthenticationManager>((ref) => CallAuthenticationManager(ref: ref));

//When user strike up another user in various places. Notify the world.
final strikeUpUpdatedProvider = StateProvider<SearchListInfo?>((ref) => null);

//Strike up list banner visible. 目前是每次進入 Home 時會重置為 true.
final strikeUpBannerIconVisibleProvider = StateProvider<bool>((ref) => true);

final memberRegisterResProvider = StateNotifierProvider<MemberRegisterResStateNotifier, MemberRegisterRes?>((ref) {
    return MemberRegisterResStateNotifier();
});